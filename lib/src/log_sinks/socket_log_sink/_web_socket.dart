import 'dart:convert';
import 'dart:html' show WebSocket;

import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/log_sinks/socket_log_sink/_base_socket.dart' as base;
import 'package:hemend_logger/hemend_logger.dart';

import 'package:meta/meta.dart';

/// this class is example of Socket connection using [WebSocket]html which is not
/// accessible in platforms other than web
@internal
class SocketLogSink extends base.SocketLogSink<WebSocket> {
  /// creates socket connection from io.WebSocket
  SocketLogSink(
    super.socket, {
    required super.serializer,
  }) {
    socket.onClose.drain(null).then(
          (value) => isAttached = false,
        );
  }

  /// creates socket connection from io.WebSocket
  factory SocketLogSink.from(
    WebSocket socket, {
    required RecordSerializer serializer,
  }) =>
      SocketLogSink(
        socket,
        serializer: serializer,
      );
  @override
  bool isAttached = true;
  @override
  void add(LogRecordEntity data) {
    final serialized = serializer(data);
    final raw = jsonEncode(serialized);
    socket.send(raw);
  }

  @override
  void close() {
    socket.close();
  }
}