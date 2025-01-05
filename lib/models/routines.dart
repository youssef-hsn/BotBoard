import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map> registerApp(String url, String username) async {
  final response = await http.post(
    Uri.parse(url),
    body: {'username': username},
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return {
      'id': data['app_id'],
      'secret': data['app_secret'],
    };
  } else {
    throw Exception('Failed to request id and secret');
  }
}
