import 'dart:async';

import 'package:flutter/material.dart';
import 'package:botboard/widgets/device_set.dart';
import 'package:botboard/models/devices.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:botboard/models/dummies.dart' as dummy;

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

  final Set<Device> devices = dummy.devices.toSet(),
      pairedDevices = {dummy.pairedDevices[0]},
      robots = dummy.robots.toSet();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BluetoothAdapterState adapterState = _adapterState;

    var savedDevices = Hive.box('savedDevices');

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

      _flutterBlueClassicPlugin.startScan();
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
        body: _adapterState == BluetoothAdapterState.on
            ? RefreshIndicator(
                onRefresh: () async {
                  if (!_isScanning) {
                    // devices.clear();
                    // pairedDevices.clear();
                    // robots.clear();
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
                    devices: robots,
                  ),
                  DeviceSet(
                    heading: "Paired Devices",
                    devices: pairedDevices,
                  ),
                  DeviceSet(
                    heading: "Foreign Devices",
                    devices: devices,
                    hidable: true,
                  )
                ]),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bluetooth is ${_adapterState.toString().split('.').last}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      child: const Text('Turn on'),
                      onPressed: () {
                        _flutterBlueClassicPlugin.turnOn();
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
