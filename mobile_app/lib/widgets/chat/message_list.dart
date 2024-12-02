import 'package:botboard/widgets/chat/message.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  const MessageList(this.messages, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return messages[index];
      },
    );
  }
}
