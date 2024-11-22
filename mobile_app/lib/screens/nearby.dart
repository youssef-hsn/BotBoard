import 'package:flutter/material.dart';
import '../widgets/device_set.dart';
import '../models/devices.dart';
import '../models/robot.dart';

class Nearby extends StatelessWidget {
  final List<Device> devices = [];
  final List<PairedDevice> pairedDevices = [];
  final List<Robot> robots = dummies;

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
