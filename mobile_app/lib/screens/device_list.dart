import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:botboard/widgets/device_set.dart';
import 'package:botboard/models/devices.dart' show PairedDevice, Robot;

class DeviceList extends StatelessWidget {
  const DeviceList({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('savedDevices');

    Set<Robot> robots = {};
    Set<PairedDevice> pairedDevices = {};

    for (var device in box.values) {
      if (device is PairedDevice) {
        pairedDevices.add(device);
      } else if (device is Robot) {
        robots.add(device);
      }
    }

    return (MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Registered Robots'),
        ),
        body: ListView(children: [
          DeviceSet(
            heading: "Robots",
            devices: robots,
          ),
          DeviceSet(
            heading: "Paired Devices",
            devices: pairedDevices,
          ),
        ]),
      ),
    ));
  }
}
