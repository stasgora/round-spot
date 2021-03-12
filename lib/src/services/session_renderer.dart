import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/image_utils.dart';
import 'package:round_spot/src/utils/services.dart';

import 'screenshot_provider.dart';

class SessionRenderer {
	Future render(Session session) async {
		var image = await S.get<ScreenshotProvider>().takeScreenshot();
		if (image == null)
			return;
		final pictureRecorder = PictureRecorder();
		final canvas = Canvas(pictureRecorder);
		canvas.drawImage(image, Offset.zero, Paint());
		canvas.drawPoints(PointMode.points, session.events.map((event) => event.location).toList(), Paint()..color = Colors.black..strokeWidth = 5);
		var sessionImage = await pictureRecorder.endRecording().toImage(image.width, image.height);
		saveDebugImage(sessionImage);
	}
}
