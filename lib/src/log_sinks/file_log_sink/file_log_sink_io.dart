// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:io';
import 'package:go_flow/go_flow.dart';
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
  /// * [allocate]: create file if its absent (not recommended)
  /// * [file]: destination file **must be present**
  ///   so if this file is missing please use File(*).create() before creating
  ///   this instance

  factory FileLogSink({
    required RecordStringify stringify,
    required String filePath,
    bool allocate = false,
  }) =>
      FileLogSink.fromFile(
        file: File(filePath),
        stringify: stringify,
        allocate: allocate,
      );

  /// {@macro file-log}
  FileLogSink.fromFile({
    required RecordStringify stringify,
    required File file,
    bool allocate = false,
  }) : _controller = StreamController() {
    _initSink(
      stringify,
      file,
      allocate,
    );
  }
  void _initSink(
    RecordStringify stringify,
    File file,
    bool allocate,
  ) {
    unawaited(
      asyncGoFlow(
        (defer) async {
          if (allocate) {
            await file.create(recursive: true);
          }
          final sink = file.openWrite(
            mode: FileMode.append,
          );
          defer(
            (_, recover) {
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
  Future<void> close() => _controller.sink.close();

  @override
  bool get isClosed => _controller.isClosed;
}
