import 'dart:async';
import 'dart:ui';

import '../../round_spot.dart';
import '../models/event.dart';
import '../models/session.dart';
import '../utils/components.dart';
import 'processors/graphical_processor.dart';
import 'processors/numerical_processor.dart';
import 'processors/session_processor.dart';

class SessionManager {
  final _config = S.get<RoundSpotConfig>();

  final Map<String, Session> _pages = {};
  String? _currentPage;

  SessionManager(
      HeatMapCallback? heatMapCallback, NumericCallback? numericCallback)
      : _callbacks = {
          OutputType.graphicalRender: heatMapCallback,
          OutputType.numericData: numericCallback
        };

  Session? get _session => _pages[_currentPage];

  final Map<OutputType, Function?> _callbacks;
  final Map<OutputType, SessionProcessor> _processors = {
    OutputType.graphicalRender: S.get<GraphicalProcessor>(),
    OutputType.numericData: S.get<NumericalProcessor>()
  };

  void onPageOpened({String? name}) {
    if (_currentPage != null && _shouldSaveSession()) saveSession(_session!);
    _currentPage = name ?? '${DateTime.now()}';
    _pages[_currentPage!] ??= Session(name: name);
  }

  void onEvent(Offset position) {
    if (_currentPage == null) return;
    var event = Event(position, DateTime.now().millisecondsSinceEpoch);
    _session!.events.add(event);
  }

  bool _shouldSaveSession() {
    return _session!.events.length >= _config.minSessionEventCount;
  }

  void saveSession(Session session) {
    for (var type in _config.outputTypes) {
      runZoned(() async {
        if (_callbacks[type] == null) return;
        var output = await _processors[type]!.process(_session!..end());
        _callbacks[type]!(output);
      });
    }
  }
}
