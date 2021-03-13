import 'package:flutter/widgets.dart';

import 'models/config.dart';
import 'components/screenshot_provider.dart';
import 'utils/components.dart';
import 'detector_widget.dart';

class RoundSpot {
	static Widget initialize({Widget? child, RoundSpotConfig? config}) {
		initializeComponents(config);
		return RoundSpotDetector(child: child, screenKey: S.get<ScreenshotProvider>().key);
	}
}
