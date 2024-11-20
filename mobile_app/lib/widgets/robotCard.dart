import 'package:flutter/material.dart';
import '../models/robot.dart';

class RobotCard extends StatelessWidget {
  final Robot robot;
  const RobotCard({required this.robot, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: robot.getIcon(),
      title: Text(robot.name),
    );
  }
}
