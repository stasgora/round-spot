import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

import '../../round_spot.dart';
import '../models/detector_config.dart';
import '../models/event.dart';
import '../models/session.dart';
import '../utils/components.dart';
import 'processors/graphical_processor.dart';
import 'processors/raw_data_processor.dart';
import 'processors/session_processor.dart';
import 'screenshot_provider.dart';

/// Coordinates and manages data gathering, processing and reporting.
class SessionManager {
  final HeatMapCallback? heatMapCallback;
  final RawDataCallback? rawDataCallback;

  final _logger = Logger('RoundSpot.SessionManager');

  final _config = S.get<Config>();
  final _screenshotProvider = S.get<ScreenshotProvider>();

  final Map<String, Session> _pages = {};
  final Set<int> _processedEventIDs = {};
  String? _currentPage;
  bool _currentPageDisabled = false;
  Timer? _idleTimer;

  SessionManager(this.heatMapCallback, this.rawDataCallback);

  final Map<OutputType, SessionProcessor> _processors = {
    OutputType.graphicalRender: S.get<GraphicalProcessor>(),
    OutputType.rawData: S.get<RawDataProcessor>()
  };

  void onLifecycleStateChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _endSessions();
  }

  void onRouteOpened({String? name}) {
    _currentPageDisabled = _config.disabledRoutes.contains(name);
    _currentPage = name ?? '${DateTime.now()}';
  }

  void onEvent({required Event event, required DetectorConfig detector}) async {
    if (_currentPage == null || _processedEventIDs.contains(event.id)) return;
    if (!_config.enabled) {
      _endSessions();
      return;
    }
    if (_currentPageDisabled && !detector.hasGlobalScope) return;
    var sessionKey = detector.areaID;
    if (!detector.hasGlobalScope) sessionKey += _currentPage!;

    var session = (_pages[sessionKey] ??= Session(
      page: detector.hasGlobalScope ? null : _currentPage,
      area: detector.areaID,
    ));
    session.addEvent(event);
    _processedEventIDs.add(event.id);
    if (_config.maxSessionIdleTime != null) {
      _idleTimer?.cancel();
      _idleTimer = Timer(
        Duration(seconds: _config.maxSessionIdleTime!),
        _endSessions,
      );
    }
    if (session.screenSnap == null) {
      session.screenSnap =
          await _screenshotProvider.takeScreenshot(detector.areaKey);
    }
  }

  void _endSessions() {
    bool skipSession(Session session) =>
        session.events.length < _config.minSessionEventCount;
    for (var key in _pages.keys) {
      if (!skipSession(_pages[key]!)) _exportSession(key);
    }
    //_pages.removeWhere((key, session) => !skipSession(session));
  }

  void _exportSession(String key) {
    if (!_pages.containsKey(key)) return;
    for (var type in _config.outputTypes) {
      runZonedGuarded(() async {
        if ((type == OutputType.graphicalRender
                ? heatMapCallback
                : rawDataCallback) ==
            null) {
          _logger.warning(
            'Requested $type generation but the callback is null, skipping.',
          );
          return;
        }
        var session = _pages[key]!;
        var output = await _processors[type]!.process(session);
        if (type == OutputType.graphicalRender) {
          heatMapCallback!(output, session);
        } else {
          rawDataCallback!(output);
        }
      }, (e, stackTrace) {
        _logger.severe(
          'Error occurred while generating $type, please report at: https://github.com/stasgora/round-spot/issues',
          e,
          stackTrace,
        );
      });
    }
  }
}
