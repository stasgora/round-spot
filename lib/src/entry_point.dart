import 'package:flutter/widgets.dart';

import 'components/screenshot_provider.dart';
import 'detector_widget.dart';
import 'models/config.dart';
import 'utils/components.dart';

class RoundSpot {
  static Widget initialize({Widget? child, RoundSpotConfig? config}) {
    initializeComponents(config);
    return RoundSpotDetector(
      screenKey: S.get<ScreenshotProvider>().key,
      child: child,
    );
  }

  static void setEnabled({required bool enabled}) {
    updateConfig((config) => config..enabled = enabled);
  }
}
