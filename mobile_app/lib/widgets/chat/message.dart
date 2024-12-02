import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final IconData icon;
  final String message;
  const Message(this.icon, this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        icon,
        size: 20,
      ),
      Expanded(child: Text(message)),
    ]);
  }
}
