import 'package:botboard/screens/device_details.dart';
import 'package:botboard/widgets/device_controlls/main_device_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';

class DeviceActions extends StatelessWidget {
  const DeviceActions({
    super.key,
    required this.widget,
    required FlutterBlueClassic flutterBlueClassicPlugin,
  }) : _flutterBlueClassicPlugin = flutterBlueClassicPlugin;

  final DeviceDetails widget;
  final FlutterBlueClassic _flutterBlueClassicPlugin;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MainDeviceAction(
          widget: widget,
          flutterBlueClassicPlugin: _flutterBlueClassicPlugin,
        ),
      ],
    );
  }
}
