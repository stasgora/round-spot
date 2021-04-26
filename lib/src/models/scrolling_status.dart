import 'package:flutter/widgets.dart';

import '../utils/utils.dart';
import 'detector_status.dart';
import 'session.dart';

/// Holds metadata needed for the scrollable [Session] processing
///
/// Instance of this model is shared between the [Session] and [DetectorStatus]
class ScrollingStatus {
  /// Current offset of the [Session.screenshot] image along the [axis]
  double screenshotPosition = 0;

  /// Current scroll offset along the [axis]
  double position = 0;

  /// Axis along which this [Session] widget scrolls
  final Axis axis;

  /// Viewport dimensions along the [axis]
  Offset scrollExtent;

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
