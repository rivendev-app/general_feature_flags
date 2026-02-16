import 'dart:developer' as developer;

/// Internal logger for the general_feature_flags package.
class FFLogger {
  /// Logs an informational message.
  static void info(String message) {
    _log('INFO', message);
  }

  /// Logs a warning message.
  static void warn(String message) {
    _log('WARN', message);
  }

  /// Logs an error message.
  static void error(String message) {
    _log('ERROR', message, isError: true);
  }

  static void _log(String level, String message, {bool isError = false}) {
    developer.log(
      message,
      name: 'GeneralFeatureFlags',
      level: isError ? 1000 : 0,
    );
    // ignore: avoid_print
    print('[GeneralFeatureFlags] [$level] $message');
  }
}
