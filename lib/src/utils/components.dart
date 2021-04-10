import 'package:get_it/get_it.dart';

import '../components/processors/graphical_processor.dart';
import '../components/processors/raw_data_processor.dart';
import '../components/screenshot_provider.dart';
import '../components/session_manager.dart';
import '../entry_point.dart';
import '../models/config/config.dart';

final GetIt _instance = GetIt.asNewInstance();

/// Library internal [GetIt] instance holding each of its components
GetIt get S => _instance;

/// Initializes all of the internal library components
void initializeComponents(Config? config, OutputCallback? heatMapCallback,
    OutputCallback? rawDataCallback) {
  S.registerSingleton<Config>(config ?? Config());
  S.registerSingleton<ScreenshotProvider>(ScreenshotProvider());
  S.registerSingleton<GraphicalProcessor>(GraphicalProcessor());
  S.registerSingleton<RawDataProcessor>(RawDataProcessor());
  S.registerSingleton<SessionManager>(
      SessionManager(heatMapCallback, rawDataCallback));
}
