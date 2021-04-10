import 'dart:typed_data';

import '../../models/session.dart';
import '../../utils/utils.dart';

import 'session_processor.dart';

/// Processes sessions into raw json format
class RawDataProcessor extends SessionProcessor {
  @override
  Future<Uint8List?> process(Session session) =>
      exportNumericData(session.toJson());
}
