import 'package:hemend_async_log_recorder/hemend_async_log_recorder.dart';
import 'package:hemend_logger/hemend_logger.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  final logger = Logger.root;
  HemendLogger.defaultLogger()
    ..addListener(
      HemendAsyncLogRecorder.post(postUrl: 'https://<Server>/record'),
    )
    ..addListener(
      HemendAsyncLogRecorder.file(filePath: 'example/test.log'),
    );
  logger.info(
    'test',
  );
  // sends this body to the server
  //{
  //  "ticket_id": 555,
  //  "updated_at": 1679201760431,
  //  "payload": {
  //    "test": "test"
  //  }
  //}
  //
  // and append
  // 2023-5-23 15:59:43 [Root-Logger] <Info>: test
  // to test.log file
}
