import 'package:hive/hive.dart';

import 'package:flutter/material.dart'
    show Color, IconData, Widget, Colors, Icon, Icons;
import 'package:botboard/widgets/device_card.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart'
    show BluetoothDevice;

part 'devices.g.dart';

@HiveType(typeId: 1)
class Device {
  @HiveField(0)
  String name;
  @HiveField(1)
  final String macAddress;
  @HiveField(2, defaultValue: 0)
  int? rssi;

  Device({required this.name, required this.macAddress});
  factory Device.fromBTDevice({required BluetoothDevice device}) {
    Device d =
        Device(name: device.name ?? "No Name", macAddress: device.address);
    d.rssi = device.rssi;
    return d;
  }

  @HiveField(3)
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

@HiveType(typeId: 2)
class PairedDevice extends Device {
  @HiveField(4)
  int icon;
  @HiveField(5)
  int iconColor;

  @override
  String get description => "A Paired Device with mac address $macAddress";

  PairedDevice(
      {required super.name,
      required super.macAddress,
      this.icon = 57572,
      this.iconColor = 0xFF00FF00});
  @override
  factory PairedDevice.fromBTDevice({required BluetoothDevice device}) {
    PairedDevice d = PairedDevice(
      name: device.name ?? "No Name",
      macAddress: device.address,
    );
    d.rssi = device.rssi;
    return d;
  }

  @override
  Widget getIcon() {
    return Icon(
      IconData(icon, fontFamily: 'MaterialIcons'),
      color: Color(iconColor),
      size: 175,
    );
  }
}

@HiveType(typeId: 3)
class Robot extends PairedDevice {
  @override
  String description;

  Robot({
    required super.name,
    required super.macAddress,
    super.icon = 58821,
    super.iconColor = 0xFF2196F3,
    this.description = "A Saved Robot",
  });
}
