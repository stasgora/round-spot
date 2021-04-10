import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import '../../models/config/config.dart';
import '../../models/session.dart';
import '../../utils/components.dart';

/// Defines an interface for processing sessions
abstract class SessionProcessor {
  /// Provides access to [Config]
  @protected
  final config = S.get<Config>();

  /// Processes a [Session] into a certain [OutputType]
  Future<Uint8List?> process(Session session);
}
