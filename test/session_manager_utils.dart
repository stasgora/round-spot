import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:collection/collection.dart';

import 'package:round_spot/src/components/background_manager.dart';
import 'package:round_spot/src/components/processors/local_processor.dart';
import 'package:round_spot/src/components/processors/data_serializer.dart';
import 'package:round_spot/src/components/session_manager.dart';
import 'package:round_spot/src/models/config/config.dart';
import 'package:round_spot/src/models/detector_status.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/models/page_status.dart';
import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/components.dart';

class BackgroundManagerMock extends Mock implements BackgroundManager {}

class LocalProcessorMock extends Mock implements LocalProcessor {}

class DataSerializerMock extends Mock implements DataSerializer {}

late SessionManager manager;

class EventDescriptor {
  final Event event;
  final DetectorStatus status;

  EventDescriptor(this.event, this.status);
  EventDescriptor.screen(this.event) : status = detectorStatus();
}

void setUpOnce() {
  setUpAll(() {
    S.registerSingleton<BackgroundManager>(BackgroundManagerMock());
    S.registerSingleton<LocalProcessor>(LocalProcessorMock());
    S.registerSingleton<DataSerializer>(DataSerializerMock());
    S.registerSingleton<Config>(Config());

    registerFallbackValue<Session>(Session(page: '', area: ''));
    registerFallbackValue<GlobalKey>(GlobalKey());
    registerFallbackValue<Offset>(Offset.zero);
  });
}

void setUpEveryTime() {
  setUp(() {
    reset(S.get<BackgroundManager>());
    reset(S.get<LocalProcessor>());
    reset(S.get<DataSerializer>());
    S.unregister<Config>();
    S.registerSingleton<Config>(Config());

    manager = SessionManager((_, __) {}, (_) {});
    manager.onRouteOpened(PageStatus(name: ''));

    when(() => S.get<DataSerializer>().process(any()))
        .thenAnswer((_) => Future.value(Uint8List(0)));
  });
}

DetectorStatus detectorStatus({String areaID = '', bool cumulative = false}) {
  return DetectorStatus(
    areaKey: GlobalKey(),
    areaID: areaID,
    cumulative: cumulative,
  );
}

List<Session> simpleProcessEvents(List<Event> events, {int count = 1}) {
  return processEvents(
    events.map((e) => EventDescriptor.screen(e)).toList(),
    count: count,
  );
}

List<Session> processEvents(List<EventDescriptor> events, {int count = 1}) {
  for (var event in events) {
    manager.onEvent(event: event.event, status: event.status);
  }
  manager.endSessions();
  if (count == 0) {
    verifyNever(() => S.get<LocalProcessor>().process(any()));
    return [];
  }
  var args = verify(() {
    return S.get<LocalProcessor>().process(captureAny());
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
