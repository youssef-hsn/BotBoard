import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:botboard/models/devices.dart' show Device;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class CreateRoutineView extends StatefulWidget {
  final Device device;
  const CreateRoutineView(this.device, {super.key});

  @override
  State<CreateRoutineView> createState() => _CreateRoutineViewState();
}

class _CreateRoutineViewState extends State<CreateRoutineView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController intervalController = TextEditingController();

  Box deviceMapping = Hive.box('deviceMappings');
  Box prefrences = Hive.box('preferences');

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Routine"),
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 300,
              child: Stack(children: [
                widget.device.getCard(tappable: false),
                const Positioned(
                  top: -5,
                  right: -5,
                  child: Icon(
                    Icons.construction,
                    color: Colors.teal,
                    size: 50,
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                ),
                Row(
                  children: [
                    const Text('Every'),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 30,
                      child: TextField(
                        controller: intervalController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Text('days'),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter a title"),
                  ),
                );
                return;
              }
              if (intervalController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter an interval"),
                  ),
                );
                return;
              }

              int days = int.parse(intervalController.text);

              if (days < 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Interval must be greater than 0"),
                  ),
                );
                return;
              }

              if (days > 365) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Interval must be less than a year"),
                  ),
                );
                return;
              }

              int? deviceID = deviceMapping.get(widget.device.macAddress);

              if (deviceID == null) {
                final res = await http.post(
                  Uri.parse("${prefrences.get('apiHost')}/api/devices"),
                  headers: {
                    "Authorization": "Bearer ${prefrences.get('JWT')}",
                  },
                );

                if (res.statusCode == 200) {
                  deviceID = jsonDecode(res.body)["device_id"];
                  deviceMapping.put(widget.device.macAddress, deviceID);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to create device"),
                    ),
                  );
                  return;
                }
              }

              final res = await http.post(
                Uri.parse(
                  "${prefrences.get('apiHost')}"
                  "/api/devices/$deviceID/routines",
                ),
                headers: {
                  "Authorization": "Bearer ${prefrences.get('JWT')}",
                  "Content-Type": "application/json",
                },
                body: jsonEncode({
                  "title": titleController.text,
                  "description": descriptionController.text,
                  "frequency": days,
                }),
              );

              if (res.statusCode == 200) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to create routine"),
                  ),
                );
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}
