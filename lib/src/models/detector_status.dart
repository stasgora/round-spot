import 'package:flutter/widgets.dart';
import '../components/screenshot_provider.dart';
import '../components/session_manager.dart';
import '../widgets/detector.dart';

/// Holds the [Detector] status for [SessionManager] use.
class DetectorStatus {
  /// A key referring to a [RepaintBoundary] used by the [ScreenshotProvider]
  final GlobalKey areaKey;

  /// [Detector.areaID]
  final String areaID;

  /// [Detector.hasGlobalScope]
  final bool hasGlobalScope;

  /// Creates a [DetectorStatus] used by a [SessionManager]
  DetectorStatus({
    required this.areaKey,
    required this.areaID,
    required this.hasGlobalScope,
  });
}

/// Extends the [DetectorStatus] with scroll specific data.
class ScrollDetectorStatus extends DetectorStatus {
  /// Current scroll area position
  double scrollPosition = 0;

  /// Axis in which this detectors area scrolls
  Axis scrollAxis;

  /// Transforms the scroll information into an [Offset]
  Offset get asScrollOffset => scrollAxis == Axis.vertical
      ? Offset(0, scrollPosition)
      : Offset(scrollPosition, 0);

  /// Creates a [ScrollDetectorStatus] used by a [SessionManager]
  ScrollDetectorStatus({
    required GlobalKey areaKey,
    required String areaID,
    required bool hasGlobalScope,
    required this.scrollAxis,
  }) : super(
          areaKey: areaKey,
          areaID: areaID,
          hasGlobalScope: hasGlobalScope,
        );
}
