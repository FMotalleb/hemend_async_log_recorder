import 'dart:async';

import 'package:hemend_async_log_recorder/src/contracts/log_sink.dart';
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_logger/hemend_logger.dart';
import 'package:pool/pool.dart';

/// {@template log-sink}
/// {@macro log-sink-abstraction}
///
/// a record sink that receives log records then serialize them using given
/// serializer and sends it using the given send method.
/// {@endtemplate}
class PostLogSink extends ILogSink {
  /// {@macro log-sink}
  ///
  /// * `serializer` parameter is of type RecordSerializer and is required.
  /// It specifies the serializer responsible for converting log records into
  /// the desired format before sending them.
  ///
  /// * `requestUrl` parameter is a required String that represents the URL where
  /// the log records will be sent.
  ///
  /// * `recordMethod` parameter is of type PostMethod and is required.
  /// It indicates the HTTP method to be used when sending the log records.
  /// It is likely to be a POST method in this case.
  ///
  /// * `concurrency` parameter is an integer that indicates the maximum number of
  /// requests that can be launched simultaneously.
  /// This parameter is crucial for managing the load on the server and
  /// controlling the rate at which log records are sent.
  ///
  /// * `concurrencyWaitTime` parameter is an optional Duration that specifies
  /// the amount of time to wait before launching new requests when the maximum
  /// concurrency limit is reached. This parameter helps prevent overwhelming
  /// the server with too many simultaneous requests.
  PostLogSink({
    required RecordSerializer serializer,
    required String requestUrl,
    required PostMethod recordMethod,
    required int concurrency,
    required Duration? concurrencyWaitTime,
  })  : _controller = StreamController(),
        _concurrentPool = Pool(
          concurrency,
          timeout: concurrencyWaitTime,
        ) {
    _initSink(serializer, recordMethod, requestUrl);
  }
  final Pool _concurrentPool;
  void _initSink(
    RecordSerializer serializer,
    PostMethod recordMethod,
    String requestUrl,
  ) {
    _controller.stream.map(serializer).listen(
      (record) async {
        final resource = await _concurrentPool.withResource(
          () => recordMethod,
        );
        await resource(
          requestUrl,
          record,
        );
      },
    );
  }

  final StreamController<LogRecordEntity> _controller;

  @override
  void add(LogRecordEntity data) => _controller.add(data);

  @override
  Future<void> close() => _controller.sink.close();

  @override
  bool get isClosed => _controller.isClosed;
}
