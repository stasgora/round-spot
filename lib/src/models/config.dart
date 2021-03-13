import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:round_spot/src/models/output_type.dart';

class RoundSpotConfig {
	// Session
	int? maxSessionIdleTime; // TODO Implement
	int minSessionEventCount;
	Set<RoundSpotOutputType> outputTypes;
	// Visuals
	Color renderingColor;

	RoundSpotConfig({this.maxSessionIdleTime, int? minSessionEventCount, Set<RoundSpotOutputType>? outputTypes, Color? renderingColor}) :
				assert(minSessionEventCount == null || minSessionEventCount >= 1),
				assert(maxSessionIdleTime == null || maxSessionIdleTime >= 1),
				minSessionEventCount = minSessionEventCount ?? 1,
				outputTypes = outputTypes ?? {RoundSpotOutputType.GRAPHICAL_RENDER},
				renderingColor = renderingColor ?? Colors.orange[800]!;

	RoundSpotConfig.fromJson(Map<String, dynamic> json) : this(
			maxSessionIdleTime: json['maxSessionIdleTime'],
			minSessionEventCount: json['minSessionEventCount'],
			outputTypes: json['outputTypes'] ? (json['outputTypes'] as List<int>).map((type) => RoundSpotOutputType.values[type]).toSet() : null,
			renderingColor: json['renderingColor'] ? Color(int.parse(json['renderingColor'], radix: 16)) : null
		);
}
