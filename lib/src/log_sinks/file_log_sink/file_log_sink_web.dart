// ignore: lines_longer_than_80_chars
// ignore_for_file: implementation_imports, public_member_api_docs, avoid_unused_constructor_parameters

import 'package:hemend_async_log_recorder/src/contracts/file_log_sink.dart' as base;
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_logger/hemend_logger.dart';

class FileLogSink implements base.FileLogSink {
  FileLogSink({
    required RecordStringify stringify,
    required String filePath,
  }) {
    throw UnimplementedError();
  }
  @override
  void add(LogRecordEntity data) {
    throw UnimplementedError();
  }

  @override
  void close() {
    throw UnimplementedError();
  }
}
