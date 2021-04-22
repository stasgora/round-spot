import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;

import '../utils/utils.dart';
import 'event.dart';
import 'output_info.dart';

/// Holds information about user interactions with a particular
/// [area] on some [page] during some period of time.
class Session implements OutputInfo {
  final String? page;
  final String area;
  final int startTime;
  int endTime;

  final List<Event> _events = [];

  /// Events registered in this [Session]
  List<Event> get events => _events;

  /// Holds the screenshots captured during this session
  Image? screenshot;

  /// Keep track of the already captured parts of this session screen [area]
  final List<ImageStrip> screenshotStrips = [];

  /// Axis along which this session [area] scrolls, if any
  final Axis? axis;

  /// Determines this session output resolution
  final double pixelRatio;

  /// Creates a [Session] for a particular [area] on some [page]
  Session({
    this.page,
    required this.area,
    required this.pixelRatio,
    this.axis,
  })  : startTime = getTimestamp(),
        endTime = getTimestamp();

  /// Registers an [event] in this session
  void addEvent(Event event) {
    _events.add(event);
    endTime = max(endTime, event.timestamp);
  }

  /// Converts this [Session] to a json map
  Map<String, dynamic> toJson() => {
        'page': page,
        'area': area,
        'span': {'start': startTime, 'end': endTime},
        'events': [for (var event in _events) event.toJson()],
      };
}

/// Represents a captured part of sessions
/// screen [Session.area] along the [Session.axis]
class ImageStrip {
  /// Offset from the origin at which this strip starts
  final double offset;

  /// Length of this strip
  final double length;

  /// Offset from the origin at which this strip ends
  double get end => offset + length;

  /// Creates a [ImageStrip] from [offset] and [length]
  ImageStrip(this.offset, this.length);
}
