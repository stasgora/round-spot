import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';
import '../utils/utils.dart';

/// Holds information about a single user interaction
class Event {
  /// Equals [PointerEvent.localPosition]
  Offset location;

  /// Timestamp of when the event fired
  final int timestamp;

  /// Equals [PointerEvent.pointer]
  final int id;

  /// Converts the [location] to a coordinate list
  List<double> locationAsList([Offset offset = Offset.zero]) {
    var location = this.location + offset;
    return [location.dx, location.dy];
  }

  /// Creates an [Event] with a given [location] and [id]
  @visibleForTesting
  Event({required this.location, required this.id})
      : timestamp = getTimestamp();

  /// Creates an [Event] from Flutters [PointerEvent]
  Event.fromPointer(PointerEvent event)
      : this(location: event.localPosition, id: event.pointer);

  /// Converts this [Event] to a json map
  Map<String, dynamic> toJson() => {
        'location': {'x': location.dx, 'y': location.dy},
        'time': timestamp,
      };

  /// Creates a [Path] from this [Event]
  Path asPath(double radius) =>
      Path()..addOval(Rect.fromCircle(center: location, radius: radius));
}
