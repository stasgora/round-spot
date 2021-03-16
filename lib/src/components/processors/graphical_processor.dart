import 'dart:ui';

import 'package:flutter/material.dart' as mat;

import '../../models/session.dart';
import '../../utils/components.dart';
import '../../utils/file_utils.dart';
import '../screenshot_provider.dart';
import 'session_processor.dart';

class GraphicalProcessor extends SessionProcessor {
  final _screenshotProvider = S.get<ScreenshotProvider>();

  final _pressPaint = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;
  final _pressColors = [
    mat.Colors.red.withAlpha(200),
    mat.Colors.red.withAlpha(200),
    mat.Colors.orange.withAlpha(150),
    mat.Colors.orange.withAlpha(0)
  ];
  final List<double> _pressColorSteps = [0, .3, .75, 1];

  @override
  Future process(Session session) async {
    var image = await _screenshotProvider.takeScreenshot();
    if (image == null) return;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    canvas.drawImage(image, Offset.zero, Paint());

    // ignore: omit_local_variable_types
    final double pressSize = 20;
    for (var event in session.events) {
      canvas.drawPoints(
          PointMode.points,
          [event.location],
          _pressPaint
            ..strokeWidth = 2 * pressSize
            ..shader = Gradient.radial(
                event.location, pressSize, _pressColors, _pressColorSteps));
    }
    var canvasPicture = pictureRecorder.endRecording();
    var sessionImage = await canvasPicture.toImage(image.width, image.height);
    return saveDebugImage(sessionImage);
  }
}
