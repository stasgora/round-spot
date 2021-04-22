import 'dart:async';
import 'dart:ui';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

import '../../round_spot.dart';
import '../models/detector_status.dart';
import '../models/event.dart';
import '../models/session.dart';
import '../utils/components.dart';
import 'processors/graphical_processor.dart';
import 'processors/raw_data_processor.dart';
import 'processors/session_processor.dart';
import 'screenshot_provider.dart';

/// Coordinates and manages data gathering, processing and reporting.
class SessionManager {
  final _logger = Logger('RoundSpot.SessionManager');

  final _config = S.get<Config>();
  final _screenshotProvider = S.get<ScreenshotProvider>();

  final Map<String, Session> _sessions = {};
  final Set<int> _processedEventIDs = {};
  String? _currentPage;
  bool _currentPageDisabled = false;
  Timer? _idleTimer;

  /// Creates a [SessionManager] that manages the data flow
  SessionManager(
      OutputCallback? _heatMapCallback, OutputCallback? _rawDataCallback)
      : _callbacks = {
          OutputType.graphicalRender: _heatMapCallback,
          OutputType.rawData: _rawDataCallback,
        };

  final Map<OutputType, SessionProcessor> _processors = {
    OutputType.graphicalRender: S.get<GraphicalProcessor>(),
    OutputType.rawData: S.get<RawDataProcessor>()
  };

  final Map<OutputType, OutputCallback?> _callbacks;

  /// Handles application lifecycle state changes
  void onLifecycleStateChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _endSessions();
  }

  /// Handles application [PageRoute] changes
  void onRouteOpened({RouteSettings? settings}) {
    if (settings == null) {
      _currentPage = null;
      return;
    }
    _currentPageDisabled = _config.disabledRoutes.contains(settings.name);
    _currentPage = settings.name ?? '${DateTime.now()}';
  }

  /// Handles processing user interactions
  void onEvent({required Event event, required DetectorStatus status}) async {
    if (_currentPage == null) {
      _logger.warning(
        'The current page route was not detected. '
        'Make sure the navigation Observer is setup correctly.',
      );
      return;
    }
    if (_currentPage == null || _processedEventIDs.contains(event.id)) return;
    if (!_config.enabled) {
      _endSessions();
      return;
    }
    if (_currentPageDisabled && !status.hasGlobalScope) return;

    var session = _recordEvent(event: event, status: status);
    _screenshotProvider.takeScreenshot(session, status);
  }

  Session _recordEvent({required Event event, required DetectorStatus status}) {
    var sessionKey = status.areaID;
    if (!status.hasGlobalScope) {
      sessionKey += _currentPage!;
      _processedEventIDs.add(event.id);
    }
    var session = (_sessions[sessionKey] ??= Session(
      page: status.hasGlobalScope ? null : _currentPage,
      area: status.areaID,
      pixelRatio: _config.heatMapPixelRatio,
      axis: status is ScrollDetectorStatus ? status.scrollAxis : null,
    ));
    if (status is ScrollDetectorStatus) event.location += status.asScrollOffset;
    session.addEvent(event);
    if (_config.maxSessionIdleTime != null) {
      _idleTimer?.cancel();
      _idleTimer = Timer(
        Duration(seconds: _config.maxSessionIdleTime!),
        _endSessions,
      );
    }
    return session;
  }

  void _endSessions() {
    bool skipSession(Session session) =>
        session.events.length < _config.minSessionEventCount;
    for (var key in _sessions.keys) {
      if (!skipSession(_sessions[key]!)) _exportSession(key);
    }
    _sessions.removeWhere((key, session) => !skipSession(session));
  }

  void _exportSession(String key) {
    if (!_sessions.containsKey(key)) return;
    for (var type in _config.outputTypes) {
      var typeName = EnumToString.convertToString(type, camelCase: true);
      runZonedGuarded(() async {
        if (_callbacks[type] == null) {
          _logger.warning(
            'Requested $typeName output but the callback is not set, skipping.',
          );
          return;
        }
        var session = _sessions[key]!;
        var output = await _processors[type]!.process(session);
        if (output == null) return;
        _callbacks[type]!(output, session);
      }, (e, stackTrace) {
        _logger.severe(
          'Error occurred while generating $typeName',
          e,
          stackTrace,
        );
      });
    }
  }
}
