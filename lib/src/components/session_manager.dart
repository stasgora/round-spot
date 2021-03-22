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

  Session? get _session => _pages[_currentPage];

  final Map<OutputType, SessionProcessor> _processors = {
    OutputType.graphicalRender: S.get<GraphicalProcessor>(),
    OutputType.numericData: S.get<NumericalProcessor>()
  };

  void onPageOpened({String? name}) {
    if (_currentPage != null && shouldSaveSession()) {
      for (var type in _config.outputTypes) {
        _processors[type]!.process(_session!..end());
      }
    }
    _currentPage = name ?? '${DateTime.now()}';
    _pages[_currentPage!] ??= Session(name: name);
  }

  void onEvent(Offset position) {
    if (_currentPage == null) return;
    var event = Event(position, DateTime.now().millisecondsSinceEpoch);
    _session!.events.add(event);
  }

  bool shouldSaveSession() {
    return _session!.events.length >= _config.minSessionEventCount;
  }
}
