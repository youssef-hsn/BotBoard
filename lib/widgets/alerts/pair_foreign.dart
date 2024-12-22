import 'package:flutter/material.dart';

class PairForeign extends StatefulWidget {
  const PairForeign({super.key});

  @override
  State<PairForeign> createState() => _PairForeignState();
}

class _PairForeignState extends State<PairForeign> {
  bool _isRobot = false;
  String description = "A saved Robot";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pair Foreign Device'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'should this device be directly upgraded into a robot?',
          ),
          ListTile(
            title: const Text('This is a robot'),
            leading: Radio(
                value: true,
                groupValue: _isRobot,
                onChanged: (value) => setState(() => _isRobot = value!)),
          ),
          ListTile(
            title: const Text('This is just a normal device'),
            leading: Radio(
                value: false,
                groupValue: _isRobot,
                onChanged: (value) => setState(() => _isRobot = value!)),
          ),
          _isRobot
              ? TextField(
                  decoration: const InputDecoration(
                    hintText: "Enter a description for this device (optional)",
                  ),
                  onChanged: (value) => description = value,
                  onSubmitted: (value) => Navigator.pop(context, description),
                )
              : const Text("This will be assumed as a normal device")
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, "");
          },
        ),
        TextButton(
          child: const Text('Pair'),
          onPressed: () {
            Navigator.pop(context, description);
          },
        ),
      ],
    );
  }
}
