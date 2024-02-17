import 'dart:async';
import 'dart:isolate';

import 'package:hemend_logger/hemend_logger.dart';

import '../../../hemend_async_log_recorder.dart';

/// {@template IsolatedLogSink}
///  Use [IsolatedLogSink.spawn] to spawn the isolate
///
///  **Note:**
///   these methods are inside the isolate dus they cannot access anything
///   outside of their scopes
///
/// params:
///
/// - recorder
///   - will be called to record the message inside the isolate
///
/// - preload
///   - will be called before the main loop inside the isolate
/// {@endtemplate}
class IsolatedLogSink extends ILogSink {
  IsolatedLogSink._(
    this._isolate,
    this._port,
  );

  /// {@macro IsolatedLogSink}
  static Future<IsolatedLogSink> spawn(
    FutureOr<void> Function(LogRecordEntity) recorder, {
    /// Called before going inside the loop
    FutureOr<void> Function()? preload,
    String? debugName,
  }) async {
    final port = ReceivePort();
    final isolate = await Isolate.spawn(
      (message) async {
        final internalPort = ReceivePort();
        message.send(internalPort.sendPort);
        await preload?.call();
        await for (final record in internalPort) {
          switch (record) {
            case _KillSig _:
              break;
            case final LogRecordEntity value:
              await recorder(value);
          }
        }
      },
      port.sendPort,
      debugName: debugName,
    );
    final sendPort = await port.first;
    return IsolatedLogSink._(
      isolate,
      sendPort as SendPort,
    );
  }

  final Isolate _isolate;
  final SendPort _port;
  @override
  void add(LogRecordEntity data) {
    _port.send(data);
  }

  @override
  Future<void> close() async {
    _isDead = true;
    _port.send(_KillSig());
    _isolate.kill();
  }

  bool _isDead = false;

  @override
  bool get isClosed => _isDead;
}

class _KillSig {}
