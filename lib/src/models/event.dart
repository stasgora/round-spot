import 'dart:ui';

import 'package:flutter/gestures.dart';
import '../utils/utils.dart';

/// Holds information about a single user interaction
class Event {
  /// Equals [PointerEvent.localPosition]
  final Offset location;

  /// Timestamp of when the event fired
  final int timestamp;

  /// Equals [PointerEvent.pointer]
  final int id;

  /// Converts the [location] to a coordinate list
  List<double> get locationAsList => [location.dx, location.dy];

  /// Creates an [Event] from Flutters [PointerEvent]
  Event.fromPointer(PointerEvent event)
      : location = event.localPosition,
        timestamp = getTimestamp(),
        id = event.pointer;

  /// Converts this [Event] to a json map
  Map<String, dynamic> toJson() => {
        'location': {'x': location.dx, 'y': location.dy},
        'time': timestamp,
      };

  /// Creates a [Path] from this [Event]
  Path asPath(double radius) =>
      Path()..addOval(Rect.fromCircle(center: location, radius: radius));
}
