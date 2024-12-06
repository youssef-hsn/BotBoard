import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:botboard/widgets/device_set.dart';
import 'package:botboard/models/devices.dart' show PairedDevice, Robot;
import 'package:botboard/models/dummies.dart' as dummy;

class DeviceList extends StatefulWidget {
  const DeviceList({super.key});

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  final List<String> _options = ["All", "Robots", "Paired Devices"];
  String _selectedDevices = "All";

  bool shouldBeShown(String setName) {
    return _selectedDevices == "All" || _selectedDevices == setName;
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('savedDevices');

    Set<Robot> robots = dummy.robots.toSet();
    Set<PairedDevice> pairedDevices = dummy.pairedDevices.toSet();

    for (var device in box.values) {
      if (device is Robot) {
        robots.add(device);
      } else if (device is PairedDevice) {
        pairedDevices.add(device);
      }
    }

    return (MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Registered Robots'), actions: [
          DropdownButton(
              value: _selectedDevices,
              items: _options
                  .map((option) =>
                      DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
              onChanged: (v) => {
                    setState(() {
                      _selectedDevices = v!;
                    })
                  }),
        ]),
        body: ListView(children: [
          shouldBeShown("Robots")
              ? DeviceSet(
                  heading: "Robots",
                  devices: robots,
                )
              : Container(),
          shouldBeShown("Paired Devices")
              ? DeviceSet(
                  heading: "Paired Devices",
                  devices: pairedDevices,
                )
              : Container(),
        ]),
      ),
    ));
  }
}
