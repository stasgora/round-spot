import 'package:flutter/widgets.dart';
import '../components/screenshot_provider.dart';
import '../components/session_manager.dart';
import '../widgets/detector.dart';

/// Holds the [Detector] configuration for [SessionManager] use.
class DetectorConfig {
  /// A key referring to a [RepaintBoundary] used by the [ScreenshotProvider]
  final GlobalKey areaKey;

  /// [Detector.areaID]
  final String areaID;

  /// [Detector.hasGlobalScope]
  final bool hasGlobalScope;

  /// Creates a [DetectorConfig] used by a [SessionManager]
  DetectorConfig({
    required this.areaKey,
    required this.areaID,
    required this.hasGlobalScope,
  });
}
