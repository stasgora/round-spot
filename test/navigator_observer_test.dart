import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:round_spot/src/components/session_manager.dart';
import 'package:round_spot/src/models/config/config.dart';
import 'package:round_spot/src/models/page_status.dart';
import 'package:round_spot/src/navigator_observer.dart';
import 'package:round_spot/src/utils/components.dart';

class SessionManagerMock extends Mock implements SessionManager {}

late Observer _observer;

void main() {
  group('Observer', () {
    setUpAll(() {
      S.registerSingleton<SessionManager>(SessionManagerMock());
      S.registerSingleton<Config>(Config());
    });
    setUp(() {
      reset(S.get<SessionManager>());
      S.unregister<Config>();
      S.registerSingleton<Config>(Config());

      _observer = Observer();
    });

    test('reports correct page on push', () {
      var route = 'current-route';
      var lastRoute = 'last-route';
      _observer.didPush(_createRoute(route), _createRoute(lastRoute));
      _verifyRouteOpened(PageStatus(name: route));
    });
    test('reports correct page on pop', () {
      var route = 'current-route';
      var lastRoute = 'last-route';
      _observer.didPop(_createRoute(route), _createRoute(lastRoute));
      _verifyRouteOpened(PageStatus(name: lastRoute));
    });
    test('recognises disabled pages', () {
      var route = 'disabled-route';
      S.get<Config>().disabledRoutes = {route};
      _observer.didPush(_createRoute(route), null);
      _verifyRouteOpened(PageStatus(name: route, disabled: true));
    });
    test('recognises popup pages', () {
      var route = 'route';
      _observer.didPush(_createRoute(route, popup: true), null);
      _verifyRouteOpened(PageStatus(name: route, isPopup: true));
    });
  });
}

void _verifyRouteOpened(PageStatus page) {
  verify(() => S.get<SessionManager>().onRouteOpened(page)).called(1);
}

ModalRoute _createRoute(String name, {bool popup = false}) {
  return popup
      ? RawDialogRoute(
          pageBuilder: (_, __, ___) => Container(),
          settings: RouteSettings(name: name),
        )
      : MaterialPageRoute(
          builder: (_) => Container(),
          settings: RouteSettings(name: name),
        );
}
