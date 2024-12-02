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
  String _name;
  @HiveField(1)
  final String macAddress;
  @HiveField(2, defaultValue: 0)
  int? rssi;

  String get name => _name;
  set name(String newName) {
    if (newName.isEmpty || _name.length > 26) {
      newName = "Invalid Name";
    }

    _name = newName;
  }

  Device(this._name, this.macAddress);
  factory Device.fromBTDevice({required BluetoothDevice device}) {
    Device d = Device(device.name ?? "No Name", device.address);
    d.rssi = device.rssi;
    return d;
  }

  String get description => "A Foreign Device with mac address $macAddress";
  set description(String newDescription) {}

  @HiveField(3)
  int icon = Icons.bluetooth.codePoint;

  get iconColor => Colors.grey.value;

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
    super._name,
    super.macAddress, {
    this.icon = 57572,
    this.iconColor = 0xFF00FF00,
  });
  @override
  factory PairedDevice.fromBTDevice({required BluetoothDevice device}) {
    PairedDevice d = PairedDevice(
      device.name ?? "No Name",
      device.address,
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
  @HiveField(6)
  String description;

  Robot(
    super._name,
    super.macAddress, {
    super.icon = 58821,
    super.iconColor = 0xFF2196F3,
    this.description = "A Saved Robot",
  });
}
