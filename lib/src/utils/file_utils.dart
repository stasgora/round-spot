import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';

Future saveDebugImage(Image image) async {
  final path = await _getLocalPath;
  var file = File('$path/${DateTime.now()}.png');
  var byteData = await image.toByteData(format: ImageByteFormat.png);
  return file.writeAsBytes(byteData!.buffer.asUint8List());
}

Future saveDebugData(Map<String, dynamic> data) async {
  final path = await _getLocalPath;
  var file = File('$path/${DateTime.now()}.json');
  return file.writeAsString(JsonEncoder.withIndent('\t').convert(data));
}

Future<String> get _getLocalPath async {
  return (await getApplicationDocumentsDirectory()).path;
}
