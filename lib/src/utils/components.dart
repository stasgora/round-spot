import 'package:get_it/get_it.dart';

import '../components/processors/graphical_processor.dart';
import '../components/processors/numerical_processor.dart';
import '../components/screenshot_provider.dart';
import '../components/session_manager.dart';
import '../entry_point.dart';
import '../models/config/config.dart';

final GetIt _instance = GetIt.asNewInstance();
GetIt get S => _instance;

void initializeComponents(Config? config, HeatMapCallback? heatMapCallback,
    NumericCallback? numericCallback) {
  S.registerSingleton<Config>(config ?? Config());
  S.registerSingleton<ScreenshotProvider>(ScreenshotProvider());
  S.registerSingleton<GraphicalProcessor>(GraphicalProcessor());
  S.registerSingleton<NumericalProcessor>(NumericalProcessor());
  S.registerSingleton<SessionManager>(
      SessionManager(heatMapCallback, numericCallback));
}
