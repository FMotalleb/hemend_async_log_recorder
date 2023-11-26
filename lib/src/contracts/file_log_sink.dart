// ignore_for_file: public_member_api_docs, avoid_unused_constructor_parameters

import 'package:hemend_logger/hemend_logger.dart';

import 'log_sink.dart';
import 'typedefs.dart';

class FileLogSink implements ILogSink {
  FileLogSink({
    required RecordStringify stringify,
    required String filePath,
    bool allocate = false,
  });

  @override
  void add(LogRecordEntity data) {
    throw UnimplementedError();
  }

  @override
  bool get isClosed => throw UnimplementedError();
  @override
  Future<void> close() {
    throw UnimplementedError();
  }
}
