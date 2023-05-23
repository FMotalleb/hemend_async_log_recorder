import 'package:hemend_logger/hemend_logger.dart';

/// default log record serializer
Map<String, dynamic> defaultRecordSerializer(LogRecordEntity record) => {
      'message': record.message,
      'date_time': record.time.millisecondsSinceEpoch,
      'level': record.level,
      'logger_name': record.loggerName,
      'error': record.error?.toString(),
      'stack_trace': record.stackTrace?.toString(),
    };
