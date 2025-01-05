import 'package:flutter/material.dart';
import 'package:botboard/screens/device_details.dart';
import 'package:botboard/models/devices.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final bool tapable;
  const DeviceCard({this.tapable = true, required this.device, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!tapable) {
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeviceDetails(device: device)),
          );
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "icon-${device.macAddress}",
                  child: device.getIcon(),
                ),
                Text(device.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    )),
                Text(
                  device.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    overflow: TextOverflow.fade,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ));
  }
}
