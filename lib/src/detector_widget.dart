import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'components/session_manager.dart';
import 'utils/components.dart';

class RoundSpotDetector extends StatelessWidget {
  final _manager = S.get<SessionManager>();

  final Widget? child;
  final GlobalKey? screenKey;

  RoundSpotDetector({this.child, this.screenKey});

  void _onTap(PointerDownEvent details) => _manager.onEvent(details.position);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: screenKey,
      child: Listener(
        onPointerDown: _onTap,
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}
