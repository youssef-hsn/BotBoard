import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerAlert extends StatefulWidget {
  final baseColor;
  const ColorPickerAlert({super.key, this.baseColor});

  @override
  State<ColorPickerAlert> createState() => _ColorPickerAlertState();
}

class _ColorPickerAlertState extends State<ColorPickerAlert> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.baseColor ?? Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (Color color) {
              setState(() {
                selectedColor = color;
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('SELECT'),
            onPressed: () => Navigator.of(context).pop(selectedColor.value),
          ),
        ]);
  }
}
