import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

/// Converts an [Image] into a list of png file bytes.
Future<Uint8List> exportHeatMap(Image image) async {
  var byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

/// Serializes a json map into a formatted string.
Future exportNumericData(Map<String, dynamic> data) async =>
    JsonEncoder.withIndent('\t').convert(data);

/// Provides a current timestamp in milliseconds.
int getTimestamp() => DateTime.now().millisecondsSinceEpoch;
