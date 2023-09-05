// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';

import 'package:go_flow/go_flow.dart';
import 'package:http/http.dart' as http;

/// default method used to send post requests
Future<void> defaultPostMethod(
  String url,
  Map<String, dynamic> record,
) =>
    asyncGoFlow(
      (defer) async {
        final client = http.Client();
        defer(
          (_, recover) {
            client.close();
          },
        );
        await client.post(
          Uri.parse(url),
          body: jsonEncode(record),
        );
      },
    );
