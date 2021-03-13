import 'dart:ui';

import 'package:flutter/material.dart';

class RoundSpotConfig {
	// Session
	int? maxSessionIdleTime;
	int minSessionEventCount;
	// Visuals
	Color renderingColor;

	RoundSpotConfig({this.maxSessionIdleTime, int? minSessionEventCount, Color? renderingColor}) :
				assert(minSessionEventCount == null || minSessionEventCount >= 1),
				assert(maxSessionIdleTime == null || maxSessionIdleTime >= 1),
				minSessionEventCount = minSessionEventCount ?? 1,
				renderingColor = renderingColor ?? Colors.orange[800]!;

	RoundSpotConfig.fromJson(Map<String, dynamic> json) : this(
			maxSessionIdleTime: json['maxSessionIdleTime'],
			minSessionEventCount: json['minSessionEventCount'],
			renderingColor: json['renderingColor'] ? Color(int.parse(json['renderingColor'], radix: 16)) : null
		);
}
