import 'package:flutter/widgets.dart';

import 'services/screenshot_provider.dart';
import 'utils/services.dart';
import 'detector_widget.dart';

class RoundSpot {
	static Widget initialize({Widget? child}) {
		initializeServices();
		return RoundSpotDetector(child: child, screenKey: S.get<ScreenshotProvider>().key);
	}
}
