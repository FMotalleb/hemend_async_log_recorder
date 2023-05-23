import 'package:http/http.dart' as http;

final _client = http.Client();

/// default method used to send post requests
Future<void> defaultPostMethod(String url, Map<String, dynamic> record) async {
  try {
    await _client.post(
      Uri.parse(url),
      body: record,
    );
  } finally {
    _client.close();
  }
}
