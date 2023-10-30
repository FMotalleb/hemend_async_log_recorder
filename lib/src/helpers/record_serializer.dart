import 'package:hemend_logger/hemend_logger.dart';

/// default log record serializer
Map<String, dynamic> defaultRecordSerializer(LogRecordEntity record) => {
      'time': record.time.toIso8601String(),
      'level': HemendLogger.loggerLevelMapper(record.level),
      'logger_name': record.loggerName,
      'message': record.message,
      if (record.error != null) 'error': record.error.toString(),
      if (record.stackTrace != null) 'error': record.stackTrace.toString(),
    };
