import '../../models/session.dart';
import '../../utils/utils.dart';

import 'session_processor.dart';

class NumericalProcessor extends SessionProcessor {
  @override
  Future process(Session session) => exportNumericData(session.toJson());
}
