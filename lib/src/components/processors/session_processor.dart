import 'package:flutter/foundation.dart';
import 'package:round_spot/src/models/config.dart';
import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/components.dart';

abstract class SessionProcessor {
  @protected
  final config = S.get<RoundSpotConfig>();

  Future process(Session session);
}
