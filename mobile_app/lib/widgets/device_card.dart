import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget thumbnail;
  const DeviceCard(
      {required this.title,
      required this.subtitle,
      required this.thumbnail,
      super.key});

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
                thumbnail,
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
