import 'package:botboard/models/devices.dart';
import 'package:flutter/material.dart' show Icons, Colors;

List<Robot> robots = [
  Robot(
    name: "Kitchen Cooker",
    macAddress: "macAddress",
    description:
        "101-year old robot that has been in the kitchen for 100 years.",
    iconColor: Colors.lightBlue,
  ),
  Robot(
    name: "Robotic Arm",
    macAddress: "macAddress",
    icon: Icons.precision_manufacturing,
  ),
];

List<Device> devices = [
  Device(name: "Apple Pencil Two", macAddress: "A4:50:46:23:1D:4E"),
  Device(name: "Apple Pencil One", macAddress: "A4:50:46:23:1D:5E"),
];

List<PairedDevice> pairedDevices = [
  PairedDevice(
    name: "Galaxy Watch 6 Classic",
    macAddress: "A4:50:46:23:2D:4E",
    icon: Icons.watch,
  ),
  PairedDevice(
    name: "Toyota Mercedes Radio",
    macAddress: "A4:50:46:23:2D:5E",
    iconColor: Colors.red,
  ),
];
