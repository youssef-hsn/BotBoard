// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final int typeId = 1;

  @override
  Device read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Device(
      fields[0] as String,
      fields[1] as String,
    )
      ..rssi = fields[2] == null ? 0 : fields[2] as int?
      ..icon = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._name)
      ..writeByte(1)
      ..write(obj.macAddress)
      ..writeByte(2)
      ..write(obj.rssi)
      ..writeByte(3)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PairedDeviceAdapter extends TypeAdapter<PairedDevice> {
  @override
  final int typeId = 2;

  @override
  PairedDevice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PairedDevice(
      fields[0] as String,
      fields[1] as String,
      icon: fields[4] as int,
      iconColor: fields[5] as int,
    )..rssi = fields[2] == null ? 0 : fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, PairedDevice obj) {
    writer
      ..writeByte(5)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.iconColor)
      ..writeByte(0)
      ..write(obj._name)
      ..writeByte(1)
      ..write(obj.macAddress)
      ..writeByte(2)
      ..write(obj.rssi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PairedDeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RobotAdapter extends TypeAdapter<Robot> {
  @override
  final int typeId = 3;

  @override
  Robot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Robot(
      fields[0] as String,
      fields[1] as String,
      icon: fields[4] as int,
      iconColor: fields[5] as int,
      description: fields[6] as String,
    )..rssi = fields[2] == null ? 0 : fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, Robot obj) {
    writer
      ..writeByte(6)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.iconColor)
      ..writeByte(0)
      ..write(obj._name)
      ..writeByte(1)
      ..write(obj.macAddress)
      ..writeByte(2)
      ..write(obj.rssi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RobotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
