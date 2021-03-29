import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../components/session_manager.dart';
import '../models/event.dart';
import '../utils/components.dart';

class Detector extends StatelessWidget {
	final GlobalKey areaKey = GlobalKey();
  final _manager = S.get<SessionManager>();

  final Widget? child;

  Detector({this.child});

  void _onTap(PointerDownEvent event) {
    _manager.onEvent(event: Event.fromPointer(event), areaKey: areaKey);
  }

  @override
  Widget build(BuildContext context) {
	  return RepaintBoundary(
		  key: areaKey,
		  child: Listener(
			  onPointerDown: _onTap,
			  behavior: HitTestBehavior.deferToChild,
			  child: child,
		  ),
	  );
  }
}
