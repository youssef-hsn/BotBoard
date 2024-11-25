import 'dart:async';

import 'package:flutter/material.dart';
import 'package:botboard/widgets/device_set.dart';
import 'package:botboard/models/devices.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class Nearby extends StatefulWidget {
  const Nearby({super.key});

  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  final Set<BluetoothDevice> _scanResults = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  int? _connectingToIndex;
  StreamSubscription? _scanningStateSubscription;

  final Set<Device> _devices = {}, pairedDevices = {}, robots = {};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BluetoothAdapterState adapterState = _adapterState;

    try {
      adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) setState(() => _adapterState = current);
      });
      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) {
          setState(() => _devices.add(Device.fromBTDevice(device: device)));
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
                  _devices.clear();
                  _flutterBlueClassicPlugin.startScan();
                }
                setState(() {});
                while (_isScanning) {
                  await Future.delayed(const Duration(milliseconds: 100));
                }
              },
              child: ListView(children: [
                DeviceSet(
                  heading: "Discovered Devices",
                  devices: _devices.toList(),
                )
              ]),
            )));
  }
}
