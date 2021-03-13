import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'utils/components.dart';
import 'services/session_manager.dart';

class RoundSpotDetector extends StatelessWidget {
	final _manager = S.get<SessionManager>();

	final Widget? child;
	final GlobalKey? screenKey;

	RoundSpotDetector({this.child, this.screenKey});

	void _onTap(PointerDownEvent details) => _manager.registerEvent(details.position);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
	    key: screenKey,
	    child: Listener(
		    child: child,
		    onPointerDown: _onTap,
		    behavior: HitTestBehavior.translucent
	    ),
    );
  }
}
