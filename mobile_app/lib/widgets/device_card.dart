import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final title;
  final subtitle;
  final icon;
  final color;
  const DeviceCard(
      {this.title, this.subtitle, this.icon, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 175,
                ),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ));
  }
}
