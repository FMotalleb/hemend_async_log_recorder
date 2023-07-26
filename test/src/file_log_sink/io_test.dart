import 'dart:io';

import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/log_sinks/file_log_sink/file_log_sink_io.dart';
import 'package:hemend_logger/hemend_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'io_test.mocks.dart';

// Create a mock for the File and IOSink
@GenerateMocks([File, IOSink])
void main() {
  group('IO', () {
    late FileLogSink fileLogSink;
    late RecordStringify simpleStringify;
    late MockFile mockFile;
    late MockIOSink mockSink;

    setUp(() {
      simpleStringify = (record) => record.message;
      mockFile = MockFile();
      mockSink = MockIOSink();
      when(
        mockFile.create(
          recursive: anyNamed('recursive'),
        ),
      ).thenAnswer(
        (realInvocation) => Future.value(mockFile),
      );
      // Mock the file initialization
      when(
        mockFile.openWrite(mode: anyNamed('mode')),
      ).thenReturn(mockSink);
      // Mock the Sink disposition
      when(
        mockSink.close(),
      ).thenAnswer((_) async => null);
      // Mock the sink write method
      when(
        mockSink.add(any),
      ).thenReturn(null);

      // Create the FileLogSink instance for each test case
      fileLogSink = FileLogSink.fromFile(
        stringify: simpleStringify,
        file: mockFile,
        allocate: true,
      );
    });
    test(
      'create instance without named constructor',
      () async {
        final file = File('__test_path.log');
        final sink = FileLogSink(
          stringify: (p0) => '',
          filePath: file.path,
        );

        expect(sink, isNotNull);
        await sink.close();
        await file.delete();
      },
    );
    test('add method should add log record to the controller', () async {
      // Create fake Log record
      final mockLogRecord = LogRecordEntity(
        message: 'test message',
        error: null,
        level: 800,
        loggerName: 'TestLogger',
        stackTrace: null,
        time: DateTime.now(),
        zone: null,
      );

      // Act
      fileLogSink.add(mockLogRecord);
      final expectedMessage = 'test message'.codeUnits;
      // Assert
      // This method is called after internal stream controller received record
      // thus this method may get called after an unknown duration
      await untilCalled(mockSink.add(any));
      verify(mockSink.add(expectedMessage)).called(1);
    });
    test('close method should close the controller sink', () async {
      // Act
      await fileLogSink.close();

      // Assert
      expect(fileLogSink.isClosed, true);
    });
  });
}
