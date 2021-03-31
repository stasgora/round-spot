import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../components/session_manager.dart';
import '../models/event.dart';
import '../utils/components.dart';

class Detector extends StatelessWidget {
  final GlobalKey areaKey = GlobalKey();
  final _manager = S.get<SessionManager>();

  final Widget? child;
  final String? areaID;

  Detector({this.child, this.areaID});

  void _onTap(PointerDownEvent event) {
    _manager.onEvent(
        event: Event.fromPointer(event), areaKey: areaKey, areaID: areaID);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: areaKey,
        child: Listener(
          onPointerDown: _onTap,
          behavior: HitTestBehavior.translucent,
          child: child,
        ));
  }
}
