import 'dart:async';
import 'dart:isolate';

import 'package:hemend_logger/hemend_logger.dart';

import '../../../hemend_async_log_recorder.dart';

/// {@template IsolatedLogSink}
/// `IsolatedLogSink` is a logger sink that operates in a separate Dart isolate.
/// It uses the [IsolatedLogSink.spawn] method to create the isolate and
/// establish a communication channel for log messages.
///
/// **Note:**
/// Methods within the isolate cannot access anything outside of their scope.
/// This is due to the nature of isolates in Dart,
/// which do not share memory with the main isolate and communicate only via
/// messages.
///
/// Parameters:
///
/// - `recorder`: A function that will be called to record the log message
/// inside the isolate.
///
/// - `preload`: An optional function that will be called before the main
/// message-handling loop inside the isolate.
///
/// - `onDone`: An optional function that will be called after the main
/// message-handling loop (when closing the listener) to stop any process before
/// killing the isolate
///
/// - `debugName`: An optional name used for debugging purposes, which will be
/// associated with the isolate.
///
/// To use this sink, provide a `recorder` function that defines how log
/// messages should be processed.
/// Optionally, you can also provide a `preload` function if there is any setup
/// required before the isolate starts processing log messages.
////// Example usage of `IsolatedLogSink` with Hemend logger.
///
/// This example demonstrates how to create an isolated log recorder
/// that offloads the processing of log messages to a separate Dart isolate.
/// This can be particularly beneficial when log message processing is
/// resource-intensive and could potentially slow down the main application.
///
/// ```dart
/// // Initialize an isolated log recorder.
/// final recorder = await HemendAsyncLogRecorder.isolated(
///   0, // Record all logs (log level filter).
///   (p0) { // This function passes log messages to equivalent loggers inside the isolate.
///     Logger(p0.loggerName).log(
///       Level('', p0.level),
///       p0.message,
///       p0.error,
///       p0.stackTrace,
///     );
///   },
///   preload: () {
///     // Perform any necessary setup inside the isolate before processing logs.
///     HemendLogger.defaultLogger(logger: Logger.root);
///   },
///   debugName: 'IsolatedLogger', // Name for debugging purposes.
/// );
///
/// // Configure the HemendLogger with the isolated log recorder as a listener.
/// HemendLogger(
///   logger: Logger.root, // The root logger for the application.
///   initialListeners: [
///     recorder, // Add the isolated recorder as a listener.
///   ],
/// );
/// ```
///
/// In the given example:
/// - The main isolate sets up a simple log listener that forwards all log
/// messages to the isolate.
/// - Inside the isolate (referred to as the isolated logger), log messages are
/// handled. This can include
///   heavy processing tasks such as decorating, validating, and printing log
/// messages.
/// - The `preload` function is used to perform any necessary initializations
/// within the isolate before
///   it starts processing the log messages.
///
/// By using an `IsolatedLogSink`, the main application's performance is less
/// likely to be affected by
/// the overhead of logging operations, especially when they involve complex
/// processing.
///
/// {@endtemplate}
class IsolatedLogSink extends ILogSink {
  IsolatedLogSink._(
    this._port,
  );

  /// {@macro IsolatedLogSink}
  static Future<IsolatedLogSink> spawn(
    FutureOr<void> Function(LogRecordEntity) recorder, {
    /// Called before going inside the loop
    FutureOr<void> Function()? preload,
    FutureOr<void> Function()? onDone,
    String? debugName,
  }) async {
    final port = ReceivePort();
    await Isolate.spawn(
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
        await onDone?.call();
      },
      port.sendPort,
      debugName: debugName,
      errorsAreFatal: false,
    );
    final sendPort = await port.first;
    return IsolatedLogSink._(
      sendPort as SendPort,
    );
  }

  final SendPort _port;
  @override
  void add(LogRecordEntity data) {
    _port.send(data);
  }

  @override
  Future<void> close() async {
    _isDead = true;
    _port.send(_KillSig());
  }

  bool _isDead = false;

  @override
  bool get isClosed => _isDead;
}

class _KillSig {}
