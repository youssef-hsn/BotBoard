import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:botboard/models/routines.dart' show registerApp;
import 'package:botboard/models/devices.dart';
import 'package:botboard/screens/nearby.dart';
import 'package:botboard/screens/routines.dart';
import 'package:botboard/screens/device_list.dart';
import 'package:botboard/screens/settings.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(RobotAdapter());
  Hive.registerAdapter(PairedDeviceAdapter());

  await Hive.openBox('savedDevices');
  await Hive.openBox('deviceMappings');

  var prefrences = await Hive.openBox('preferences');
  if (!prefrences.containsKey('theme')) {
    prefrences.put('theme', 'light');
  }
  prefrences.put('apiHost', 'http://10.0.2.2:8000');

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentIndex = 0;

  Box prefrences = Hive.box('preferences');

  @override
  void initState() {
    super.initState();

    int? id = prefrences.get("appIdentifier");
    if (id == null) {
      generateCredentials();
    }
    getJWT();
  }

  Future<void> generateCredentials() async {
    Map credentials = await registerApp(
      "${prefrences.get('apiHost')}/api/applications",
      "Robot Master", // Default username.
    );
    prefrences.put("username", "Robot Master");
    prefrences.put("appIdentifier", credentials["id"]);
    prefrences.put("appSecret", credentials["secret"]);
    setState(() {});
  }

  Future<void> getJWT() async {
    final response = await http.post(
      Uri.parse("${prefrences.get('apiHost')}/api/login"),
      body: {
        "app_id": "${prefrences.get("appIdentifier")}",
        "app_secret": prefrences.get("appSecret"),
      },
    );
    if (response.statusCode == 200) {
      String jwt = jsonDecode(response.body)["token"];
      prefrences.put(
        "JWT",
        jwt,
      );
      setState(() {});
    } else {
      print("Failed to get JWT");
    }
  }

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
                icon: Icon(Icons.check_box_outlined),
                label: 'Routines',
                selectedIcon: Icon(Icons.check_box),
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
            const RoutinesView(),
            SettingsView(setState),
          ][currentIndex],
        ));
  }
}
