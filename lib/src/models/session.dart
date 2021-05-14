import 'dart:math';
import 'dart:ui';

import '../utils/utils.dart';
import 'event.dart';
import 'output_info.dart';
import 'scrolling_status.dart';

/// Holds information about user interactions with a particular
/// [area] on some [page] during some period of time.
class Session implements OutputInfo {
  @override
  final String? page;

  @override
  final String area;

  @override
  final int startTime;

  @override
  int endTime;

  final List<Event> _events = [];

  /// Events registered in this [Session]
  List<Event> get events => _events;

  /// Holds the sessions background
  Image? background;

  /// Returns the background size corrected for the image scaling
  Size? get bgSize => background != null ? background!.size / pixelRatio : null;

  /// Status of the scrollable widget
  ScrollingStatus? scrollStatus;

  /// Status of the scrollable background
  BackgroundStatus? backgroundStatus;

  /// Returns if this [Session] monitors a scrollable widget
  bool get scrollable => scrollStatus != null;

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
  })   : startTime = getTimestamp(),
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
