import 'dart:async';
import 'dart:ui';

import 'package:logging/logging.dart';

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

  final Map<String, Session> _pages = {};
  String? _currentPage;

  Session? get _session => _pages[_currentPage];

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
    _createSession();
  }

  void onEvent(Offset position) async {
    if (_currentPage == null) return;
    _createSession();
    var event = Event(position, DateTime.now().millisecondsSinceEpoch);
    _session!.events.add(event);
    if (_session!.screenSnap == null) {
      _session!.screenSnap = await _screenshotProvider.takeScreenshot();
    }
  }

  void _createSession() =>
      _pages[_currentPage!] ??= Session(name: _currentPage!);

  void _endSessions() {
    bool skipSession(Session session) =>
        session.events.length < _config.minSessionEventCount;
    for (var key in _pages.keys) {
      if (!skipSession(_pages[key]!)) _exportSession(key);
    }
    _pages.removeWhere((key, session) => !skipSession(session));
  }

  void _exportSession(String name) {
    if (!_pages.containsKey(name)) return;
    for (var type in _config.outputTypes) {
      runZonedGuarded(() async {
        if ((type == OutputType.graphicalRender
            ? heatMapCallback : numericCallback) == null) {
          _logger.warning(
              'Requested $type generation but the callback is null, skipping.');
          return;
        }
        var session = _pages[name]!;
        var output = await _processors[type]!.process(session..end());
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
