import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/file_utils.dart';

import 'session_processor.dart';

class NumericalProcessor extends SessionProcessor {
  @override
  Future process(Session session) => saveDebugData(session.toJson());
}
