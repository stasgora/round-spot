import 'package:get_it/get_it.dart';

import 'package:round_spot/src/services/screenshot_provider.dart';
import 'package:round_spot/src/services/session_manager.dart';
import 'package:round_spot/src/services/session_renderer.dart';

final GetIt _instance = GetIt.asNewInstance();
GetIt get S => _instance;

void initializeServices() {
	S.registerSingleton<ScreenshotProvider>(ScreenshotProvider());
	S.registerSingleton<SessionRenderer>(SessionRenderer());
	S.registerSingleton<SessionManager>(SessionManager());
}