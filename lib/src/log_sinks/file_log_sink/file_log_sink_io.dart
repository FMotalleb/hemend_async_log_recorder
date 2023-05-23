import 'dart:async';
import 'dart:io';

import 'package:hemend_async_log_recorder/src/contracts/file_log_sink.dart' //
    as base;
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_logger/hemend_logger.dart';

/// {@template file-log}
/// record logs into the specified file
/// {@endtemplate}
class FileLogSink implements base.FileLogSink {
  /// {@macro file-log}
  ///
  /// * [stringify]: method that converts log records to messages that will be
  /// recorded into the file
  /// * [file]: destination file
  FileLogSink({
    required RecordStringify stringify,
    required String filePath,
  }) : _controller = StreamController() {
    _initSink(stringify, File(filePath));
  }

  void _initSink(RecordStringify stringify, File file) {
    _controller.stream.map(stringify).listen(
      (message) async {
        await file.writeAsString(
          message,
          mode: FileMode.append,
        );
      },
    );
  }

  final StreamController<LogRecordEntity> _controller;

  @override
  void add(LogRecordEntity data) => _controller.add(data);

  @override
  void close() => _controller.sink.close();
}
