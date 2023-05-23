import 'package:hemend_logger/hemend_logger.dart';

/// {@template log-sink-abstraction}
/// since log recorder's onRecord method is not asynchronous
/// this sink handles the requests
/// {@endtemplate}
abstract class ILogSink extends Sink<LogRecordEntity> {}
