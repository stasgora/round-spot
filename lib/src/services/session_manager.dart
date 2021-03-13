import 'dart:ui';

import 'package:round_spot/round_spot.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/components.dart';

import 'session_renderer.dart';

class SessionManager {
	final _renderer = S.get<SessionRenderer>();
	final _config = S.get<RoundSpotConfig>();

	Session? _session;

	void startSession({String? name}) {
		if (_session != null && shouldSaveSession())
			_renderer.render(_session!..end());
		_session = Session(name: name);
	}

	void registerEvent(Offset position) {
		if (_session != null)
	    _session!.events.add(Event(position, DateTime.now().millisecondsSinceEpoch));
	}

	bool shouldSaveSession() => _session!.events.length >= _config.minSessionEventCount;
}
