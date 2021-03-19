import 'dart:math';
import 'dart:ui';

import 'package:flutter/painting.dart';

import '../../models/heat_map_style.dart';
import '../../models/session.dart';
import '../../utils/components.dart';
import '../../utils/file_utils.dart';
import '../heat_map.dart';
import '../screenshot_provider.dart';
import 'session_processor.dart';

class GraphicalProcessor extends SessionProcessor {
  final _screenshotProvider = S.get<ScreenshotProvider>();

  @override
  Future process(Session session) async {
    var image = await _screenshotProvider.takeScreenshot();
    if (image == null) return;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    canvas.drawImage(image, Offset.zero, Paint());

    canvas.saveLayer(null, Paint()
	    ..color = Color.fromARGB(config.heatMapTransparency, 0, 0, 0));
    drawHeatMap(canvas, session);
    canvas.restore();

    var canvasPicture = pictureRecorder.endRecording();
    var sessionImage = await canvasPicture.toImage(image.width, image.height);
    return saveDebugImage(sessionImage);
  }

  void drawHeatMap(Canvas canvas, Session session) {
    var heatMap = HeatMap(session: session, maxDistance: 10, detailLevel: .1);

    calcFraction(int i) => (i - 1) / max((heatMap.largestCluster - 1), 1);
    calcBlur(double val) => 4 * val * val + 2;
    for (var i = heatMap.smallestCluster; i <= heatMap.largestCluster; i++) {
      var fraction = calcFraction(i);
      var paint = Paint()..color = _getSpectrumColor(fraction, alpha: .6);
      if (config.heatMapStyle == HeatMapStyle.smooth) {
        paint.maskFilter = 
		        MaskFilter.blur(BlurStyle.normal, calcBlur(1 - fraction));
      }
      canvas.drawPath(heatMap.getPathLayer(i), paint);
    }
  }

  Color _getSpectrumColor(double value, {double alpha = 1}) =>
      HSVColor.fromAHSV(alpha, (1 - value) * 225, 1, 1).toColor();
}
