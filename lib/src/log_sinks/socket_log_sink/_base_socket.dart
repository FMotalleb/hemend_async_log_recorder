import 'package:hemend_async_log_recorder/src/contracts/log_sink.dart';
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';

/// this abstract class used to provide cross-platform socket-connection
/// to logger
abstract class SocketLogSink<T extends Object> //
    extends ILogSink {
  /// creates new instance of socket logger
  SocketLogSink(
    this.socket, {
    required this.serializer,
  });

  final RecordSerializer serializer;

  /// since its impossible to use constructor of abstract class
  /// you should use this factory to create connection instances
  factory SocketLogSink.from(
    T _, {
    required RecordSerializer serializer,
  }) {
    throw Exception('this method cannot be called');
  }

  /// socket connection
  final T socket;

  /// check that socket is still attached to server
  bool get isAttached => false;
}
