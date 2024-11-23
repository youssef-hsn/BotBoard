import '../models/devices.dart';
import 'package:flutter/material.dart';

class DeviceDetails extends StatelessWidget {
  final Device device;

  const DeviceDetails({required this.device, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(device.name),
        ),
        body: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              device.getIcon(),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16.0, 6.0, 0),
                child: Text(device.description,
                    style: const TextStyle(overflow: TextOverflow.fade)),
              )),
            ])
          ],
        ));
  }
}