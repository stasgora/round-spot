import 'dart:math';
import 'dart:ui';

import '../utils/utils.dart';
import 'event.dart';
import 'output_info.dart';

/// Holds information about user interactions with a particular
/// [area] on some [page] during some period of time.
class Session implements OutputInfo {
  final String? page;
  final String area;
  final int startTime;
  int endTime;

  /// Holds the [area] widget screenshot
  Image? screenSnap;
  final List<Event> _events = [];

  /// Events registered in this [Session]
  List<Event> get events => _events;

  /// Creates a [Session] for a particular [area] on some [page]
  Session({this.page, required this.area})
      : startTime = getTimestamp(),
        endTime = getTimestamp();

  /// Registers an [event] in this session
  void addEvent(Event event) {
    _events.add(event);
    endTime = max(endTime, event.timestamp);
  }

  /// Converts this [Session] to a json map
  Map<String, dynamic> toJson() => {
        'page': page,
        'area': area,
        'span': {'start': startTime, 'end': endTime},
        'events': [for (var event in _events) event.toJson()],
      };
}
