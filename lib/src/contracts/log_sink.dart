import 'package:hemend_logger/hemend_logger.dart';

/// {@template log-sink-abstraction}
/// since log recorder's onRecord method is not asynchronous
/// this sink handles the requests
/// {@endtemplate}
abstract class ILogSink implements Sink<LogRecordEntity> {
  @override
  void add(LogRecordEntity data);

  /// this will return true if close method called before getting its value
  bool get isClosed;
  @override
  Future<void> close();
}
