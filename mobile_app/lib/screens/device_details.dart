import 'package:botboard/screens/controllers/bluetooth_terminal.dart';
import 'package:botboard/widgets/alerts/icon_editor.dart';
import 'package:botboard/models/devices.dart';
import 'package:botboard/widgets/alerts/text_editor.dart';
import 'package:botboard/widgets/alerts/upgrade_paired_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DeviceDetails extends StatefulWidget {
  final Device device;

  const DeviceDetails({required this.device, super.key});

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();

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
                    widget.device.getIcon(),
                    widget.device is! PairedDevice
                        ? Container()
                        : Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                int newIcon = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        IconEditor(
                                          widget.device.icon,
                                        ));
                                widget.device.icon = newIcon;
                                setState(() {});
                              },
                            ),
                          )
                  ],
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (widget.device is! PairedDevice) {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const AlertDialog(
                                        title:
                                            Text("The Device must Be Paired"),
                                        content: Text(
                                            "You can't edit the name of a foreign device.")));
                            return;
                          }
                          widget.device.name = await showDialog(
                              context: context,
                              builder: (BuildContext context) => TextEditor(
                                    title: "Edit Device Name",
                                    text: widget.device.name,
                                  ));
                          setState(() {});
                        },
                        child: Text(widget.device.name,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                      Text(
                        "Mac Address: ${widget.device.macAddress}",
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Description: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(widget.device.description),
                ],
              ),
              onTap: () async {
                if (widget.device is Robot) {
                  widget.device.description = await showDialog(
                      context: context,
                      builder: (BuildContext context) => TextEditor(
                            title: "Edit Description",
                            text: widget.device.description,
                          ));
                  setState(() {});
                } else {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text("Device Must be a Robot!"),
                            content: Text(widget.device is PairedDevice
                                ? "Just click the upgrade button below."
                                : "Pair the device then upgrade it to a robot"),
                          ));
                }
              },
            ),
            const Spacer(),
            Center(
              child: IconButton(
                icon: Icon(
                  widget.device is Robot
                      ? Icons.terminal
                      : widget.device is PairedDevice
                          ? Icons.arrow_upward
                          : Icons.link,
                ),
                iconSize: 50,
                onPressed: () async {
                  if (widget.device is Robot) {
                    // BluetoothConnection? connection =
                    //     await _flutterBlueClassicPlugin
                    // .connect(widget.device.macAddress);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BluetoothTerminal(
                            widget.device,
                            null,
                          ),
                        ));
                    return;
                  }

                  Box<dynamic> box = Hive.box('savedDevices');

                  if (widget.device is PairedDevice) {
                    String description = await showDialog(
                        context: context,
                        builder: (BuildContext context) => UpgradePairedDevice(
                              widget.device,
                            ));
                    Robot robot = Robot(
                        widget.device.name, widget.device.macAddress,
                        description: description, icon: widget.device.icon);
                    box.put(widget.device.macAddress, robot);
                    Navigator.of(context).pop();
                  } else {
                    // await _flutterBlueClassicPlugin
                    //     .bondDevice(widget.device.macAddress);
                    await box.put(
                        widget.device.macAddress,
                        PairedDevice(
                          widget.device.name,
                          widget.device.macAddress,
                          icon: widget.device.icon,
                          iconColor: widget.device.iconColor,
                        ));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
