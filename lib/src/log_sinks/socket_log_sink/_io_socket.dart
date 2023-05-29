// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'dart:io' show WebSocket;

import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';

import 'package:hemend_logger/hemend_logger.dart';
import 'package:meta/meta.dart';
import '_base_socket.dart' //
    as base;

/// this class is example of Socket connection using [WebSocket]io which is not
/// accessible in web platform
@internal
class SocketLogSink extends base.SocketLogSink<WebSocket> {
  @internal
  SocketLogSink(
    super.socket, {
    required super.serializer,
  });
  @internal
  factory SocketLogSink.from(
    WebSocket socket, {
    required RecordSerializer serializer,
  }) =>
      SocketLogSink(
        socket,
        serializer: serializer,
      );
  @override
  bool get isAttached => socket.closeCode == null;

  @override
  void add(LogRecordEntity data) {
    final serialized = serializer(data);
    final raw = jsonEncode(serialized);
    socket.add(raw);
  }

  @override
  Future<void> close() => socket.close();

  @override
  bool get isClosed => socket.closeCode != null;
}
