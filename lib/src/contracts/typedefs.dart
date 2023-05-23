import 'package:hemend_logger/hemend_logger.dart';

/// Adapter for [LogRecordEntity] to json-like [Map]
/// with string keys and dynamic values
typedef RecordSerializer = Adapter<LogRecordEntity, Map<String, dynamic>>;

/// Adapter for [LogRecordEntity] to string
typedef RecordStringify = Adapter<LogRecordEntity, String>;

/// Post request handler that receives the url and the body of the request
/// and returns nothing but a future to complete the request
typedef PostMethod = Future<void> Function(
  String url,
  Map<String, dynamic> data,
);
