import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;

import '../utils/utils.dart';
import 'detector_status.dart';
import 'session.dart';

/// Holds metadata needed for the scrollable [Session] processing
///
/// Instance of this model is shared between the [Session] and [DetectorStatus]
class ScrollingStatus {
  /// Current offset of the [Session.background] image along the [axis]
  late double backgroundPosition;

  /// Offset of the last screenshot that was taken
  late double lastScreenshotPosition;

  /// Current scroll offset along the [axis]
  double position;

  /// Axis along which this [Session] widget scrolls
  final Axis axis;

  /// Viewport scroll extent along the [axis]
  Offset extent;

  /// Viewport size along the [axis]
  late double viewportDimension;

  /// Queue of unprocessed screenshots
  final List<Screenshot> screenshotQueue = [];

  /// Creates a [ScrollingStatus] with the given [axis]
  ScrollingStatus([this.axis = Axis.vertical, this.position = 0])
      : extent = const Offset(double.negativeInfinity, double.infinity);

  /// Returns the [Offset] based on [backgroundPosition] and [axis]
  Offset get backgroundOffset => Offsets.fromAxis(axis, backgroundPosition);

  /// Returns the [Offset] based on [position] and [axis]
  Offset get scrollOffset => Offsets.fromAxis(axis, position);
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
