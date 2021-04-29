import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;

import '../utils/utils.dart';
import 'detector_status.dart';
import 'session.dart';

/// Status of the scrollable widget updated by [Detector]
///
/// Instance of this model is shared between the [Session] and [DetectorStatus]
class ScrollingStatus {
  /// Current scroll offset along the [axis]
  double position;

  /// Axis along which this [Session] widget scrolls
  final Axis axis;

  /// Viewport scroll extent along the [axis]
  Offset extent;

  /// Creates a [ScrollingStatus] with the given [axis]
  ScrollingStatus([this.axis = Axis.vertical, this.position = 0])
      : extent = const Offset(double.negativeInfinity, double.infinity);

  /// Returns the [Offset] based on [position] and [axis]
  Offset get offset => Offsets.fromAxis(axis, position);
}

/// Status of the scrollable background updated by the [BackgroundManager]
class BackgroundStatus {
  /// Current offset of the [Session.background]
  /// image along the [ScrollingStatus.axis]
  late double position;

  /// Offset of the last screenshot that was taken
  late double lastScreenshotPosition;

  /// Viewport size along the [ScrollingStatus.axis]
  late double viewportDimension;

  /// Queue of unprocessed screenshots
  final List<Screenshot> screenshotQueue = [];

  /// Returns the [Offset] based on
  /// [position] and [ScrollingStatus.axis]
  Offset offset(Axis axis) => Offsets.fromAxis(axis, position);
}

/// Represents an unprocessed part of [Session.background]
class Screenshot {
  /// Offset from the origin at which this screenshot starts
  final double offset;

  /// Captured screenshot image
  final Future<Image?> image;

  /// Creates an [Screenshot] with [offset] and [image]
  Screenshot(this.offset, this.image);
}
