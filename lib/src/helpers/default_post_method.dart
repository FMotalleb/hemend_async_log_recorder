import 'dart:convert';

import 'package:http/http.dart' as http;

/// default method used to send post requests
Future<void> defaultPostMethod(String url, Map<String, dynamic> record) async {
  final client = http.Client();
  try {
    await client.post(
      Uri.parse(url),
      body: jsonEncode(record),
    );
  } finally {
    client.close();
  }
}
