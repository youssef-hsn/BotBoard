<<<<<<< HEAD
import 'package:BotBoard/models/devices.dart';
import 'package:BotBoard/widgets/icon_editor.dart';
=======
import 'package:botboard/models/devices.dart';
>>>>>>> 4e9c6805810b728ac863ceeafb8e1d7d7748d79b
import 'package:flutter/material.dart';

class DeviceDetails extends StatelessWidget {
  final Device device;

  const DeviceDetails({required this.device, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    device.getIcon(),
                    device is! PairedDevice
                        ? Container()
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                // int newIcon = await showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) =>
                                //         IconEditor(
                                //           selectedIcon: device.icon,
                                //         ));
                                // device.icon = newIcon;
                                // TODO: Save the icon.
                              },
                            ),
                          )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.name,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Text(
                      "Mac Address: ${device.macAddress}",
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
            const Text("Description: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            Text(device.description),
            const Spacer(),
            Center(
              child: IconButton(
                icon: Icon(
                  device is PairedDevice ? Icons.terminal : Icons.link,
                ),
                iconSize: 50,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
