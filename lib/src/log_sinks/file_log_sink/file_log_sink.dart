export 'package:hemend_async_log_recorder/src/contracts/file_log_sink.dart' //
    if (dart.library.html) 'file_log_sink_web.dart'
    if (dart.library.io) 'file_log_sink_io.dart';
