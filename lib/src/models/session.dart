import 'dart:math';
import 'dart:ui';

import 'event.dart';
import 'output_info.dart';

class Session implements OutputInfo {
  final List<Event> _events = [];
  final String name;
  final int startTime;
  int endTime;
  Image? screenSnap;

  List<Event> get events => _events;

  Session({required this.name})
      : startTime = DateTime.now().millisecondsSinceEpoch,
        endTime = DateTime.now().millisecondsSinceEpoch;

  void addEvent(Event event) {
    _events.add(event);
    endTime = max(endTime, event.timestamp);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'span': {'start': startTime, 'end': endTime},
        'events': [for (var event in _events) event.toJson()]
      };
}
