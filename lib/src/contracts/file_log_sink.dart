// ignore_for_file: public_member_api_docs, avoid_unused_constructor_parameters

import 'package:hemend_async_log_recorder/src/contracts/log_sink.dart';
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_logger/hemend_logger.dart';

class FileLogSink implements ILogSink {
  FileLogSink({
    required RecordStringify stringify,
    required String filePath,
  });

  @override
  void add(LogRecordEntity data) {
    throw UnimplementedError();
  }

  bool get isClosed => throw UnimplementedError();
  @override
  Future<void> close() {
    throw UnimplementedError();
  }
}
