import 'package:flutter/material.dart';
import '../models/robot.dart';

class DeviceSet extends StatelessWidget {
  final String heading;
  final List<Robot> robots; // Replace with your robot model class if available

  const DeviceSet({
    required this.heading,
    required this.robots,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text(
              heading,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Grid
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two columns
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.68,
            ),
            itemCount: robots.length,
            itemBuilder: (context, index) {
              return robots[index].getCard();
            },
          ),
        ],
      ),
    );
  }
}
