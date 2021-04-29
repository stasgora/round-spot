import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:logging/logging.dart';

import '../models/scrolling_status.dart';
import '../models/session.dart';
import '../utils/utils.dart';

/// Creates backgrounds for sessions
class BackgroundManager {
  final _logger = Logger('RoundSpot.BackgroundManager');

  /// Controls when to take screenshot depending on the scroll amount
  void onScroll(Session session, GlobalKey areaKey) {
    if (!session.scrolling) return;
    if (session.background == null || _scrollOutsideBounds(session)) {
      _takeScreenshot(session, areaKey);
    }
  }

  bool _scrollOutsideBounds(Session session) {
    var scroll = session.scrollStatus!;
    var background = session.backgroundStatus!;
    var diff = background.lastScreenshotPosition - scroll.position;
    return (diff).abs() > background.viewportDimension * 0.8;
  }

  /// Determines if its necessary to take a screenshot when event is recorded
  void onEvent(Offset event, Session session, GlobalKey areaKey) {
    if (session.background == null || _eventOutsideScreenshot(event, session)) {
      _takeScreenshot(session, areaKey);
    }
  }

  bool _eventOutsideScreenshot(Offset event, Session session) {
    if (!session.scrolling) return false;
    var offset = session.backgroundOffset;
    return !(offset & session.background!.size).contains(event);
  }

  /// Captures a screenshot from a [RepaintBoundary] using its [GlobalKey]
  /// It than joins it with the already assembled image
  /// replacing the part that's underneath it
  void _takeScreenshot(Session session, GlobalKey areaKey) async {
    if (!session.scrolling) {
      if (session.background != null) return;
      session.background = await _captureImage(areaKey, session.pixelRatio);
      return;
    }
    var scroll = session.scrollStatus!;
    var background = (session.backgroundStatus ??= BackgroundStatus());
    background.lastScreenshotPosition = scroll.position.ceilToDouble();
    var queueEmpty = background.screenshotQueue.isEmpty;
    background.screenshotQueue.add(Screenshot(
      background.lastScreenshotPosition,
      _captureImage(areaKey, session.pixelRatio),
    ));
    if (queueEmpty) _processScreenshots(session);
  }

  void _processScreenshots(Session session) async {
    var scroll = session.scrollStatus!;
    var background = session.backgroundStatus!;
    var queue = background.screenshotQueue;
    while (queue.isNotEmpty) {
      await Future.sync(() async {
        var image = await queue.first.image;
        if (image == null) return;
        var offset = queue.first.offset;
        if (session.background == null) {
          session.background = image;
          background.position = offset;
          background.viewportDimension = image.size.alongAxis(scroll.axis);
          return;
        }
        // Decrease the drawn image by 1 pixel in the main axis direction
        // to account for the scroll position being rounded to the nearest pixel
        var imageSize = image.size.modifiedSize(scroll.axis, -1);
        session.background = await image.drawOnto(
          session.background!,
          Offsets.fromAxis(scroll.axis, offset - background.position),
          imageSize,
        );
        background.position = min(
          offset,
          background.position,
        );
      });
      queue.removeAt(0);
    }
  }

  Future<Image?> _captureImage(GlobalKey areaKey, double pixelRatio) async {
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
