import 'package:flutter/material.dart';
import '../widgets/device_set.dart';
import '../models/robot.dart';

class Nearby extends StatelessWidget {
  final List<Robot> robots = dummies;

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
          robots: robots,
        ),
        DeviceSet(
          heading: "Paired Devices",
          robots: robots,
        ),
        DeviceSet(
          heading: "Foreign Devices",
          robots: robots,
        ),
      ]),
    ));
  }
}
