import 'package:flutter/material.dart'
    show Color, IconData, Widget, Colors, Image, Icon, Icons;
import '../widgets/robotCard.dart';

class Robot {
  String name;
  final String macAddress;
  IconData? icon;
  Color iconColor;
  String? imagePath;
  String description;

  Robot({
    required this.name,
    required this.macAddress,
    this.icon = Icons.smart_toy,
    this.iconColor = Colors.blue,
    this.imagePath,
    required this.description,
  });

  Widget getIcon() {
    return (imagePath != null)
        ? Image.asset(imagePath!)
        : Icon(icon, color: iconColor);
  }

  Widget getCard() {
    return RobotCard(robot: this);
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
