import 'dart:ui';

import 'event.dart';

class Session {
  final List<Event> events = [];
  final String? name;
  final int startTime;
  int? endTime;
  Image? screenSnap;

  Session({this.name}) : startTime = DateTime.now().millisecondsSinceEpoch;

  void end() => endTime = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {
        'name': name ?? '',
        'span': {'start': startTime, 'end': endTime},
        'events': [for (var event in events) event.toJson()]
      };
}
