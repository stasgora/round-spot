import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

Future<Uint8List> exportHeatMap(Image image) async {
  var byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

Future exportNumericData(Map<String, dynamic> data) async =>
    JsonEncoder.withIndent('\t').convert(data);

int getTimestamp() => DateTime.now().millisecondsSinceEpoch;
