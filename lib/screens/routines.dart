import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class RoutinesView extends StatefulWidget {
  const RoutinesView({super.key});

  @override
  State<RoutinesView> createState() => _RoutinesViewState();
}

class _RoutinesViewState extends State<RoutinesView> {
  bool apiUp = false;

  @override
  void initState() {
    super.initState();
    checkApi();
  }

  void checkApi() async {
    try {
      Box prefrences = Hive.box('preferences');
      String apiHost = prefrences.get('apiHost');

      final response = await http.get(Uri.parse('$apiHost/up'));
      setState(() {
        apiUp = response.statusCode == 200;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routines"),
      ),
      body: apiUp
          ? ListView(
              children: [],
            )
          : const Center(
              child: Text("Failed to connect to API"),
            ),
    );
  }
}
