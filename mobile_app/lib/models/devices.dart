import 'package:flutter/material.dart'
    show Color, IconData, Widget, Colors, Icon, Icons;
import '../widgets/device_card.dart';

class Device {
  String name;
  final String macAddress;

  Widget getIcon() {
    return const Icon(
      Icons.bluetooth,
      color: Colors.grey,
      size: 175,
    );
  }

  Widget getCard() {
    return DeviceCard(
      title: name,
      subtitle: "Foreign Device ($macAddress)",
      thumbnail: getIcon(),
    );
  }

  Device({required this.name, required this.macAddress});
}

class PairedDevice extends Device {
  IconData icon;
  Color iconColor;

  PairedDevice(
      {required super.name,
      required super.macAddress,
      this.icon = Icons.bluetooth,
      this.iconColor = Colors.green});

  @override
  Widget getIcon() {
    return Icon(
      icon,
      color: iconColor,
      size: 175,
    );
  }

  @override
  Widget getCard() {
    return DeviceCard(
      title: name,
      subtitle: "Paired Device ($macAddress)",
      thumbnail: getIcon(),
    );
  }
}
