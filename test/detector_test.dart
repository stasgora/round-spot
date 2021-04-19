import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/widgets.dart';
import 'package:round_spot/src/components/session_manager.dart';
import 'package:round_spot/src/models/detector_status.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/utils/components.dart';
import 'package:round_spot/src/widgets/detector.dart';

class MockSessionManager extends Mock implements SessionManager {}

void main() {
  S.registerSingleton<SessionManager>(MockSessionManager());
  registerFallbackValue<Event>(Event(location: Offset.zero, id: 0));
  registerFallbackValue<DetectorStatus>(DetectorStatus(areaKey: GlobalKey()));

  group('Detector', () {
    setUp(() {
      reset(S.get<SessionManager>());
    });

    testWidgets('reports events', (tester) async {
      await tester.pumpWidget(
        Detector(
          areaID: '',
          child: Container(),
        ),
      );
      await tester.press(find.byType(Container));
      _validate();
    });
    testWidgets('recognizes scroll spaces', (tester) async {
      await tester.pumpWidget(
        Detector(
          areaID: '',
          child: SingleChildScrollView(),
        ),
      );
      await tester.press(find.byType(SingleChildScrollView));
      var status = _validate();
      expect(status, isA<ScrollDetectorStatus>());
    });
    testWidgets('tracks scroll amount', (tester) async {
      await tester.pumpWidget(
        Detector(
          areaID: '',
          child: SingleChildScrollView(
            controller: ScrollController(initialScrollOffset: 20),
          ),
        ),
      );
      await tester.press(find.byType(SingleChildScrollView));
      var status = _validate() as ScrollDetectorStatus;
      expect(status.scrollPosition, equals(20));
    });
    testWidgets('determines the scroll axis', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Detector(
            areaID: '',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      );
      await tester.press(find.byType(SingleChildScrollView));
      var status = _validate() as ScrollDetectorStatus;
      expect(status.scrollAxis, equals(Axis.horizontal));
    });
  });
}

DetectorStatus _validate() {
  var args = verify(
    () => S.get<SessionManager>().onEvent(
          event: any(named: 'event'),
          status: captureAny(named: 'status'),
        ),
  )..called(equals(1));
  return args.captured.first;
}
