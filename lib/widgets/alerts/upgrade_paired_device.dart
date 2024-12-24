import 'package:flutter/material.dart';
import 'package:botboard/models/devices.dart' show Device;

class UpgradePairedDevice extends StatelessWidget {
  final Device device;
  const UpgradePairedDevice(this.device, {super.key});

  @override
  Widget build(BuildContext context) {
    String description = "A saved Device with macAddress: ${device.macAddress}";
    return AlertDialog(
      title: const Text('Upgrade Paired Device'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to upgrade this device?'),
          TextField(
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "Enter a description for this device (optional)",
            ),
            onChanged: (value) => description = value,
            onSubmitted: (value) => Navigator.pop(context, description),
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Upgrade'),
          onPressed: () {
            Navigator.pop(context, description);
          },
        ),
      ],
    );
  }
}
