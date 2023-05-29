import 'package:hemend_async_log_recorder/src/contracts/file_log_sink.dart';
import 'package:hemend_logger/hemend_logger.dart';
import 'package:test/test.dart';

void main() {
  group('Contract', () {
    late FileLogSink fileLogSink;
    setUp(() {
      String stringifyMethod(
        LogRecordEntity _,
      ) =>
          throw UnimplementedError();

      fileLogSink = FileLogSink(
        stringify: stringifyMethod,
        filePath: '_',
      );
    });
    test('throw on every call', () async {
      final mockLogRecord = LogRecordEntity(
        message: 'test message',
        error: null,
        level: 800,
        loggerName: 'TestLogger',
        stackTrace: null,
        time: DateTime.now(),
        zone: null,
      );
      expect(
        () => fileLogSink.add(mockLogRecord),
        throwsUnimplementedError,
      );
      await expectLater(
        () async => fileLogSink.close(),
        throwsUnimplementedError,
      );
      expect(
        () => fileLogSink.isClosed,
        throwsUnimplementedError,
      );
    });
  });
}
