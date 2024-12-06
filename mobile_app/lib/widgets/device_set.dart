import 'package:botboard/models/devices.dart';
import 'package:flutter/material.dart';

class DeviceSet extends StatefulWidget {
  final String heading;
  final Set<Device> devices;
  final bool hidable;

  const DeviceSet({
    required this.heading,
    required this.devices,
    this.hidable = false,
    super.key,
  });

  @override
  State<DeviceSet> createState() => _DeviceSetState();
}

class _DeviceSetState extends State<DeviceSet> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return widget.devices.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: Row(
                    children: [
                      Text(
                        widget.heading,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.hidable)
                        Checkbox(
                            value: _isExpanded,
                            onChanged: (v) => {
                                  setState(() {
                                    _isExpanded = v!;
                                  })
                                })
                    ],
                  ),
                ),
                // Grid
                _isExpanded
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two columns
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: widget.devices.length,
                        itemBuilder: (context, index) {
                          return widget.devices.elementAt(index).getCard();
                        },
                      )
                    : const Text("This List is collapsed"),
              ],
            ),
          );
  }
}
