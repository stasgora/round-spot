import 'dart:ui';

import 'event.dart';
import 'output_info.dart';

class Session implements OutputInfo {
  final List<Event> events = [];
  final String name;
  final int startTime;
  late int endTime;
  Image? screenSnap;

  Session({required this.name})
      : startTime = DateTime.now().millisecondsSinceEpoch;

  void end() => endTime = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {
        'name': name,
        'span': {'start': startTime, 'end': endTime},
        'events': [for (var event in events) event.toJson()]
      };
}
