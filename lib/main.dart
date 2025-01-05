import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:botboard/models/devices.dart';
import 'package:botboard/screens/nearby.dart';
import 'package:botboard/screens/device_list.dart';
import 'package:botboard/screens/settings.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(RobotAdapter());
  Hive.registerAdapter(PairedDeviceAdapter());

  await Hive.openBox('savedDevices');

  var prefrences = await Hive.openBox('preferences');
  if (!prefrences.containsKey('theme')) {
    prefrences.put('theme', 'light');
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentIndex = 0;

  var prefrences = Hive.box('preferences');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            brightness: prefrences.get('theme') == 'light'
                ? Brightness.light
                : Brightness.dark,
            seedColor: Colors.blue,
          ),
        ),
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
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                label: "Settings",
                selectedIcon: Icon(Icons.settings),
              )
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
            SettingsView(setState),
          ][currentIndex],
        ));
  }
}
