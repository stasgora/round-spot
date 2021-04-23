import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:logging/logging.dart';

import '../models/session.dart';
import '../utils/utils.dart';

/// Produces an image from widgets surrounded by a [RepaintBoundary]
class ScreenshotProvider {
  final _logger = Logger('RoundSpot.ScreenshotProvider');

  /// Captures a screenshot from a [RepaintBoundary] using its [GlobalKey]
  /// It than joins it with the already assembled image
  /// replacing the part that's underneath it
  void takeScreenshot(Session session, GlobalKey areaKey) async {
    if (session.screenshot != null && !session.scrolling) return;
    var scrollStatus = session.scrollStatus;
    var imageOffset = session.scrolling ? scrollStatus!.position.ceil() : 0;
    var image = await _capture(areaKey, session.pixelRatio);
    if (image == null) return;
    if (session.screenshot == null) {
      session.screenshot = image;
      if (session.scrolling) {
        scrollStatus!.screenshotPosition = imageOffset.toDouble();
      }
    } else {
      var axis = scrollStatus!.axis;
      double adjustForAxis(Axis currentAxis) => axis == currentAxis ? 1 : 0;
      // Decrease the drawn image by 1 pixel in the main axis direction
      // to account for the scroll position being rounded to nearest pixel
      var imageSize = Size(
        image.width - adjustForAxis(Axis.horizontal),
        image.height - adjustForAxis(Axis.vertical),
      );
      session.screenshot = await image.drawOnto(
        session.screenshot!,
        Offsets.fromAxis(axis, imageOffset - scrollStatus.screenshotPosition),
        imageSize,
      );
      scrollStatus.screenshotPosition = min(
        imageOffset.toDouble(),
        scrollStatus.screenshotPosition,
      );
    }
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
extension on Image {
  /// Returns the size of this image
  Size get size => Size(width.toDouble(), height.toDouble());

  /// Draws this [Image] onto the [base] at [position]
  Future<Image> drawOnto(Image base, Offset position, Size size) {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    var origin = Offset.zero;
    if (position.dx < 0 || position.dy < 0) {
      origin -= position;
      position = Offset.zero;
    }
    canvas.drawImage(base, origin, Paint());
    var bounds = position & size;
    canvas.drawRect(bounds, Paint()..blendMode = BlendMode.clear);
    canvas.drawImageRect(this, Offset.zero & size, bounds, Paint());
    var canvasPicture = pictureRecorder.endRecording();
    var output = (bounds.size + position) | (base.size + origin);
    return canvasPicture.toImage(output.width.toInt(), output.height.toInt());
  }
}
