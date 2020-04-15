import 'package:stack_trace/stack_trace.dart';

enum LogLevel { debug, info, warning, error }

void debug(String message, {bool hideCaller = false}) {
  _log(LogLevel.debug, message, hideCaller: hideCaller);
}

void info(String message, {bool hideCaller = false}) {
  _log(LogLevel.info, message, hideCaller: hideCaller);
}

void warning(String message, {bool hideCaller = false, dynamic error}) {
  _log(LogLevel.warning, message, hideCaller: hideCaller, error: error);
}

void error(String message, {bool hideCaller = false, dynamic error}) {
  _log(LogLevel.error, message, hideCaller: hideCaller, error: error);
}

void _log(LogLevel logLevel, String message, {bool hideCaller, dynamic error}) {
  final caller = hideCaller ? '' : '${Trace.current().frames[2].member}: ';
  print(
      '${logLevel.prefix} ${DateTime.now()}: $caller$message${error != null ? ', error: $error' : ''}');
}

extension _LogLevelPrefix on LogLevel {
  String get prefix {
    switch (this) {
      case LogLevel.debug:
        return '\u2728';
      case LogLevel.info:
        return '\u2705';
      case LogLevel.warning:
        return '\u2757';
      case LogLevel.error:
        return '\u274C';
    }
    return '';
  }
}
