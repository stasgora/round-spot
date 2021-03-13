import 'dart:ui';

import 'package:round_spot/round_spot.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/components.dart';

import 'processors/numerical_processor.dart';
import 'processors/session_processor.dart';
import 'processors/graphical_processor.dart';

class SessionManager {
	final _config = S.get<RoundSpotConfig>();

	Session? _session;
	final Map<RoundSpotOutputType, SessionProcessor> _processors = {
		RoundSpotOutputType.GRAPHICAL_RENDER : GraphicalProcessor(),
		RoundSpotOutputType.NUMERIC_DATA : NumericalProcessor()
	};

	void startSession({String? name}) {
		if (_session != null && shouldSaveSession())
			for (var type in _config.outputTypes)
				_processors[type]!.process(_session!..end());
		_session = Session(name: name);
	}

	void registerEvent(Offset position) {
		if (_session != null)
	    _session!.events.add(Event(position, DateTime.now().millisecondsSinceEpoch));
	}

	bool shouldSaveSession() => _session!.events.length >= _config.minSessionEventCount;
}
