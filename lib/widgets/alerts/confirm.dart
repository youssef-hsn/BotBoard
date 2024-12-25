import 'package:flutter/material.dart';

class ConfirmationAlert extends StatelessWidget {
  final String consequences;
  const ConfirmationAlert({super.key, required this.consequences});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmation Needed."),
      content: Text("$consequences\nDo you want to proceed?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
