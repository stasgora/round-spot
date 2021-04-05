import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

/// Produces an image from widgets surrounded by a [RepaintBoundary]
class ScreenshotProvider {
  final _logger = Logger('RoundSpot.ScreenshotProvider');

  Future<ui.Image?> takeScreenshot(GlobalKey areaKey) async {
    if (areaKey.currentContext == null) {
      _logger.log(
        Level.SEVERE,
        'Could not take a screenshot of the current page.',
      );
      return null;
    }
    var screen =
        areaKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    return screen.toImage();
  }
}
