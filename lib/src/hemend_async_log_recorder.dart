import 'package:hemend_async_log_recorder/src/contracts/log_sink.dart';
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/helpers/default_post_method.dart';
import 'package:hemend_async_log_recorder/src/helpers/record_serializer.dart';
import 'package:hemend_async_log_recorder/src/log_sink/post_log_sink.dart';
import 'package:hemend_logger/hemend_logger.dart';

/// {@template hemend_async_log_recorder}
/// A Simple implementation of [ILogRecorder] that sends log messages
/// using [ILogSink]
/// {@endtemplate}
class HemendAsyncLogRecorder extends ILogRecorder {
  /// {@macro hemend_async_log_recorder}
  ///
  /// this constructor uses simple api to construct the recorder
  ///
  /// * [postUrl]: url that records will be sent to
  ///
  /// * [logLevel] (Optional): the level of the log to be recorded
  /// defaults to 800 which is equal to Level.INFO but you may set this to zero
  /// and use a limited logger
  ///
  /// * [postMethod] (Optional): uses [defaultPostMethod] by default
  /// you may want to change this parameter in order to
  /// use authentication methods
  ///
  /// * [recordSerializer] (Optional): uses [defaultRecordSerializer] by default
  /// you are able to change this method to your desired serialization format
  /// but its not needed for most cases
  factory HemendAsyncLogRecorder({
    required String postUrl,
    int logLevel = 800,
    PostMethod postMethod = defaultPostMethod,
    RecordSerializer recordSerializer = defaultRecordSerializer,
  }) =>
      HemendAsyncLogRecorder.manual(
        logLevel,
        LogSink(
          serializer: recordSerializer,
          requestUrl: postUrl,
          recordMethod: postMethod,
        ),
      );

  /// {@macro hemend_async_log_recorder}
  const HemendAsyncLogRecorder.manual(
    this.logLevel,
    this.requestSink,
  );

  /// a log sink that manages log records
  /// this is used to make sure that sync records are able to
  /// send using an async method
  final ILogSink requestSink;

  @override
  final int logLevel;

  @override
  void onRecord(LogRecordEntity record) => requestSink.add(record);
}
