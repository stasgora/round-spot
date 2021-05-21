import 'dart:async';
import 'dart:ui';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../../round_spot.dart';
import '../models/detector_status.dart';
import '../models/event.dart';
import '../models/page_status.dart';
import '../models/session.dart';
import '../utils/components.dart';
import 'background_manager.dart';
import 'processors/graphical_processor.dart';
import 'processors/raw_data_processor.dart';
import 'processors/session_processor.dart';

/// Coordinates and manages data gathering, processing and reporting.
class SessionManager {
  final _logger = Logger('RoundSpot.SessionManager');

  final _config = S.get<Config>();
  final _backgroundManager = S.get<BackgroundManager>();

  final Map<String, Session> _sessions = {};
  final Set<int> _processedEventIDs = {};
  Timer? _idleTimer;

  /// Current route status
  PageStatus? _pageStatus;

  /// Creates a [SessionManager] that manages the data flow
  SessionManager(
    OutputCallback? _heatMapCallback,
    OutputCallback? _rawDataCallback,
  ) : _callbacks = {
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
    if (state == AppLifecycleState.paused) endSessions();
  }

  /// Handles processing user interactions
  void onRouteOpened(PageStatus? status) {
    _pageStatus = status;
    _logger.finer('${status?.name} route opened');
  }

  /// Handles processing user interactions
  void onEvent({required Event event, required DetectorStatus status}) async {
    if (_pageStatus == null) {
      _logger.warning(
        'Current page route was not detected. '
        'Make sure the navigation Observer is setup correctly.',
      );
      return;
    }
    if (_processedEventIDs.contains(event.id)) return;
    if (!_config.enabled) {
      endSessions();
      return;
    }
    if (_pageStatus!.disabled && !status.cumulative) return;
    if (_pageStatus!.isPopup && status.globalDetector) return;

    var session = _recordEvent(event: event, status: status);
    _backgroundManager.onEvent(event.location, session, status.areaKey);
  }

  /// Handles the scroll event of a [Session]
  void onSessionScroll(DetectorStatus status) =>
      _backgroundManager.onScroll(_getSession(status), status.areaKey);

  Session _recordEvent({required Event event, required DetectorStatus status}) {
    var session = _getSession(status);
    if (!status.cumulative) _processedEventIDs.add(event.id);
    session.addEvent(event);
    if (_config.maxSessionIdleTime != null) {
      _idleTimer?.cancel();
      _idleTimer = Timer(
        Duration(seconds: _config.maxSessionIdleTime!),
        endSessions,
      );
    }
    return session;
  }

  Session _getSession(DetectorStatus status) {
    var sessionKey = status.areaID;
    if (!status.cumulative) sessionKey += _pageStatus!.name;
    if (_pageStatus!.nameMissing &&
        _sessions[sessionKey] == null &&
        !status.cumulative &&
        !_pageStatus!.isPopup) {
      _logger.warning('Current page has no name set.');
    }
    return (_sessions[sessionKey] ??= Session(
      page: status.cumulative ? null : _pageStatus!.name,
      area: status.areaID,
      pixelRatio: _config.heatMapPixelRatio,
      isPopup: _pageStatus!.isPopup,
    ))
      ..scrollStatus = status.scrollStatus;
  }

  /// Triggers the session processing
  @visibleForTesting
  void endSessions() {
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
      var name = EnumToString.convertToString(type, camelCase: true);
      runZonedGuarded(
        () async {
          if (_callbacks[type] == null) {
            _logger.warning(
              'Requested $name output but the callback is not set, skipping.',
            );
            return;
          }
          var session = _sessions[key]!;
          var output = await _processors[type]!.process(session);
          if (output == null) return;
          _callbacks[type]!(output, session);
        },
        (e, stackTrace) => _logger.severe(
            'Error occurred while generating $name', e, stackTrace),
      );
    }
  }
}
