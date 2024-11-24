import 'package:flutter/material.dart';
import 'package:botboard/widgets/device_set.dart';
import 'package:botboard/models/devices.dart';
import 'package:botboard/models/dummies.dart' as sample;

class Nearby extends StatelessWidget {
  final List<Device> devices = sample.devices;
  final List<PairedDevice> pairedDevices = sample.pairedDevices;
  final List<Robot> robots = sample.robots;

  Nearby({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Robots'),
      ),
      body: ListView(children: [
        DeviceSet(
          heading: "Paired Robots",
          devices: robots,
        ),
        DeviceSet(
          heading: "Paired Devices",
          devices: pairedDevices,
        ),
        DeviceSet(
          heading: "Foreign Devices",
          devices: devices,
        ),
      ]),
    ));
  }
}
