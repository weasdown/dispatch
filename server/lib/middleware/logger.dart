import 'package:logging/logging.dart';

void Function(String message, bool isError) logger(Logger log) =>
    (String message, bool isError) => isError
    ? log.severe('Operation failed with error', message)
    : log.fine(message);

Logger getLogger(String defaultName) {
  hierarchicalLoggingEnabled = true;
  return Logger.root
    // TODO set this to a lower level
    ..level = Level.ALL
    ..onRecord.listen((record) {
      final loggerName = record.loggerName.isEmpty ? 'root' : record.loggerName;
      print('${record.time} [$loggerName] [${record.level}] ${record.message}');
    });
}
