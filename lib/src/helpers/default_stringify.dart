import 'package:hemend_logger/hemend_logger.dart';

/// the default stringify function used to format records to string to
/// store them in file
String defaultStringifyMethod(LogRecordEntity record) {
  final String loggerName;
  if (record.loggerName.isEmpty) {
    loggerName = 'Root-Logger';
  } else {
    loggerName = record.loggerName;
  }
  final buffer = StringBuffer(_dateFormat(record.time))
    ..write(' ')
    ..write('[$loggerName]');

  final level = HemendLogger.loggerLevelMapper(record.level);

  buffer
    ..write(' ')
    ..write('<$level>')
    ..write(': ')
    ..writeln(record.message);
  if (record.error != null) {
    buffer.writeln(record.error);
  }
  if (record.stackTrace != null) {
    buffer.writeln(record.stackTrace);
  }
  return buffer.toString();
}

String _dateFormat(DateTime date) {
  final buffer = StringBuffer()
    ..writeAll(
      [date.year, date.month, date.day],
      '-',
    )
    ..write(' ')
    ..writeAll(
      [date.hour, date.minute, date.second],
      ':',
    );
  return buffer.toString();
}
