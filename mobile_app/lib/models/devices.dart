import 'package:flutter/material.dart'
    show Color, IconData, Widget, Colors, Icon, Icons, Image;
import '../widgets/device_card.dart';

class Device {
  String name;
  final String macAddress;

  Widget getIcon() {
    return const Icon(
      Icons.bluetooth,
      color: Colors.grey,
      size: 175,
    );
  }

  Widget getCard() {
    return DeviceCard(device: this);
  }

  Device({required this.name, required this.macAddress});
}

class PairedDevice extends Device {
  IconData icon;
  Color iconColor;

  PairedDevice(
      {required super.name,
      required super.macAddress,
      this.icon = Icons.bluetooth,
      this.iconColor = Colors.green});

  @override
  Widget getIcon() {
    return Icon(
      icon,
      color: iconColor,
      size: 175,
    );
  }
}

class Robot extends PairedDevice {
  String? imagePath;
  String description = "A Saved Robot";

  Robot({
    required super.name,
    required super.macAddress,
    super.icon = Icons.smart_toy,
    super.iconColor = Colors.blue,
    this.description = "A Saved Robot",
    String? imagePath,
  });

  @override
  Widget getIcon() {
    return (imagePath != null)
        ? Image.asset(imagePath!, height: 175)
        : super.getIcon();
  }
}
