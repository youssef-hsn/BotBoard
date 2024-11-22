import 'package:BotBoard/models/devices.dart';
import 'package:flutter/material.dart' show Widget, Colors, Image, Icons;
import '../widgets/device_card.dart';

class Robot extends PairedDevice {
  String? imagePath;
  String description = "A Saved Robot";

  Robot({
    required super.name,
    required super.macAddress,
    super.icon = Icons.smart_toy,
    super.iconColor = Colors.blue,
    String description = "A Saved Robot",
    String? imagePath,
  });

  @override
  Widget getIcon() {
    return (imagePath != null)
        ? Image.asset(imagePath!, height: 175)
        : super.getIcon();
  }

  @override
  Widget getCard() {
    return DeviceCard(
      title: name,
      subtitle: description,
      thumbnail: getIcon(),
    );
  }
}

List<Robot> dummies = [
  Robot(
    name: "Kitchen Cooker",
    macAddress: "macAddress",
    description:
        "101-year old robot that has been in the kitchen for 100 years.",
  ),
  Robot(
    name: "Robotic Arm",
    macAddress: "macAddress",
    icon: Icons.front_hand,
    description: "",
  ),
];
