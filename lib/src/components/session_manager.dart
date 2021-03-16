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

	Session? _session;
	final Map<OutputType, SessionProcessor> _processors = {
		OutputType.graphicalRender : S.get<GraphicalProcessor>(),
		OutputType.numericData : S.get<NumericalProcessor>()
	};

	void startSession({String? name}) {
		if (_session != null && shouldSaveSession()) {
			for (var type in _config.outputTypes) {
			  _processors[type]!.process(_session!..end());
			}
		}
		_session = Session(name: name);
	}

	void registerEvent(Offset position) {
		if (_session == null) return;
		var event = Event(position, DateTime.now().millisecondsSinceEpoch);
		_session!.events.add(event);
	}

	bool shouldSaveSession() {
	  return _session!.events.length >= _config.minSessionEventCount;
	}
}
