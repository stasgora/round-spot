import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../models/exceptions.dart';

/// Produces an image from widgets surrounded by a [RepaintBoundary]
class ScreenshotProvider {
  Future<ui.Image> takeScreenshot(GlobalKey areaKey) async {
    if (areaKey.currentContext == null) throw ScreenshotContextInaccessible();
    var screen =
        areaKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    return screen.toImage();
  }
}
