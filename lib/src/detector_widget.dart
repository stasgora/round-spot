import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'components/session_manager.dart';
import 'utils/components.dart';

class Detector extends StatefulWidget {
  final Widget? child;
  final GlobalKey? screenKey;

  Detector({this.child, this.screenKey});

  @override
  _DetectorState createState() => _DetectorState();
}

// ignore: prefer_mixin
class _DetectorState extends State<Detector> with WidgetsBindingObserver {
  final _manager = S.get<SessionManager>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      _manager.onLifecycleStateChanged(state);

  void _onTap(PointerDownEvent details) => _manager.onEvent(details.position);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.screenKey,
      child: Listener(
        onPointerDown: _onTap,
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}
