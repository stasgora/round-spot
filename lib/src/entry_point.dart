import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'components/screenshot_provider.dart';
import 'detector_widget.dart';
import 'models/config.dart';
import 'utils/components.dart';

typedef HeatMapCallback = void Function(Uint8List data);
typedef NumericCallback = void Function(String data);

class RoundSpot {
  static Widget initialize(
      {Widget? child,
      RoundSpotConfig? config,
      HeatMapCallback? heatMapCallback,
      NumericCallback? numericCallback}) {
    initializeComponents(config, heatMapCallback, numericCallback);
    return RoundSpotDetector(
      screenKey: S.get<ScreenshotProvider>().key,
      child: child,
    );
  }

  static void setEnabled({required bool enabled}) {
    updateConfig((config) => config..enabled = enabled);
  }
}
