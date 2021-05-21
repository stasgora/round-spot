import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../components/session_manager.dart';
import '../models/detector_status.dart';
import '../models/event.dart';
import '../models/scrolling_status.dart';
import '../utils/components.dart';

/// Detects user interactions in the [child] widget tree.
///
/// ## Scrollable widgets
/// To correctly monitor interactions with scrollable space a [Detector]
/// has to be placed as a direct parent of that widget:
/// ```dart
/// round_spot.Detector(
///   areaID: id,
///   child: ListView(
///     children: /* children */,
///   ),
/// )
/// ```
///
/// Widgets provided by Flutter, like [ListView], [SingleChildScrollView],
/// [GridView] or [CustomScrollView] are recognised automatically.
/// In case you are using a custom scrollable widget from an external package,
/// and cannot put the [Detector] directly around one of the standard Flutter
/// widgets, use the [Detector.custom()] constructor.
///
/// ### Popups & Dialogs
/// To monitor interactions with a popup place a [Detector] around
/// the widget inside the builder (remember to also provide the route name):
/// ```dart
/// showDialog(
///   builder: (_) => round_spot.Detector(
///     areaID: 'sample-dialog',
///     child: SimpleDialog(title: Text('dialog')),
///   ),
///   routeSettings: RouteSettings(name: 'simple-dialog-route'),
///   context: context,
/// );
/// ```
///
/// ### Not supported / untested
/// * Nested scroll views
/// * Widgets changing their size
/// * Directly using slivers
///
/// ## Cumulative detectors
/// This option is designed to allow for capturing the overall usage
/// of elements that appear in the same form on multiple pages.
/// All cumulative detectors with the same [areaID] will be contributing
/// to common heat maps. This is useful for common interface elements
/// that are shared between pages, like a navigation bar or a menu.
/// The cumulative detectors are "fall-through", meaning the interactions
/// will be included here in addition to the default screen maps.
class Detector extends StatefulWidget {
  /// The widget below this widget to be observed.
  ///
  /// If you need to lay out multiple children in a column use [ListDetector].
  final Widget child;

  /// Consistently identifies the same visual region
  /// across widget tree rebuilds and multiple visits.
  ///
  /// It should be unique in its scope - see [cumulative].
  /// The empty ID is reserved as it's used by the root detector on every page.
  final String areaID;

  /// Determines the scope of interactions that will be included in the output.
  ///
  /// By default only the interactions from the enclosing [PageRoute] will
  /// be included. If this option is set to `true` every
  /// [Detector] with the same [areaID] across all pages
  /// will be contributing to common heat map outputs.
  /// Keep in mind that each one of them has to be set as cumulative.
  final bool cumulative;

  /// Specifies the scroll axis of the custom scrollable [child] widget.
  final Axis? customScrollAxis;

  /// Holds the initial scroll offset of the custom scrollable [child] widget.
  final double? customInitialOffset;

  late final bool _isScrollDetector;

  /// Creates a widget detector observing the [child] widget tree
  ///
  /// {@template Detector.constructor}
  /// A non empty, unique [areaID] has to be provided.
  /// By default the detector is not [cumulative].
  /// {@endtemplate}
  Detector({
    required Widget child,
    required String areaID,
    bool cumulative = false,
  }) : this._(
          child: child,
          areaID: areaID,
          cumulative: cumulative,
        );

  /// Creates a detector observing a custom scrollable [child] widget tree
  ///
  /// {@macro Detector.constructor}
  /// [scrollAxis] and [initialScrollOffset] have
  /// to be specified manually if they differ from the default values.
  Detector.custom({
    required Widget child,
    required String areaID,
    bool cumulative = false,
    Axis scrollAxis = Axis.vertical,
    double initialScrollOffset = 0,
  }) : this._(
          child: child,
          areaID: areaID,
          cumulative: cumulative,
          customScrollAxis: scrollAxis,
          customInitialOffset: initialScrollOffset,
        );

  Detector._({
    required this.child,
    required this.areaID,
    this.cumulative = false,
    this.customScrollAxis,
    this.customInitialOffset,
  }) {
    _isScrollDetector = customScrollAxis != null ||
        child is ScrollView ||
        child is SingleChildScrollView ||
        child is PageView ||
        child is ListWheelScrollView;
  }

  @override
  _DetectorState createState() => _DetectorState();
}

class _DetectorState extends State<Detector> {
  late final DetectorStatus _status;

  final _manager = S.get<SessionManager>();

  @override
  void initState() {
    super.initState();
    var offset = _getController()?.initialScrollOffset;
    _status = DetectorStatus(
      areaKey: GlobalKey(),
      areaID: widget.areaID,
      cumulative: widget.cumulative,
      scrollStatus: widget._isScrollDetector
          ? ScrollingStatus(
              _getScrollAxis() ?? widget.customScrollAxis ?? Axis.vertical,
              offset ?? widget.customInitialOffset ?? 0,
            )
          : null,
    );
  }

  void _onTap(PointerDownEvent event) {
    _manager.onEvent(
      event: Event.fromPointer(event, _status.scrollOffset),
      status: _status,
    );
  }

  bool _onNotification(ScrollNotification notification) {
    var metrics = notification.metrics;
    _status.scrollStatus!.position = metrics.pixels;
    var hasDimensions = metrics.hasContentDimensions;
    _status.scrollStatus!.extent = Offset(
      hasDimensions ? metrics.minScrollExtent : double.negativeInfinity,
      hasDimensions ? metrics.maxScrollExtent : double.infinity,
    );
    // Synchronizes rendered image with reported scroll offset
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _manager.onSessionScroll(_status);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Widget detector = Listener(
      onPointerDown: _onTap,
      behavior: HitTestBehavior.translucent,
      child: RepaintBoundary(
        key: _status.areaKey,
        child: widget.child,
      ),
    );
    if (widget._isScrollDetector) {
      detector = NotificationListener(
        onNotification: _onNotification,
        child: detector,
      );
    }
    return detector;
  }

  Axis? _getScrollAxis() {
    var child = widget.child;
    if (child is ScrollView) return child.scrollDirection;
    if (child is ListWheelScrollView) return Axis.vertical;
    if (child is SingleChildScrollView) return child.scrollDirection;
    if (child is PageView) return child.scrollDirection;
  }

  ScrollController? _getController() {
    var child = widget.child;
    if (child is ScrollView) return child.controller;
    if (child is ListWheelScrollView) return child.controller;
    if (child is SingleChildScrollView) return child.controller;
    if (child is PageView) return child.controller;
  }
}
