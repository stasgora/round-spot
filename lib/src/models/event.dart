import 'dart:ui';

class Event {
  final Offset location;
  final int timestamp;

  Event(this.location, this.timestamp);

  Map<String, dynamic> toJson() => {
        'location': {'x': location.dx, 'y': location.dy},
        'time': timestamp
      };
}
