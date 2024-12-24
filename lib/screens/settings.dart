import 'package:botboard/widgets/alerts/confirm.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  var prefrences = Hive.box('preferences');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("App Theme "),
            onTap: () {
              prefrences.put(
                'theme',
                prefrences.get('theme') == 'light' ? 'dark' : 'light',
              );
              setState(() {});
            },
            trailing: Icon(prefrences.get('theme') == 'light'
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
          ListTile(
            title: const Text(
              "Clear all saved devices",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              var s = Hive.box('savedDevices');
              bool sure = await showDialog(
                  context: context,
                  builder: (BuildContext context) => ConfirmationAlert(
                        consequences:
                            "This will remove ${s.length} saved devices from the app",
                      ));
              if (sure != true) return;
              s.clear();
            },
            trailing: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
