import 'package:flutter/widgets.dart';

import '../utils/utils.dart';
import 'detector_status.dart';
import 'session.dart';

/// Holds metadata needed for the scrollable [Session] processing
///
/// Instance of this model is shared between the [Session] and [DetectorStatus]
class ScrollingStatus {
  /// Current offset of the [Session.screenshot] image along the [axis]
  late double screenshotPosition;

  /// Offset of the last screenshot part that was taken
  late double lastScreenshotPosition;

  /// Current scroll offset along the [axis]
  double position = 0;

  /// Axis along which this [Session] widget scrolls
  final Axis axis;

  /// Viewport scroll extent along the [axis]
  Offset scrollExtent;

  /// Viewport size along the [axis]
  late double viewportDimension;

  /// Creates a [ScrollingStatus] with the given [axis]
  ScrollingStatus([
    this.axis = Axis.vertical,
    this.scrollExtent = const Offset(double.negativeInfinity, double.infinity),
  ]);

  /// Returns the [Offset] based on [screenshotPosition] and [axis]
  Offset get screenshotOffset => Offsets.fromAxis(axis, screenshotPosition);

  /// Returns the [Offset] based on [position] and [axis]
  Offset get scrollOffset => Offsets.fromAxis(axis, position);
}
