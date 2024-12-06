import 'dart:convert';

import 'package:botboard/models/devices.dart';
import 'package:botboard/widgets/chat/message.dart';
import 'package:botboard/widgets/chat/message_list.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter/material.dart';

class BluetoothTerminal extends StatefulWidget {
  final Device device;
  final BluetoothConnection? connection;
  const BluetoothTerminal(this.device, this.connection, {super.key});

  @override
  State<BluetoothTerminal> createState() => _BluetoothTerminalState();
}

class _BluetoothTerminalState extends State<BluetoothTerminal> {
  List<Message> messages = [];
  String message = "";
  @override
  void initState() {
    super.initState();
    // widget.connection.input?.listen((input) {
    //   messages.add(Message(
    //       IconData(widget.device.icon, fontFamily: 'MaterialIcons'),
    //       input.toString()));
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    // widget.connection.dispose();
    super.dispose();
  }

  void sendMessage(String m) {
    if (m.isEmpty) return;
    messages.add(Message(Icons.arrow_right, m));
    // widget.connection.output.add(utf8.encode(m));
    message = "";

    if (widget.connection == null) {
      messages.add(Message(
        IconData(widget.device.icon, fontFamily: 'MaterialIcons'),
        "I recieved a message: '$m' from you!",
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Terminal"),
      ),
      body: Column(
        children: [
          Expanded(child: MessageList(messages)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: message),
                    decoration:
                        const InputDecoration(hintText: "Enter a message..."),
                    onChanged: (value) => message = value,
                    onSubmitted: (value) {
                      sendMessage(message);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage(message);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
