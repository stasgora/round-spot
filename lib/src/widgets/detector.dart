import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../components/session_manager.dart';
import '../models/event.dart';
import '../utils/components.dart';

/// Detects user interactions in the [child] widget tree.
///
/// {@template Detector.scrollable}
/// It has to be inserted into a scrollable space
/// to correctly monitor its content.
/// {@endtemplate}
class Detector extends StatefulWidget {
  /// The widget below this widget to be observed.
  ///
  /// If you need to lay out multiple children in a column use [ListDetector].
  final Widget child;

  /// {@template Detector.areaID}
  /// Consistently identifies the same visual region
  /// across widget tree rebuilds and multiple visits.
  ///
  /// It must be unique on the [PageRoute] where its used.
  /// The empty ID is reserved as it's used by the root detector on every page.
  /// {@endtemplate}
  final String areaID;

  /// Creates a widget detector
  Detector({required this.child, required this.areaID});

  @override
  _DetectorState createState() => _DetectorState();
}

class _DetectorState extends State<Detector> {
  final GlobalKey _areaKey = GlobalKey();

  final _manager = S.get<SessionManager>();

  void _onTap(PointerDownEvent event) {
    _manager.onEvent(
        event: Event.fromPointer(event),
        areaKey: _areaKey,
        areaID: widget.areaID);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _areaKey,
      child: Listener(
        onPointerDown: _onTap,
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}

/// Detects user interactions in [children] widgets.
///
/// {@macro Detector.scrollable}
///
/// _This is a proxy for a [Detector] widget
/// that places its children in a [Column]_
class ListDetector extends StatelessWidget {
  /// The widgets below this widget to be observed.
  ///
  /// If you only have a single child use [Detector].
  final List<Widget> children;

  /// {@macro Detector.areaID}
  final String areaID;

  /// Creates a widget list detector
  ListDetector({required this.children, required this.areaID});

  @override
  Widget build(BuildContext context) {
    return Detector(
      child: Column(children: children),
      areaID: areaID,
    );
  }
}
