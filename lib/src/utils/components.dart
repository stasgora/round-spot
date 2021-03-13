import 'package:get_it/get_it.dart';
import 'package:round_spot/round_spot.dart';

import 'package:round_spot/src/components/screenshot_provider.dart';
import 'package:round_spot/src/components/session_manager.dart';

final GetIt _instance = GetIt.asNewInstance();
GetIt get S => _instance;

void initializeComponents(RoundSpotConfig? config) {
	S.registerSingleton<RoundSpotConfig>(config ?? RoundSpotConfig());
	S.registerSingleton<ScreenshotProvider>(ScreenshotProvider());
	S.registerSingleton<SessionManager>(SessionManager());
}
