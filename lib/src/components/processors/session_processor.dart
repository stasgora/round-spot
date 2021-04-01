import 'package:flutter/foundation.dart';
import '../../models/config/config.dart';
import '../../models/session.dart';
import '../../utils/components.dart';

/// Defines an interface for processing sessions
abstract class SessionProcessor {
  @protected
  final config = S.get<Config>();

  Future process(Session session);
}
