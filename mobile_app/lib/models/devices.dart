import 'package:flutter/material.dart'
    show Color, IconData, Widget, Colors, Icon, Icons, Image;
import 'package:botboard/widgets/device_card.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart'
    show BluetoothDevice;

class Device {
  String name;
  final String macAddress;
  int? rssi;

  Device({required this.name, required this.macAddress});
  factory Device.fromBTDevice({required BluetoothDevice device}) {
    Device d =
        Device(name: device.name ?? "No Name", macAddress: device.address);
    d.rssi = device.rssi;
    return d;
  }

  String get description => "A Foreign Device with mac address $macAddress";

  Widget getIcon() {
    return const Icon(
      Icons.bluetooth,
      color: Colors.grey,
      size: 175,
    );
  }

  Widget getCard() {
    return DeviceCard(device: this);
  }
}

class PairedDevice extends Device {
  IconData icon;
  Color iconColor;

  @override
  String get description => "A Paired Device with mac address $macAddress";

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
}

class Robot extends PairedDevice {
  @override
  String description;

  Robot({
    required super.name,
    required super.macAddress,
    super.icon = Icons.smart_toy,
    super.iconColor = Colors.blue,
    this.description = "A Saved Robot",
  });
}
