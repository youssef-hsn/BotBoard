import 'package:flutter/material.dart'
    show Color, IconData, Widget, Colors, Icon, Icons, Image;
import '../widgets/device_card.dart';

class Device {
  String name;
  final String macAddress;

  Device({required this.name, required this.macAddress});

  String get description => "A Foreign Device with mac address $macAddress";

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
}

class PairedDevice extends Device {
  IconData icon;
  Color iconColor;

  @override
  String get description => "A Paired Device with mac address $macAddress";

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
  @override
  String description;

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
