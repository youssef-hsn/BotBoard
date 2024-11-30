import 'package:flutter/material.dart';

class IconEditor extends StatelessWidget {
  int selectedIcon;
  IconEditor({
    required this.selectedIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<IconData> iconOptions = [
      Icons.smart_toy,
      Icons.bluetooth,
      Icons.devices,
      Icons.headset,
      Icons.speaker,
      Icons.phone_android,
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
                selectedIcon = option.codePoint;
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () => Navigator.pop(context, selectedIcon),
          )
        ]);
  }
}