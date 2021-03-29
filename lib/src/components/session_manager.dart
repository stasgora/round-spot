import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:tuple/tuple.dart';

import '../../round_spot.dart';
import '../models/event.dart';
import '../models/session.dart';
import '../utils/components.dart';
import 'processors/graphical_processor.dart';
import 'processors/numerical_processor.dart';
import 'processors/session_processor.dart';
import 'screenshot_provider.dart';

class SessionManager {
  final HeatMapCallback? heatMapCallback;
  final NumericCallback? numericCallback;

  final _logger = Logger('RoundSpot.SessionManager');

  final _config = S.get<Config>();
  final _screenshotProvider = S.get<ScreenshotProvider>();

  final Map<Tuple2<String, GlobalKey>, Session> _pages = {};
  String? _currentPage;
  Timer? _idleTimer;

  SessionManager(this.heatMapCallback, this.numericCallback);

  final Map<OutputType, SessionProcessor> _processors = {
    OutputType.graphicalRender: S.get<GraphicalProcessor>(),
    OutputType.numericData: S.get<NumericalProcessor>()
  };

  void onLifecycleStateChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _endSessions();
  }

  void onRouteOpened({String? name}) {
    var routes = _config.disabledRoutes;
    if (routes != null && routes.contains(name)) return;
    _currentPage = name ?? '${DateTime.now()}';
  }

  void onEvent({required Event event, required GlobalKey areaKey}) async {
    if (_currentPage == null) return;
    if (!_config.enabled) {
      _endSessions();
      return;
    }
    var sessionKey = Tuple2(_currentPage!, areaKey);
    var session = (_pages[sessionKey] ??= Session(name: _currentPage!));
    session.addEvent(event);
    if (_config.maxSessionIdleTime != null) {
      _idleTimer?.cancel();
      _idleTimer =
          Timer(Duration(seconds: _config.maxSessionIdleTime!), _endSessions);
    }
    if (session.screenSnap == null) {
	    session.screenSnap = await _screenshotProvider.takeScreenshot(areaKey);
    }
  }

  void _endSessions() {
    bool skipSession(Session session) =>
        session.events.length < _config.minSessionEventCount;
    for (var key in _pages.keys) {
      if (!skipSession(_pages[key]!)) _exportSession(key);
    }
    _pages.removeWhere((key, session) => !skipSession(session));
  }

  void _exportSession(Tuple2<String, GlobalKey> key) {
    if (!_pages.containsKey(key)) return;
    for (var type in _config.outputTypes) {
      runZonedGuarded(() async {
        if ((type == OutputType.graphicalRender
                ? heatMapCallback
                : numericCallback) ==
            null) {
          _logger.warning(
              'Requested $type generation but the callback is null, skipping.');
          return;
        }
        var session = _pages[key]!;
        var output = await _processors[type]!.process(session);
        if (type == OutputType.graphicalRender) {
          heatMapCallback!(output, session);
        } else {
          numericCallback!(output);
        }
      }, (e, stackTrace) {
        _logger.severe(
            'Error occurred while generating $type, please report at: https://github.com/stasgora/round-spot/issues',
            e,
            stackTrace);
      });
    }
  }
}
