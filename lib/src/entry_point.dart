import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'models/config/config.dart';
import 'models/log_level.dart';
import 'models/output_info.dart';
import 'utils/components.dart';
import 'widgets/detector.dart';
import 'widgets/lifecycle_observer.dart';

/// Signature for the [initialize] heat map output callback.
///
/// Provides a heat map in the form of png image [data]
/// and some additional [info] about it.
typedef HeatMapCallback = void Function(Uint8List data, OutputInfo info);

/// Signature for the [initialize] raw data output callback.
///
/// Provides the raw [data] that is used
/// to create heat maps in a form of a json file.
typedef RawDataCallback = void Function(String data);

/// Initializes the _Round Spot_ library.
///
/// Takes a [child] widget, an optional [config],
/// a [loggingLevel] which defaults to [LogLevel.off]
/// and output callbacks ([heatMapCallback] and [rawDataCallback])
/// that must be set depending on the [Config.outputTypes] requested.
///
/// Must be invoked either in `main()`:
/// ```dart
/// void main() {
///   runApp(round_spot.initialize(
///     child: Application()
///   ));
/// }
/// ```
/// or in [MaterialApp.builder] method:
/// ```dart
/// MaterialApp(
///   builder: (context, child) => round_spot.initialize(
///     child: child
///   )
/// );
/// ```
///
Widget initialize({
  required Widget child,
  Config? config,
  LogLevel loggingLevel = LogLevel.off,
  HeatMapCallback? heatMapCallback,
  RawDataCallback? rawDataCallback,
}) {
  _initializeLogger(loggingLevel);
  initializeComponents(config, heatMapCallback, rawDataCallback);
  return LifecycleObserver(child: Detector(child: child, areaID: ''));
}

void _initializeLogger(LogLevel level) {
  hierarchicalLoggingEnabled = true;
  Logger('RoundSpot').level = level.toLoggerLevel;
  Logger('RoundSpot').onRecord.listen((record) {
    var prefix = '${record.level.name} [${record.time}] ${record.loggerName}';
    print('$prefix: ${record.message}');
  });
}

/// Provides access to current [Config] and allows to change it.
Config get config => S.get<Config>();

/// A shortcut to [Config.enabled] for easy access.
// ignore: avoid_positional_boolean_parameters
set enabled(bool enabled) => config.enabled = enabled;

/// A shortcut to [Config.enabled] for easy access.
bool get enabled => config.enabled;
