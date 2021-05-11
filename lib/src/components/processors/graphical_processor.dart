import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:logging/logging.dart';

import '../../models/config/heat_map_style.dart';
import '../../models/event.dart';
import '../../models/session.dart';
import '../../utils/utils.dart';
import '../heat_map.dart';
import 'session_processor.dart';

/// Processes sessions into heat maps
class GraphicalProcessor extends SessionProcessor {
  final _logger = Logger('RoundSpot.GraphicalProcessor');

  @override
  Future<Uint8List?> process(Session session) async {
    if (session.background == null) {
      _logger.warning('Got session with no image attached, skipping.');
      return null;
    }
    var image = session.background!;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    var rect = _getClippedImageRect(session);
    canvas.drawImageRect(image, rect, Offset.zero & rect.size, Paint());

    var alpha = (config.heatMapTransparency * 255).toInt();
    canvas.saveLayer(null, Paint()..color = Color.fromARGB(alpha, 0, 0, 0));
    _drawHeatMap(canvas, session);
    canvas.restore();

    var canvasPicture = pictureRecorder.endRecording();
    var sessionImage = await canvasPicture.toImage(
      rect.size.width.toInt(),
      rect.size.height.toInt(),
    );
    return exportHeatMap(sessionImage);
  }

  Rect _getClippedImageRect(Session session) {
    var offset = Offset.zero;
    var image = session.background!;
    var size = image.size;
    if (session.scrollable) {
      var scroll = session.scrollStatus!;
      var background = session.backgroundStatus!;
      double getPosition(Event e) => e.location.alongAxis(scroll.axis);
      var eventPositions = session.events.map(getPosition);
      final cutMargin = background.viewportDimension;
      var extent = Offset(
        max(scroll.extent.dx, eventPositions.reduce(min) - cutMargin),
        min(
          scroll.extent.dy + background.viewportDimension,
          eventPositions.reduce(max) + cutMargin,
        ),
      );
      var diff = background.position - extent.dx;
      if (diff < 0) {
        offset = Offsets.fromAxis(scroll.axis, -diff);
        size = size.modifiedSize(scroll.axis, diff);
        background.position = extent.dx;
      }
      diff = extent.dy - background.position - size.alongAxis(scroll.axis);
      if (diff < 0) size = size.modifiedSize(scroll.axis, diff);
    }
    return offset & size;
  }

  void _drawHeatMap(Canvas canvas, Session session) {
    var clusterScale = config.uiElementSize * session.pixelRatio;
    transform(Offset o) => (o - session.backgroundOffset) * session.pixelRatio;
    var events = session.events.map((e) => transform(e.location)).toList();
    var heatMap = HeatMap(events: events, pointProximity: clusterScale);

    int layerCount() {
      if (heatMap.largestCluster == 1) return 1;
      return heatMap.largestCluster * config.heatMapStyle.multiplier;
    }

    double calcFraction(int i) => (i - 1) / max((layerCount() - 1), 1);
    double calcBlur(double val) => (4 * val * val + 2) * clusterScale / 10;
    for (var i = 1; i <= layerCount(); i++) {
      var fraction = calcFraction(i);
      var paint = Paint()..color = _getSpectrumColor(fraction);
      if (config.heatMapStyle == HeatMapStyle.smooth) {
        paint.maskFilter =
            MaskFilter.blur(BlurStyle.normal, calcBlur(1 - fraction));
      }
      canvas.drawPath(heatMap.getPathLayer(fraction), paint);
    }
  }

  Color _getSpectrumColor(double value, {double alpha = 1}) =>
      HSVColor.fromAHSV(alpha, (1 - value) * 225, 1, 1).toColor();
}
