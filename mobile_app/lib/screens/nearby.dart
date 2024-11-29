import 'dart:async';

import 'package:flutter/material.dart';
import 'package:botboard/widgets/device_set.dart';
import 'package:botboard/models/devices.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Nearby extends StatefulWidget {
  const Nearby({super.key});

  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  StreamSubscription? _scanningStateSubscription;

  final Set<Device> devices = {}, pairedDevices = {}, robots = {};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BluetoothAdapterState adapterState = _adapterState;

    var savedDevices = await Hive.openBox('savedDevices');

    try {
      adapterState = await _flutterBlueClassicPlugin.adapterStateNow;

      List<BluetoothDevice>? familiarDevices =
          await _flutterBlueClassicPlugin.bondedDevices;
      Set<String> familiarAdresses =
          familiarDevices!.map((device) => device.address).toSet();

      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) setState(() => _adapterState = current);
      });
      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) {
          setState(() {
            if (!familiarAdresses.contains(device.address)) {
              devices.add(Device.fromBTDevice(device: device));
              return;
            }

            var savedDevice = savedDevices.get(device.address);

            if (savedDevice == null) {
              Device newRepresentation =
                  PairedDevice.fromBTDevice(device: device);

              savedDevices.put(device.address, newRepresentation);
              pairedDevices.add(newRepresentation);
              return;
            }

            savedDevice.rssi = device.rssi;
            if (savedDevice is Robot) {
              robots.add(savedDevice);
              return;
            }
            pairedDevices.add(savedDevice);
          });
        }
      });
      _scanningStateSubscription =
          _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
        if (mounted) setState(() => _isScanning = isScanning);
      });
    } catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _adapterState = adapterState;
    });
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Robots'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (!_isScanning) {
              devices.clear();
              pairedDevices.clear();
              _flutterBlueClassicPlugin.startScan();
            }
            setState(() {});

            await Future.delayed(const Duration(milliseconds: 100));
            while (_isScanning) {
              await Future.delayed(const Duration(milliseconds: 100));
            }
          },
          child: ListView(children: [
            DeviceSet(
              heading: "Robots",
              devices: robots.toList(),
            ),
            DeviceSet(
              heading: "Paired Devices",
              devices: pairedDevices.toList(),
            ),
            DeviceSet(
              heading: "Foreign Devices",
              devices: devices.toList(),
            )
          ]),
        ),
      ),
    );
  }
}
