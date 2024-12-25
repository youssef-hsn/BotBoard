import 'package:botboard/models/devices.dart';
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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.device is PairedDevice
              ? IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () => null,
                )
              : Container(),
          MainDeviceAction(
            widget: widget,
            flutterBlueClassicPlugin: _flutterBlueClassicPlugin,
          ),
        ],
      ),
    );
  }
}
