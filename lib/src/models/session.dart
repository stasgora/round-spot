import 'dart:math';
import 'dart:ui';

import '../utils/utils.dart';
import 'event.dart';
import 'output_info.dart';
import 'scrolling_status.dart';

/// Holds information about user interactions with a particular
/// [area] on some [page] during some period of time.
class Session implements OutputInfo {
  final String? page;
  final String area;
  final int startTime;
  int endTime;

  final List<Event> _events = [];

  /// Events registered in this [Session]
  List<Event> get events => _events;

  /// Holds the sessions background
  Image? background;

  /// Status of the scrollable widget
  final ScrollingStatus? scrollStatus;

  /// Status of the scrollable background
  BackgroundStatus? backgroundStatus;

  /// Returns if this [Session] monitors a scrolling widget
  bool get scrolling => scrollStatus != null;

  /// Returns the background [Offset] if there is any
  Offset get backgroundOffset =>
      backgroundStatus?.offset(scrollStatus!.axis) ?? Offset.zero;

  /// Determines this session output resolution
  final double pixelRatio;

  /// Creates a [Session] for a particular [area] on some [page]
  Session({
    this.page,
    required this.area,
    required this.pixelRatio,
    this.scrollStatus,
  })  : startTime = getTimestamp(),
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
