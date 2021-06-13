import 'package:get_it/get_it.dart';

import '../components/background_manager.dart';
import '../components/processors/data_serializer.dart';
import '../components/processors/local_processor.dart';
import '../components/session_manager.dart';
import '../entry_point.dart';
import '../models/config/config.dart';

final GetIt _instance = GetIt.asNewInstance();

/// Library internal [GetIt] instance holding each of its components
GetIt get S => _instance;

/// Initializes all of the internal library components
void initializeComponents(
  Config? config,
  LocalRenderCallback? localRenderCallback,
  DataCallback? dataCallback,
) {
  S.registerSingleton<Config>(config ?? Config());
  S.registerSingleton<BackgroundManager>(BackgroundManager());
  S.registerSingleton<LocalProcessor>(LocalProcessor());
  S.registerSingleton<DataSerializer>(DataSerializer());
  S.registerSingleton<SessionManager>(
      SessionManager(localRenderCallback, dataCallback));
}
