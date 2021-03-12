import 'package:round_spot/src/models/event.dart';

class Session {
	final List<Event> events = [];
	final String? name;
	final int startTime;
	int? endTime;

  Session({this.name}) : startTime = DateTime.now().millisecondsSinceEpoch;

  void end() => endTime = DateTime.now().millisecondsSinceEpoch;
}
