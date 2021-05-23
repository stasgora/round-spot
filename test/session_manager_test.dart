import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:round_spot/src/components/processors/graphical_processor.dart';
import 'package:round_spot/src/components/background_manager.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/models/page_status.dart';
import 'package:round_spot/src/utils/components.dart';

import 'session_manager_utils.dart';

void main() {
  setUpOnce();

  group('Session Manager', () {
    setUpEveryTime();

    group('Event processing', () {
      test('reported events are included in the session', () {
        var events = List.generate(4, (i) => Event(id: i));
        var sessions = simpleProcessEvents(events);
        expect(sessions.first.events, equals(events));
      });
      test('events are skipped once they have been recorded once', () {
        var event = Event();
        var area = 'area';
        var list = [
          EventDescriptor(event, detectorStatus(areaID: area)),
          EventDescriptor.screen(event),
        ];
        var sessions = processEvents(list);
        expect(sessions.first.events, equals([event]));
        expect(sessions.first.area, equals(area));
      });
      test('events captured by global Detector are registered twice', () {
        var event = Event();
        var area = 'cumulative';
        var enclosing = 'area';
        var list = [
          EventDescriptor(
            event,
            detectorStatus(areaID: area, cumulative: true),
          ),
          EventDescriptor(event, detectorStatus(areaID: enclosing)),
          EventDescriptor.screen(event),
        ];
        var sessions = processEvents(list, count: 2);
        expect(sessions, hasLength(2));
        expect(sessions.withAreaID(area), isNotNull);
        expect(sessions.withAreaID(enclosing), isNotNull);
      });

      group('Routes', () {
        test('page route changes are registered', () {
          var page = 'other';
          registerEvent();
          manager.onRouteOpened(PageStatus(name: page));
          var sessions = simpleProcessEvents([Event(id: 1)], count: 2);
          expectEventsByIDs(sessions.withPage()!.events, [0]);
          expectEventsByIDs(sessions.withPage(page)!.events, [1]);
        });
        test('session is continued once the page route is reopened', () {
          registerEvent();
          manager.onRouteOpened(PageStatus(name: 'other'));
          manager.onRouteOpened(PageStatus(name: ''));
          var sessions = simpleProcessEvents([Event(id: 1)], count: 1);
          expect(sessions.first.events, hasLength(2));
        });
        test('global detector events are discarded during open popups', () {
          manager.onRouteOpened(PageStatus(name: 'popup', isPopup: true));
          simpleProcessEvents([Event()], count: 0);
        });
        test('area detector events are processed during open popups', () {
          manager.onRouteOpened(PageStatus(name: 'popup', isPopup: true));
          processEvents([
            EventDescriptor(Event(), detectorStatus(areaID: 'area')),
          ]);
        });
        test(
          'waits for the page transition before calling background manager',
          () {
            return FakeAsync().run((self) {
              var duration = Duration(seconds: 2);
              manager.onRouteOpened(PageStatus(
                name: 'page',
                transitionDuration: duration,
              ));
              simpleProcessEvents([Event()]);
              var bgManager = S.get<BackgroundManager>();
              verifyNever(() => bgManager.onEvent(any(), any(), any()));
              self.elapse(duration);
              verify(() => bgManager.onEvent(any(), any(), any())).called(1);
            });
          },
        );
      });
    });

    group('Other events', () {
      test('events are ignored if no route is set', () {
        manager.onRouteOpened(null);
        simpleProcessEvents([Event()], count: 0);
      });
      test('all sessions are ended when app goes into paused state', () {
        registerEvent();
        manager.onLifecycleStateChanged(AppLifecycleState.paused);
        verify(() => S.get<GraphicalProcessor>().process(any())).called(1);
      });
    });
  });
}
