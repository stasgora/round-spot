import 'dart:ui';

import 'package:flutter/gestures.dart';

class Event {
  final Offset location;
  final int timestamp;
  final int id;

  List<double> get locationAsList => [location.dx, location.dy];

  Event.fromPointer(PointerEvent event)
      : location = event.localPosition,
        timestamp = DateTime.now().millisecondsSinceEpoch,
        id = event.pointer;

  Map<String, dynamic> toJson() => {
        'location': {'x': location.dx, 'y': location.dy},
        'time': timestamp
      };

  Path asPath(double radius) =>
      Path()..addOval(Rect.fromCircle(center: location, radius: radius));
}
