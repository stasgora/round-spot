import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../../round_spot.dart';
import '../models/detector_status.dart';
import '../models/event.dart';
import '../models/page_status.dart';
import '../models/session.dart';
import '../utils/components.dart';
import 'background_manager.dart';
import 'processors/data_serializer.dart';
import 'processors/local_processor.dart';

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
    this._localRenderCallback,
    this._dataCallback,
  );

  final _dataSerializer = S.get<DataSerializer>();
  final _localProcessor = S.get<LocalProcessor>();

  final LocalRenderCallback? _localRenderCallback;
  final DataCallback? _dataCallback;

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
    await _pageStatus!.transitionEnded;
    _backgroundManager.onEvent(event.location, session, status.areaKey);
  }

  /// Handles the scroll event of a [Session]
  void onSessionScroll(DetectorStatus status) async {
    await _pageStatus!.transitionEnded;
    _backgroundManager.onScroll(_getSession(status), status.areaKey);
  }

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
  void endSessions() async {
    var dataOutput = _config.outputType == OutputType.data;
    var minEventCount = dataOutput ? 1 : _config.minSessionEventCount;
    var sessions = _closeSessionsWith(minEventCount);
    if (sessions.isEmpty) return;
    if ((dataOutput ? _dataCallback : _localRenderCallback) == null) {
      _logger.warning('Output callback is not set, no data will be returned.');
      return;
    }
    if (dataOutput) {
      _dataCallback!(await _dataSerializer.process(sessions));
    } else {
      _render(sessions);
    }
  }

  void _render(Iterable<Session> sessions) {
    for (var session in sessions) {
      runZonedGuarded(
        () async {
          var output = await _localProcessor.process(session);
          if (output == null) return;
          _localRenderCallback!(output, session);
        },
        (e, stackTrace) => _logger.severe(
            'Error occurred while processing locally', e, stackTrace),
      );
    }
  }

  Iterable<Session> _closeSessionsWith(int minEventCount) {
    bool close(Session session) => session.eventCount >= minEventCount;
    var closed = _sessions.values.where(close).toList();
    _sessions.removeWhere((_, session) => close(session));
    return closed;
  }
}
