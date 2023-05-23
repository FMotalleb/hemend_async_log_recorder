import 'package:hemend_logger/hemend_logger.dart';

/// adapter for [LogRecordEntity] to json-like [Map]
/// with string keys and dynamic values
typedef RecordSerializer = Adapter<LogRecordEntity, Map<String, dynamic>>;

/// post request handler that receives the url and the body of the request
/// and returns nothing but a future to complete the request
typedef PostMethod = Future<void> Function(
  String url,
  Map<String, dynamic> data,
);
