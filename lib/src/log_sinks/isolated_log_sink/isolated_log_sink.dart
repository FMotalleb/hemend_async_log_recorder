import 'dart:isolate';

import 'package:hemend_logger/hemend_logger.dart';

import '../../../hemend_async_log_recorder.dart';

class IsolatedLogSink extends ILogSink {
  IsolatedLogSink._(
    this._isolate,
    this._port,
  );
  static Future<IsolatedLogSink> spawn(
    Future<void> Function(LogRecordEntity) recorder,
  ) async {
    final port = ReceivePort();
    final isolate = await Isolate.spawn(
      (message) async {
        final internalPort = ReceivePort();
        message.send(internalPort.sendPort);
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
