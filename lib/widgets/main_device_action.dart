import 'package:botboard/models/devices.dart';
import 'package:botboard/screens/controllers/bluetooth_terminal.dart';
import 'package:botboard/screens/device_details.dart';
import 'package:botboard/widgets/alerts/pair_foreign.dart';
import 'package:botboard/widgets/alerts/upgrade_paired_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainDeviceAction extends StatelessWidget {
  const MainDeviceAction({
    super.key,
    required this.widget,
    required FlutterBlueClassic flutterBlueClassicPlugin,
  }) : _flutterBlueClassicPlugin = flutterBlueClassicPlugin;

  final DeviceDetails widget;
  final FlutterBlueClassic _flutterBlueClassicPlugin;

  IconData _getDeviceIcon() {
    if (widget.device is Robot) {
      return Icons.terminal;
    } else if (widget.device is PairedDevice) {
      return Icons.arrow_upward;
    } else {
      return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.device is Robot) {
      return FloatingActionButton(
        child: const Icon(Icons.terminal),
        onPressed: () async {
          BluetoothConnection? connection =
              await _flutterBlueClassicPlugin.connect(widget.device.macAddress);
          if (connection is BluetoothConnection) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BluetoothTerminal(
                    widget.device,
                    connection,
                  ),
                ));
          }
        },
      );
    }

    return FloatingActionButton(
      backgroundColor: widget.device is PairedDevice ? Colors.green : null,
      child: Icon(
        widget.device is PairedDevice ? Icons.arrow_upward : Icons.link,
      ),
      onPressed: () async {
        Box<dynamic> box = Hive.box('savedDevices');

        if (widget.device is PairedDevice) {
          String description = await showDialog(
              context: context,
              builder: (BuildContext context) => UpgradePairedDevice(
                    widget.device,
                  ));
          Robot robot = Robot(
            widget.device.name,
            widget.device.macAddress,
            description: description,
            icon: widget.device.icon,
          );
          box.put(widget.device.macAddress, robot);
          Navigator.of(context).pop();
        } else {
          String? description = await showDialog(
            context: context,
            builder: (BuildContext context) => PairForeign(),
          );
          if (description != null && description.isEmpty) return;
          bool success = await _flutterBlueClassicPlugin
              .bondDevice(widget.device.macAddress);
          if (description != null && success) {
            Robot robot = Robot(
              widget.device.name,
              widget.device.macAddress,
              description: description,
              icon: widget.device.icon,
            );
            box.put(widget.device.macAddress, robot);
            Navigator.of(context).pop();
          }
        }
      },
    );
  }
}
