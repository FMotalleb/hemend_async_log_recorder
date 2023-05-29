import 'package:hemend_async_log_recorder/src/contracts/log_sink.dart';
import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_logger/hemend_logger.dart';

/// this abstract class used to provide cross-platform socket-connection
/// to logger
abstract class SocketLogSink<T extends Object> //
    extends ILogSink {
  /// creates new instance of socket logger
  SocketLogSink(
    this.socket, {
    required this.serializer,
  });

  /// since its impossible to use constructor of abstract class
  /// you should use this factory to create connection instances
  factory SocketLogSink.from(
    T _, {
    // ignore: avoid_unused_constructor_parameters
    required RecordSerializer serializer,
  }) {
    throw Exception('this method cannot be called');
  }

  /// used to map log record to json data
  final RecordSerializer serializer;

  /// socket connection
  final T socket;

  /// check that socket is still attached to server
  bool get isAttached => false;

  /// adds a record to socket stream
  @override
  void add(LogRecordEntity data);

  /// dispose the sink/stream
  @override
  Future<void> close();
}
