import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/devices.dart';
import 'screens/nearby.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(RobotAdapter());
  Hive.registerAdapter(PairedDeviceAdapter());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Nearby();
  }
}
