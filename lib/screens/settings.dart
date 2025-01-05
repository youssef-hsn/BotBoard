import 'dart:convert';
import 'package:botboard/widgets/alerts/confirm.dart';
import 'package:botboard/widgets/alerts/text_editor.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class SettingsView extends StatefulWidget {
  final Function setMainState;
  const SettingsView(this.setMainState, {super.key});

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
          const ListTile(
            title: Text(
              "Maintenance API",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text("API Host"),
            subtitle: Text(prefrences.get('apiHost')),
            trailing: Icon(
              Icons.api,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            title: const Text("App Identifier"),
            subtitle: Text(
                "${prefrences.get("username")} ID#${prefrences.get('appIdentifier')}"),
            onTap: () async {
              String? username = await showDialog(
                  context: context,
                  builder: (BuildContext context) => TextEditor(
                        title: "What should we call you?",
                        text: "${prefrences.get("username")}",
                      ));
              if (username == null) return;
              prefrences.put("username", username);
              await http.put(
                Uri.parse("${prefrences.get('apiHost')}/api/applications"),
                headers: {
                  "Authorization": "Bearer ${prefrences.get('JWT')}",
                  "Content-Type": "application/json",
                },
                body: jsonEncode({
                  "username": username,
                }),
              );
              setState(() {});
            },
            trailing: const Icon(Icons.perm_identity),
          ),
          ListTile(
            title: const Text("App Secret"),
            subtitle: Text(
              "${"*" * 16}${prefrences.get('appSecret').substring(16)}",
            ),
            onTap: () async {
              bool sure = await showDialog(
                  context: context,
                  builder: (BuildContext context) => const ConfirmationAlert(
                        consequences:
                            "This will regenerate the app secret for the app",
                      ));
              if (!sure) return;
              final response = await http.patch(
                  Uri.parse("${prefrences.get('apiHost')}/api/applications"),
                  headers: {
                    "Authorization": "Bearer ${prefrences.get('JWT')}",
                  });
              if (response.statusCode == 200) {
                var data = jsonDecode(response.body);
                prefrences.put("appSecret", data["new_secret"]);
                setState(() {});
              }
            },
            trailing: const Icon(Icons.lock),
          ),
          ListTile(
            title: const Text("Regenerate JWT"),
            subtitle: const Text("This will make the app re-authenticate"),
            onTap: () async {
              bool sure = await showDialog(
                  context: context,
                  builder: (BuildContext context) => const ConfirmationAlert(
                        consequences:
                            "This will regenerate the JWT for the app",
                      ));
              if (!sure) return;
              final response = await http.post(
                Uri.parse("${prefrences.get('apiHost')}/api/login"),
                body: {
                  "app_id": "${prefrences.get("appIdentifier")}",
                  "app_secret": prefrences.get("appSecret"),
                },
              );
              if (response.statusCode == 200) {
                String jwt = jsonDecode(response.body)["token"];
                prefrences.put("JWT", jwt);
                setState(() {});
              }
            },
            trailing: const Icon(Icons.shield),
          ),
          const Divider(
            indent: 16,
            endIndent: 16,
          ),
          const ListTile(
            title: Text(
              "Local Configuration",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text("App Theme"),
            subtitle: Text(
                "This will switch to ${prefrences.get('theme') == 'light' ? 'dark' : 'light'} mode"),
            onTap: () {
              prefrences.put(
                'theme',
                prefrences.get('theme') == 'light' ? 'dark' : 'light',
              );
              widget.setMainState(() {});
              setState(() {});
            },
            trailing: Icon(prefrences.get('theme') == 'light'
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
          ListTile(
            title: const Text(
              "Clear Memory",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "This will clear all saved devices",
              style: TextStyle(color: Colors.red),
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
