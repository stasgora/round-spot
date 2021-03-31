import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../components/session_manager.dart';
import '../models/detector_config.dart';
import '../models/event.dart';
import '../utils/components.dart';

/// Detects user interactions in the [child] widget tree.
///
/// {@template Detector.description}
/// ## Scrollable widgets
/// To correctly monitor interactions with any scrollable space a [Detector]
/// has to be placed between the scrollable widget
/// and the widgets being scrolled.
///
/// Using a [Detector] with a single child:
/// ```dart
/// SingleChildScrollView(
///   child: round_spot.Detector(
///     child: /* child */,
///     areaID: id
///   )
/// )
/// ```
///
/// Using a [ListDetector] with a list of children:
/// ```dart
/// SingleChildScrollView(
///   child: round_spot.ListDetector(
///     children: [
///       // children
///     ],
///     areaID: id
///   )
/// )
/// ```
///
/// ## Detector scope
/// Detectors can either have a _local_ or a _global_ scope:
/// * The default _local_ scope should generally be used whenever a unique area
/// that only exist in one place on a single screen needs to be observed.
/// * The _global_ scope is great for monitoring interactions with
/// elements that appear in the same form on multiple pages.
///
/// As a result of a global scope events from all of the detectors grouped
/// by the same [areaID] will contribute to the same heat maps.
/// This is very useful in situations where a common interface element
/// (like a navigation bar or a menu) is being monitored.
/// Generating separate heat maps for each screen makes little sense
/// when trying to analyse all interactions with that element.
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
  /// It should be unique in its scope - see [hasGlobalScope].
  /// The empty ID is reserved as it's used by the root detector on every page.
  /// {@endtemplate}
  final String areaID;

  /// {@template Detector.hasGlobalScope}
  /// Determines the scope of this Detector's area:
  ///
  /// * **false** means the scope is local and limited
  /// to the enclosing [PageRoute]
  /// * **true** expands the scope beyond a single page.
  /// Every [Detector] with the same [areaID] on any page will become
  /// part of a group observing the same area. Keep in mind that
  /// each one of them needs to have the scope set to global.
  /// {@endtemplate}
  final bool hasGlobalScope;

  /// {@template Detector.constructor}
  /// Creates a widget detector
  ///
  /// The default scope is local.
  /// {@endtemplate}
  Detector({
    required this.child,
    required this.areaID,
    this.hasGlobalScope = false,
  });

  @override
  _DetectorState createState() => _DetectorState();
}

class _DetectorState extends State<Detector> {
  final GlobalKey _areaKey = GlobalKey();

  final _manager = S.get<SessionManager>();

  void _onTap(PointerDownEvent event) {
    _manager.onEvent(
      event: Event.fromPointer(event),
      detector: DetectorConfig(
        areaKey: _areaKey,
        areaID: widget.areaID,
        hasGlobalScope: widget.hasGlobalScope,
      ),
    );
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
/// {@macro Detector.description}
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

  /// {@macro Detector.hasGlobalScope}
  final bool hasGlobalScope;

  /// {@macro Detector.constructor}
  ListDetector({
    required this.children,
    required this.areaID,
    this.hasGlobalScope = false,
  });

  @override
  Widget build(BuildContext context) {
    return Detector(
      child: Column(children: children),
      areaID: areaID,
      hasGlobalScope: hasGlobalScope,
    );
  }
}
