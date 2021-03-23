import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../models/exceptions.dart';

class ScreenshotProvider {
  final GlobalKey key = GlobalKey();

  Future<ui.Image> takeScreenshot() async {
    if (key.currentContext == null) throw ScreenshotContextInaccessible();
    var screen =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    return screen.toImage();
  }
}
