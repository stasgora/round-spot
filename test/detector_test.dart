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
  setUpAll(() {
    S.registerSingleton<SessionManager>(MockSessionManager());
    registerFallbackValue<Event>(Event());
    registerFallbackValue<DetectorStatus>(DetectorStatus(areaKey: GlobalKey()));
  });

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
      expect(status.scrollStatus, isNotNull);
    });
    testWidgets('tracks scrolling', (tester) async {
      var amount = 10.0;
      await tester.pumpWidget(
        Detector(
          areaID: '',
          child: SingleChildScrollView(
            child: const SizedBox(width: 1000.0, height: 1000.0),
          ),
        ),
      );
      await tester.drag(find.byType(SingleChildScrollView), Offset(0, -amount));
      var status = _validate();
      expect(status.scrollStatus!.position, equals(amount));
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
      var status = _validate();
      expect(status.scrollStatus!.axis, equals(Axis.horizontal));
    });
    testWidgets('handles initial scroll offset', (tester) async {
      var scrollAmount = 10.0;
      await tester.pumpWidget(
        Detector(
          areaID: '',
          child: SingleChildScrollView(
            controller: ScrollController(initialScrollOffset: scrollAmount),
          ),
        ),
      );
      await tester.press(find.byType(SingleChildScrollView));
      var status = _validate();
      expect(status.scrollStatus!.position, equals(scrollAmount));
    });
  });
}

DetectorStatus _validate() {
  var args = verify(
    () => S.get<SessionManager>().onEvent(
          event: any(named: 'event'),
          status: captureAny(named: 'status'),
        ),
  )..called(1);
  return args.captured.first;
}
