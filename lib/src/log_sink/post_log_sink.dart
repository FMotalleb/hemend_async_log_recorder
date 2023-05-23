import 'dart:async';

import 'package:hemend_async_log_recorder/src/contracts/log_sink.dart';
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_logger/hemend_logger.dart';

/// {@template log-sink}
/// {@macro log-sink-abstraction}
///
/// a record sink that receives log records then serialize them using given
/// serializer and sends it using the given send method.
/// {@endtemplate}
class LogSink extends ILogSink {
  /// {@macro log-sink}
  ///
  /// * serializer: the method used to serialize the record to json
  /// *
  LogSink({
    required RecordSerializer serializer,
    required String requestUrl,
    required PostMethod recordMethod,
  }) : _controller = StreamController() {
    _initSink(serializer, recordMethod, requestUrl);
  }

  void _initSink(
    RecordSerializer serializer,
    PostMethod recordMethod,
    String requestUrl,
  ) {
    _controller.stream.map(serializer).listen(
          (record) => recordMethod(
            requestUrl,
            record,
          ),
        );
  }

  final StreamController<LogRecordEntity> _controller;

  @override
  void add(LogRecordEntity data) => _controller.add(data);

  @override
  void close() => _controller.sink.close();
}
