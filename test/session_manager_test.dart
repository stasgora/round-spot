import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:collection/collection.dart';

import 'package:round_spot/src/components/processors/graphical_processor.dart';
import 'package:round_spot/src/components/processors/raw_data_processor.dart';
import 'package:round_spot/src/components/background_manager.dart';
import 'package:round_spot/src/components/session_manager.dart';
import 'package:round_spot/src/models/config/config.dart';
import 'package:round_spot/src/models/detector_status.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/components.dart';

class MockBackgroundManager extends Mock implements BackgroundManager {}

class MockGraphicalProcessor extends Mock implements GraphicalProcessor {}

class MockRawDataProcessor extends Mock implements RawDataProcessor {}

late SessionManager _manager;

class EventDescriptor {
  final Event event;
  final DetectorStatus status;

  EventDescriptor(this.event, this.status);
  EventDescriptor.global(this.event) : status = detectorStatus();
}

void main() {
  setUpAll(() {
    S.registerSingleton<Config>(Config());
    S.registerSingleton<BackgroundManager>(MockBackgroundManager());
    S.registerSingleton<GraphicalProcessor>(MockGraphicalProcessor());
    S.registerSingleton<RawDataProcessor>(MockRawDataProcessor());

    registerFallbackValue<Session>(Session(page: '', area: '', pixelRatio: 1));
    registerFallbackValue<GlobalKey>(GlobalKey());
  });

  group('Session Manager', () {
    setUp(() {
      reset(S.get<BackgroundManager>());
      reset(S.get<GraphicalProcessor>());
      reset(S.get<RawDataProcessor>());

      _manager = SessionManager((_, __) {}, (_, __) {});
      _manager.onRouteOpened(settings: RouteSettings(name: ''));
    });

    group('Event processing', () {
      test('reported events are included in the session', () {
        var events = List.generate(4, (i) => Event(id: i));
        var sessions = _simpleProcessEvents(events);
        expect(sessions.first.events, equals(events));
      });
      test('events are skipped once they have been recorded once', () {
        var event = Event();
        var area = 'area';
        var list = [
          EventDescriptor(event, detectorStatus(areaID: area)),
          EventDescriptor.global(event),
        ];
        var sessions = _processEvents(list);
        expect(sessions.first.events, equals([event]));
        expect(sessions.first.area, equals(area));
      });
      test('events captured by global Detector are registered twice', () {
        var event = Event();
        var global = 'global';
        var enclosing = 'area';
        var list = [
          EventDescriptor(event, detectorStatus(areaID: global, global: true)),
          EventDescriptor(event, detectorStatus(areaID: enclosing)),
          EventDescriptor.global(event),
        ];
        var sessions = _processEvents(list, count: 2);
        expect(sessions, hasLength(2));
        expect(sessions.withAreaID(global), isNotNull);
        expect(sessions.withAreaID(enclosing), isNotNull);
      });

      group('Routes', () {
        test('page route changes are registered', () {
          var page = 'other';
          _registerEvent();
          _manager.onRouteOpened(settings: RouteSettings(name: page));
          var sessions = _simpleProcessEvents([Event(id: 1)], count: 2);
          _expectEventsByIDs(sessions.withPage()!.events, [0]);
          _expectEventsByIDs(sessions.withPage(page)!.events, [1]);
        });
        test('session is continued once the page route is reopened', () {
          _registerEvent();
          _manager.onRouteOpened(settings: RouteSettings(name: 'other'));
          _manager.onRouteOpened(settings: RouteSettings(name: ''));
          var sessions = _simpleProcessEvents([Event(id: 1)], count: 1);
          expect(sessions.first.events, hasLength(2));
        });
      });
    });

    group('Other events', () {
      test('events are ignored if no route is set', () {
        _manager.onRouteOpened();
        _simpleProcessEvents([Event()], count: 0);
      });
      test('all sessions are ended when app goes into paused state', () {
        _registerEvent();
        _manager.onLifecycleStateChanged(AppLifecycleState.paused);
        verify(() => S.get<GraphicalProcessor>().process(any()))
            .called(equals(1));
      });
    });

    test('scroll events are forwarded to the Background Manager', () {
      _manager.onSessionScroll(detectorStatus());
      verify(() => S.get<BackgroundManager>().onScroll(any(), any())).called(1);
    });
  });
}

DetectorStatus detectorStatus({String areaID = '', bool global = false}) {
  return DetectorStatus(
    areaKey: GlobalKey(),
    areaID: areaID,
    hasGlobalScope: global,
  );
}

List<Session> _simpleProcessEvents(List<Event> events, {int count = 1}) {
  return _processEvents(
    events.map((e) => EventDescriptor.global(e)).toList(),
    count: count,
  );
}

List<Session> _processEvents(List<EventDescriptor> events, {int count = 1}) {
  for (var event in events) {
    _manager.onEvent(event: event.event, status: event.status);
  }
  _manager.endSessions();
  if (count == 0) {
    verifyNever(() => S.get<GraphicalProcessor>().process(any()));
    return [];
  }
  var args = verify(() {
    return S.get<GraphicalProcessor>().process(captureAny());
  })
    ..called(equals(count));
  return args.captured.map((e) => e as Session).toList();
}

void _registerEvent({Event? event, DetectorStatus? status}) {
  event ??= Event();
  status ??= detectorStatus();
  _manager.onEvent(event: event, status: status);
}

void _expectEventsByIDs(List<Event> actual, List<int> expectedIDs) {
  expect(actual, hasLength(expectedIDs.length));
  for (var i = 0; i < actual.length; i++) {
    expect(actual[i].id, equals(expectedIDs[i]));
  }
}

extension SessionByFiled on List<Session> {
  Session? withAreaID([String areaID = '']) {
    return firstWhereOrNull((s) => s.area == areaID);
  }

  Session? withPage([String page = '']) {
    return firstWhereOrNull((s) => s.page == page);
  }
}
