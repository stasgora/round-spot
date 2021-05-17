import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:collection/collection.dart';

import 'package:round_spot/src/components/background_manager.dart';
import 'package:round_spot/src/components/processors/graphical_processor.dart';
import 'package:round_spot/src/components/processors/raw_data_processor.dart';
import 'package:round_spot/src/components/session_manager.dart';
import 'package:round_spot/src/models/config/config.dart';
import 'package:round_spot/src/models/detector_status.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/components.dart';

class MockBackgroundManager extends Mock implements BackgroundManager {}

class MockGraphicalProcessor extends Mock implements GraphicalProcessor {}

class MockRawDataProcessor extends Mock implements RawDataProcessor {}

late SessionManager manager;

class EventDescriptor {
  final Event event;
  final DetectorStatus status;

  EventDescriptor(this.event, this.status);
  EventDescriptor.global(this.event) : status = detectorStatus();
}

void setUpOnce() {
  setUpAll(() {
    S.registerSingleton<BackgroundManager>(MockBackgroundManager());
    S.registerSingleton<GraphicalProcessor>(MockGraphicalProcessor());
    S.registerSingleton<RawDataProcessor>(MockRawDataProcessor());
    S.registerSingleton<Config>(Config());

    registerFallbackValue<Session>(Session(page: '', area: ''));
    registerFallbackValue<GlobalKey>(GlobalKey());
  });
}

void setUpEveryTime() {
  setUp(() {
    reset(S.get<BackgroundManager>());
    reset(S.get<GraphicalProcessor>());
    reset(S.get<RawDataProcessor>());
    S.unregister<Config>();
    S.registerSingleton<Config>(Config());

    manager = SessionManager((_, __) {}, (_, __) {});
    manager.onRouteOpened(settings: RouteSettings(name: ''));
  });
}

DetectorStatus detectorStatus({String areaID = '', bool global = false}) {
  return DetectorStatus(
    areaKey: GlobalKey(),
    areaID: areaID,
    hasGlobalScope: global,
  );
}

List<Session> simpleProcessEvents(List<Event> events, {int count = 1}) {
  return processEvents(
    events.map((e) => EventDescriptor.global(e)).toList(),
    count: count,
  );
}

List<Session> processEvents(List<EventDescriptor> events, {int count = 1}) {
  for (var event in events) {
    manager.onEvent(event: event.event, status: event.status);
  }
  manager.endSessions();
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

void registerEvent({Event? event, DetectorStatus? status}) {
  event ??= Event();
  status ??= detectorStatus();
  manager.onEvent(event: event, status: status);
}

void expectEventsByIDs(List<Event> actual, List<int> expectedIDs) {
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
