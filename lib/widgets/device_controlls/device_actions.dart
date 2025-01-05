import 'package:botboard/models/devices.dart';
import 'package:botboard/screens/device_details.dart';
import 'package:botboard/screens/create_routine.dart';
import 'package:botboard/widgets/alerts/confirm.dart';
import 'package:botboard/widgets/device_controlls/main_device_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
                    Icons.add_task,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateRoutineView(
                              widget.device,
                            ),
                          ),
                        )
                      })
              : Container(),
          widget.device is PairedDevice
              ? IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          const ConfirmationAlert(
                        consequences:
                            "This will remove the data stored for this device. \n"
                            "It will revert it to a paired device. with plain data",
                      ),
                    ).then((value) {
                      if (value is bool && value) {
                        Hive.box('savedDevices')
                            .delete(widget.device.macAddress);
                        Navigator.pop(context);
                      }
                    })
                  },
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
