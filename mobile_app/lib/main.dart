import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:botboard/models/devices.dart';
import 'package:botboard/screens/nearby.dart';
import 'package:botboard/screens/device_list.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(RobotAdapter());
  Hive.registerAdapter(PairedDeviceAdapter());

  await Hive.openBox('savedDevices');

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Nearby',
            selectedIcon: Icon(Icons.search),
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Devices',
            selectedIcon: Icon(Icons.list),
          ),
        ],
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedIndex: currentIndex,
      ),
      body: [
        const Nearby(),
        const DeviceList(),
      ][currentIndex],
    ));
  }
}
