import 'dart:ui';

class Event {
  final Offset location;
  final int timestamp;

  List<double> get locationAsList => [location.dx, location.dy];

  Event(this.location, this.timestamp);

  Map<String, dynamic> toJson() => {
        'location': {'x': location.dx, 'y': location.dy},
        'time': timestamp
      };

  Path asPath(double radius) =>
      Path()..addOval(Rect.fromCircle(center: location, radius: radius));
}
