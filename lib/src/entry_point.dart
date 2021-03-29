import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'models/config.dart';
import 'models/output_info.dart';
import 'utils/components.dart';
import 'widgets/detector.dart';
import 'widgets/lifecycle_observer.dart';

typedef HeatMapCallback = void Function(Uint8List data, OutputInfo info);
typedef NumericCallback = void Function(String data);

Widget initialize(
    {Widget? child,
    Config? config,
    HeatMapCallback? heatMapCallback,
    NumericCallback? numericCallback}) {
  initializeComponents(config, heatMapCallback, numericCallback);
  return LifecycleObserver(
	  child: Detector(child: child)
  );
}

Config get config => S.get<Config>();

// ignore: avoid_positional_boolean_parameters
set enabled(bool enabled) => config.enabled = enabled;
bool get enabled => config.enabled;
