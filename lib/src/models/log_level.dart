import 'package:logging/logging.dart';

/// Available library logging levels.
enum LogLevel {
  /// No logging messages - suitable for production environments.
  off,

  /// Only error messages.
  severe,

  /// Warnings and errors - recommended for integration testing.
  warning,
}

/// An extensions mapping to the logging` package [Level]
extension LogLevelLoggingMap on LogLevel {
  /// Holds the corresponding `logging` package [Level]
  Level get toLoggerLevel {
    return const {
      LogLevel.off: Level.OFF,
      LogLevel.severe: Level.SEVERE,
      LogLevel.warning: Level.WARNING,
    }[this]!;
  }
}
