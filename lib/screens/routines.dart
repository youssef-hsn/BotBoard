import 'dart:convert';
import 'package:botboard/models/devices.dart';
import 'package:flutter/material.dart';
import 'package:botboard/screens/device_details.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class RoutinesView extends StatefulWidget {
  const RoutinesView({super.key});

  @override
  State<RoutinesView> createState() => _RoutinesViewState();
}

class _RoutinesViewState extends State<RoutinesView> {
  bool apiUp = false;
  Box prefrences = Hive.box('preferences');
  Box savedDevices = Hive.box('savedDevices');
  Box deviceMappings = Hive.box('deviceMappings');

  var routines = [];

  void getRoutines() async {
    try {
      final response = await http.get(
        Uri.parse('${prefrences.get('apiHost')}/api/routines/all'),
        headers: {
          'Authorization': 'Bearer ${prefrences.get('JWT')}',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        Map<String, List> dayRoutines = {};

        result.forEach((routine) {
          String day = "Today";
          print(routine["last_done"]);
          if (routine["last_done"] != null) {
            DateTime lastDone = DateTime.parse(routine["last_done"]);
            DateTime now = DateTime.now();
            Duration difference = now.difference(lastDone);
            if (difference.inDays > routine["frequency"]) {
              day = (lastDone.add(Duration(days: routine["frequency"])))
                  .toString();
            }
          }

          if (dayRoutines[day] is List) {
            dayRoutines[day]!.add(routine);
          } else {
            dayRoutines[day] = [routine];
          }
        });

        dayRoutines.forEach((day, todo) {
          routines.add(day);
          for (var routine in todo) {
            routines.add(routine);
          }
        });
      } else {
        routines = [];
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkApi();
    getRoutines();
  }

  void checkApi() async {
    try {
      Box prefrences = Hive.box('preferences');
      String apiHost = prefrences.get('apiHost');

      final response = await http.get(Uri.parse('$apiHost/up'));
      setState(() {
        apiUp = response.statusCode == 200;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routines"),
      ),
      body: apiUp
          ? routines.length > 0
              ? ListView.builder(
                  itemCount: routines.length,
                  itemBuilder: (context, index) {
                    if (routines[index] is String) {
                      return Column(
                        children: [
                          const Divider(),
                          ListTile(
                            title: Text(routines[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                          ),
                        ],
                      );
                    }

                    return ListTile(
                      title: Text(routines[index]["title"]),
                      subtitle: Text(routines[index]["description"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.question_mark),
                            onPressed: () {
                              String? deviceMac = deviceMappings.get(
                                routines[index]["device_id"],
                              );

                              if (deviceMac == null) {
                                print(
                                    'Device MAC not found for device_id: ${routines[index]["device_id"]}');
                                return;
                              }

                              PairedDevice? device =
                                  savedDevices.get(deviceMac);

                              if (device == null) {
                                print(
                                    'Paired device not found for MAC address: $deviceMac');
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DeviceDetails(device: device),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle),
                            onPressed: () async {
                              routines[index]["last_done"] =
                                  DateTime.now().toIso8601String();
                              setState(() {});

                              await http.put(
                                Uri.parse(
                                    '${prefrences.get('apiHost')}/api/routines/${routines[index]["id"]}'),
                                headers: {
                                  'Authorization':
                                      'Bearer ${prefrences.get('JWT')}',
                                },
                                body: jsonEncode(routines[index]),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No routines found"),
                      Text("Create a routine to get started"),
                    ],
                  ),
                )
          : const Center(
              child: Text("Failed to connect to API"),
            ),
    );
  }
}
