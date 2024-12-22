import 'package:botboard/models/devices.dart';
import 'package:flutter/material.dart' show Icons, Colors;

List<Robot> robots = [
  Robot(
    "Kitchen Cooker",
    "macAddress",
    description:
        "101-year old robot that has been in the kitchen for 100 years.",
    iconColor: Colors.lightBlue.value,
  ),
  Robot(
    "Robotic Arm",
    "macAddress",
    icon: Icons.precision_manufacturing.codePoint,
  ),
];
List<Device> devices = [
  Device("Apple Pencil Two", "A4:50:46:33:1D:4E"),
  Device("Apple Pencil One", "A4:50:46:23:1D:5E"),
];

List<PairedDevice> pairedDevices = [
  PairedDevice(
    "Galaxy Watch 6 Classic",
    "A4:50:46:23:2D:4E",
    icon: Icons.watch.codePoint,
  ),
  PairedDevice(
    "Toyota Mercedes Radio",
    "A4:50:46:23:2D:5E",
    iconColor: Colors.red.value,
  ),
];
