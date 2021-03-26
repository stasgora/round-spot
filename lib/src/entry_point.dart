import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'components/screenshot_provider.dart';
import 'detector_widget.dart';
import 'models/config.dart';
import 'utils/components.dart';

typedef HeatMapCallback = void Function(Uint8List data);
typedef NumericCallback = void Function(String data);

Widget initialize(
    {Widget? child,
    Config? config,
    HeatMapCallback? heatMapCallback,
    NumericCallback? numericCallback}) {
  initializeComponents(config, heatMapCallback, numericCallback);
  return Detector(
    screenKey: S.get<ScreenshotProvider>().key,
    child: child,
  );
}

Config get config => S.get<Config>();

// ignore: avoid_positional_boolean_parameters
set enabled(bool enabled) => config.enabled = enabled;
bool get enabled => config.enabled;
