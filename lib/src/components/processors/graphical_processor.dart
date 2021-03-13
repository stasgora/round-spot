import 'dart:ui';

import 'package:round_spot/src/components/screenshot_provider.dart';
import 'package:round_spot/src/models/session.dart';
import 'package:round_spot/src/utils/file_utils.dart';
import 'package:round_spot/src/utils/components.dart';

import 'session_processor.dart';

class GraphicalProcessor extends SessionProcessor {
	final _screenshotProvider = S.get<ScreenshotProvider>();

	@override
	Future process(Session session) async {
		var image = await _screenshotProvider.takeScreenshot();
		if (image == null)
			return;
		final pictureRecorder = PictureRecorder();
		final canvas = Canvas(pictureRecorder);
		canvas.drawImage(image, Offset.zero, Paint());
		canvas.drawPoints(
			PointMode.points,
			session.events.map((event) => event.location).toList(),
			Paint()..color = config.renderingColor..strokeWidth = 5
		);
		var sessionImage = await pictureRecorder.endRecording().toImage(image.width, image.height);
		saveDebugImage(sessionImage);
	}
}
