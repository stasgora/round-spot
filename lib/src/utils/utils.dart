import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart' show Axis;

/// [Offset] axis utility extension
extension Offsets on Offset {
  /// Constructs [Offset] from an [offset] along [axis]
  static Offset fromAxis(Axis axis, double offset, [double other = 0]) =>
      axis == Axis.vertical ? Offset(other, offset) : Offset(offset, other);
}

/// [Size] utility extension
extension Sizes on Size {
  /// Returns [max] (OR) of the two [Size] objects
  Size operator |(Size other) => Size(
        max(width, other.width),
        max(height, other.height),
      );
}

/// Converts an [Image] into a list of png file bytes.
Future<Uint8List> exportHeatMap(Image image) async {
  var byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

/// Serializes a json map into a formatted string.
Future<Uint8List> exportNumericData(Map<String, dynamic> data) async =>
    utf8.encoder.convert(JsonEncoder.withIndent('\t').convert(data));

/// Provides a current timestamp in milliseconds.
int getTimestamp() => DateTime.now().millisecondsSinceEpoch;

/// Filters only the non null values from a list.
List<T> filterNotNull<T>(List<T?> list) {
  var filtered = <T>[];
  for (var e in list) {
    if (e != null) filtered.add(e);
  }
  return filtered;
}
