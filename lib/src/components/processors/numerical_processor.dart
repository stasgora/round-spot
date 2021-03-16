import '../../models/session.dart';
import '../../utils/file_utils.dart';

import 'session_processor.dart';

class NumericalProcessor extends SessionProcessor {
  @override
  Future process(Session session) => saveDebugData(session.toJson());
}
