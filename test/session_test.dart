import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/models/session.dart';

void main() {
  group('Session', () {
    test('start time equals creation time', () {
      _verifyTimestamp<Session>(() => Session(area: ''), (s) => s.startTime);
    });
    test('end time equals last event add time', () {
      return FakeAsync().run((self) {
        var session = Session(area: '');
        self.elapse(Duration(seconds: 1));
        _verifyTimestamp<Session>(
          () => session..addEvent(Event()),
          (s) => s.endTime,
        );
      });
    });
    test('json output contains passed data', () {
      var session = Session(area: 'area', page: 'page')..addEvent(Event());
      var output = session.toJson();
      expect(output['page'], equals('page'));
      expect(output['area'], equals('area'));
      expect(output['span']?['start'], isNotNull);
      expect(output['span']?['end'], isNotNull);
      expect(output['events'], hasLength(1));
    });

    group('Event', () {
      test('time equals creation time', () {
        _verifyTimestamp<Event>(() => Event(), (s) => s.timestamp);
      });
      test('json output contains passed data', () {
        var offset = Offset(1, 1);
        var output = Event(location: offset).toJson();
        expect(output['location']?['x'], equals(offset.dx));
        expect(output['location']?['y'], equals(offset.dy));
        expect(output['time'], isNotNull);
      });
    });
  });
}

void _verifyTimestamp<T>(T Function() action, int Function(T) timestamp) {
  var before = DateTime.now().millisecondsSinceEpoch;
  var obj = action();
  var after = DateTime.now().millisecondsSinceEpoch;
  expect(timestamp(obj), greaterThanOrEqualTo(before));
  expect(timestamp(obj), lessThanOrEqualTo(after));
}
