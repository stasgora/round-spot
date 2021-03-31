import 'package:flutter/widgets.dart';

import '../components/session_manager.dart';
import '../widgets/detector.dart';

/// Holds the [Detector] configuration for [SessionManager] use.
class DetectorConfig {
  final GlobalKey areaKey;
  final String areaID;
  final bool hasGlobalScope;

  DetectorConfig({
    required this.areaKey,
    required this.areaID,
    required this.hasGlobalScope,
  });
}
