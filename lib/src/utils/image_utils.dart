import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';

Future saveDebugImage(Image image) async {
	final path = await _getLocalPath;
	var file = File('$path/${DateTime.now()}.png');
	ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
	return file.writeAsBytes(byteData!.buffer.asUint8List());
}

Future<String> get _getLocalPath async => (await getApplicationDocumentsDirectory()).path;