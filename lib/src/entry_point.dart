import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'models/config/config.dart';
import 'models/log_level.dart';
import 'models/output_info.dart';
import 'utils/components.dart';
import 'widgets/detector.dart';
import 'widgets/lifecycle_observer.dart';

/// Signature for the [initialize] data output callbacks.
///
/// Provides the [data] along with some additional [info] about it.
typedef OutputCallback = void Function(Uint8List data, OutputInfo info);

/// Initializes the _Round Spot_ library.
///
/// Takes a [child] widget, an optional [config],
/// a [loggingLevel] which defaults to [LogLevel.off]
/// and output callbacks ([heatMapCallback] and [rawDataCallback])
/// that must be set depending on the [Config.outputTypes] requested.
///
/// Should be invoked in `main()` or otherwise wrap the [MaterialApp] widget:
/// ```dart
/// void main() {
///   runApp(round_spot.initialize(
///     child: Application()
///   ));
/// }
/// ```
///
Widget initialize({
  required Widget child,
  Config? config,
  LogLevel loggingLevel = LogLevel.off,
  OutputCallback? heatMapCallback,
  OutputCallback? rawDataCallback,
}) {
  _initializeLogger(loggingLevel);
  initializeComponents(config, heatMapCallback, rawDataCallback);
  return LifecycleObserver(child: Detector(child: child, areaID: ''));
}

void _initializeLogger(LogLevel level) {
  hierarchicalLoggingEnabled = true;
  Logger('RoundSpot').level = level.toLoggerLevel;
  Logger('RoundSpot').onRecord.listen((record) {
    var prefix = '${record.level.name} - ${record.loggerName}';
    var message = '$prefix: ${record.message}';
    if (record.level == Level.SEVERE) {
      if (record.error != null) {
        message += '\n${record.error.runtimeType} was thrown';
      }
      if (record.stackTrace != null) {
        message += '\nStacktrace:\n${record.stackTrace}';
      }
    }
    print(message);
  });
}

/// Provides access to the current [Config] and allows to change it.
Config get config => S.get<Config>();

/// A shortcut to [Config.enabled] for easy access.
// ignore: avoid_positional_boolean_parameters
set enabled(bool enabled) => config.enabled = enabled;

/// A shortcut to [Config.enabled] for easy access.
bool get enabled => config.enabled;
