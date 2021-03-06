import 'package:flutter/widgets.dart';

import '../components/background_manager.dart';
import '../components/session_manager.dart';
import '../widgets/detector.dart';
import 'scrolling_status.dart';

/// Holds the [Detector] status for [SessionManager] use.
class DetectorStatus {
  /// A key referring to a [RepaintBoundary] used by the [BackgroundManager]
  final GlobalKey areaKey;

  /// [Detector.areaID]
  final String areaID;

  /// [Detector.cumulative]
  final bool cumulative;

  /// Data used for scrollable [Session] processing
  final ScrollingStatus? scrollStatus;

  /// Returns if this [Detector] is the automatic global one
  bool get globalDetector => areaID == '';

  /// Returns the scroll [Offset] if there is any
  Offset get scrollOffset => scrollStatus?.offset ?? Offset.zero;

  /// Creates a [DetectorStatus] used by a [SessionManager]
  DetectorStatus({
    required this.areaKey,
    this.areaID = '',
    this.cumulative = false,
    this.scrollStatus,
  });
}
