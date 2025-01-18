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

  PairedDevice getDevice(int deviceID) {
    String deviceMac = deviceMappings.get(deviceID);
    return savedDevices.get(deviceMac) as PairedDevice;
  }

  void getRoutines() async {
    routines = [];
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
          if (routine["last_done"] != null) {
            DateTime lastDone = DateTime.parse(routine["last_done"]);
            DateTime now = DateTime.now();
            Duration difference = now.difference(lastDone);
            if (difference.inDays < routine["frequency"]) {
              DateTime nextTime =
                  lastDone.add(Duration(days: routine["frequency"]));
              day = "${nextTime.day.toString().padLeft(2, '0')}"
                  "/${nextTime.month.toString().padLeft(2, '0')}"
                  "/${nextTime.year}";
            }
          }

          if (dayRoutines[day] is List) {
            dayRoutines[day]!.add(routine);
          } else {
            dayRoutines[day] = [routine];
          }
        });

        List<String> days = dayRoutines.keys.toList()..sort();
        if (days.contains("Today")) {
          days.remove("Today");
          days.insert(0, "Today");
        }

        for (var day in days) {
          routines.add(day);
          for (var routine in dayRoutines[day]!) {
            routines.add(routine);
          }
        }
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
                      leading: GestureDetector(
                        child: Column(
                          children: [
                            Hero(
                              tag:
                                  "icon-${deviceMappings.get(routines[index]["device_id"])}",
                              child: getDevice(routines[index]["device_id"])
                                  .getIcon(size: 50),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeviceDetails(
                                  device:
                                      getDevice(routines[index]["device_id"]))),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle),
                            onPressed: () async {
                              await http.patch(
                                  Uri.parse(
                                      '${prefrences.get('apiHost')}/api/routines'
                                      '/${routines[index]["routine_id"]}/done'),
                                  headers: {
                                    'Authorization':
                                        'Bearer ${prefrences.get('JWT')}',
                                  });
                              getRoutines();
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
