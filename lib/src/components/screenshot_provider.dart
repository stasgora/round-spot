import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:logging/logging.dart';

import '../models/detector_status.dart';
import '../models/session.dart';
import '../utils/utils.dart';

/// Produces an image from widgets surrounded by a [RepaintBoundary]
class ScreenshotProvider {
  final _logger = Logger('RoundSpot.ScreenshotProvider');

  /// Captures a screenshot from a [RepaintBoundary] using its [GlobalKey]
  void takeScreenshot(Session session, DetectorStatus status) async {
    if (session.screenshot != null && status is! ScrollDetectorStatus) return;
    var image = await _capture(status.areaKey, session.pixelRatio);
    if (image == null) return;
    if (session.screenshot == null && status is! ScrollDetectorStatus) {
      session.screenshot = image;
      return;
    }
    var axis = (status as ScrollDetectorStatus).scrollAxis;
    var imgStart = status.scrollPosition;
    var imgEnd = imgStart + image.axisSize(axis);
    double? paintBegin, paintEnd;
    double? stripBegin, stripEnd;
    var dirtyStripCount = 0;
    int? stripIndex;
    for (var i = 0; i < session.screenshotStrips.length; i++) {
      var strip = session.screenshotStrips[i];
      var startsBefore = imgStart < strip.offset;
      var endsBefore = imgEnd < strip.offset;
      if (paintBegin == null && startsBefore) {
        paintBegin = stripBegin = imgStart;
        stripIndex = i;
      }
      if (paintBegin == null && !startsBefore && imgStart < strip.end) {
        paintBegin = strip.end;
        stripBegin = strip.offset;
        stripIndex = i;
        dirtyStripCount++;
      }
      if (paintEnd == null && endsBefore) paintEnd = stripEnd = imgEnd;
      if (paintEnd == null && !endsBefore && imgEnd < strip.end) {
        paintEnd = strip.offset;
        stripEnd = strip.end;
        if (stripIndex == null || stripIndex < i) dirtyStripCount++;
        if (stripIndex == null) stripIndex = i;
      }
      if (paintEnd != null) break;
    }
    if (paintBegin == null) {
      paintBegin = stripBegin = imgStart;
      stripIndex = session.screenshotStrips.length;
    }
    if (paintEnd == null) paintEnd = stripEnd = imgEnd;
    if (session.screenshot == null) {
      session.screenshot = image;
    } else {
      session.screenshot = await image.drawOnto(
        session.screenshot!,
        Offsets.fromAxis(axis, paintBegin - imgStart) &
            Sizes.fromAxis(
              axis,
              paintEnd - paintBegin,
              (axis == Axis.horizontal ? image.height : image.width).toDouble(),
            ),
        Offsets.fromAxis(
            axis, paintBegin - session.screenshotStrips.first.offset),
      );
    }
    for (var i = 0; i < dirtyStripCount; i++) {
      session.screenshotStrips.removeAt(stripIndex!);
    }
    session.screenshotStrips.insert(
      stripIndex!,
      ImageStrip(stripBegin!, stripEnd! - stripBegin),
    );
  }

  Future<Image?> _capture(GlobalKey areaKey, double pixelRatio) async {
    if (areaKey.currentContext == null) {
      _logger.severe('Could not take a screenshot of the current page.');
      return null;
    }
    var screen =
        areaKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    return screen.toImage(pixelRatio: pixelRatio);
  }
}

/// An extension for drawing one [Image] onto another
extension ResizableImage on Image {
  /// Returns the size of this image
  Size get size => Size(width.toDouble(), height.toDouble());

  /// Returns the size component along a given [axis]
  double axisSize(Axis axis) =>
      (axis == Axis.horizontal ? width : height).toDouble();

  /// Draws the [bounds] part of this [Image] onto the [base] at [position]
  Future<Image> drawOnto(Image base, Rect bounds, Offset position) {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    var origin = Offset.zero;
    if (position.dx < 0 || position.dy < 0) {
      origin -= position;
      position = Offset.zero;
    }
    canvas.drawImage(base, origin, Paint());
    var dst = position & bounds.size;
    canvas.drawImageRect(this, bounds, dst, Paint());
    var canvasPicture = pictureRecorder.endRecording();
    var size = (bounds.size + position) | (base.size + origin);
    return canvasPicture.toImage(size.width.toInt(), size.height.toInt());
  }
}
