import 'package:flutter/material.dart';

class TextEditor extends StatelessWidget {
  final String title;
  final String text;
  const TextEditor({
    required this.title,
    required this.text,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    String newText = text;
    return (AlertDialog(
      title: Text(title),
      content: TextField(
        decoration: InputDecoration(
          hintText: text,
        ),
        onChanged: (value) {
          newText = value;
        },
        onSubmitted: (value) => Navigator.pop(context, newText),
      ),
      actions: [
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            Navigator.pop(context, newText);
          },
        ),
      ],
    ));
  }
}
