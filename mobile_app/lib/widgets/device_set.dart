import 'package:BotBoard/models/devices.dart';
import 'package:flutter/material.dart';

class DeviceSet extends StatelessWidget {
  final String heading;
  final List<Device> devices;

  const DeviceSet({
    required this.heading,
    required this.devices,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return devices.isEmpty
        ? Container()
        : Padding(
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
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    return devices[index].getCard();
                  },
                ),
              ],
            ),
          );
  }
}
