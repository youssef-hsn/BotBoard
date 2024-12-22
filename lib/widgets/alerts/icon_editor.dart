import 'package:flutter/material.dart';

class IconEditor extends StatelessWidget {
  final int selectedIcon;
  const IconEditor(this.selectedIcon, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<IconData> iconOptions = [
      Icons.smart_toy,
      Icons.android,
      Icons.hardware,
      Icons.devices,
      Icons.settings_remote,
      Icons.miscellaneous_services,
      Icons.bluetooth_connected,
      Icons.wifi,
      Icons.cast_connected,
      Icons.construction,
      Icons.precision_manufacturing,
      Icons.handyman,
      Icons.face,
      Icons.emoji_objects,
      Icons.toys,
      Icons.watch,
    ];

    return AlertDialog(
        title: const Text('Select Icon'),
        content: Wrap(
          spacing: 10,
          children: iconOptions.map((option) {
            return GestureDetector(
              child: Icon(
                option,
                color: option.codePoint == selectedIcon
                    ? Colors.green
                    : Colors.grey,
                size: 50,
              ),
              onTap: () {
                Navigator.pop(context, option.codePoint);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          )
        ]);
  }
}
