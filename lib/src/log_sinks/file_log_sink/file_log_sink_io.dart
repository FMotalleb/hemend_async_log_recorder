// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:io';

import 'package:hemend_async_log_recorder/src/contracts/file_log_sink.dart' //
    as base;
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/go_flow/helper.dart';
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
    unawaited(
      asyncFlow(
        (defer) async {
          final sink = file.openWrite(
            mode: FileMode.append,
          );
          defer(
            (_) {
              sink.close();
            },
          );
          final recordStream = _controller //
              .stream
              .map(stringify)
              .map(
                (event) => event.codeUnits,
              );
          await for (final i in recordStream) {
            sink.add(i);
          }
        },
      ),
    );
  }

  final StreamController<LogRecordEntity> _controller;

  @override
  void add(LogRecordEntity data) => _controller.add(data);

  @override
  void close() => _controller.sink.close();
}
