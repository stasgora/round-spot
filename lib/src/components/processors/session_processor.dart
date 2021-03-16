import 'package:flutter/foundation.dart';
import '../../models/config.dart';
import '../../models/session.dart';
import '../../utils/components.dart';

abstract class SessionProcessor {
  @protected
  final config = S.get<RoundSpotConfig>();

  Future process(Session session);
}
