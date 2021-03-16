import 'dart:ui';

import 'package:flutter/material.dart';
import 'output_type.dart';
import 'sync_frequency.dart';

class RoundSpotConfig {
  bool enabled;

  // Session
  int? maxSessionIdleTime; // TODO Implement
  int minSessionEventCount;
  Set<OutputType> outputTypes;
  SyncFrequency syncFrequency; // TODO Implement
  // Visuals
  Color renderingColor;

  RoundSpotConfig(
      {bool? enabled,
      this.maxSessionIdleTime,
      int? minSessionEventCount,
      Set<OutputType>? outputTypes,
      SyncFrequency? syncFrequency,
      Color? renderingColor}) :
        assert(minSessionEventCount == null || minSessionEventCount >= 1),
        assert(maxSessionIdleTime == null || maxSessionIdleTime >= 1),
        enabled = enabled ?? true,
        minSessionEventCount = minSessionEventCount ?? 1,
        outputTypes = outputTypes ?? {OutputType.graphicalRender},
        syncFrequency = syncFrequency ?? SyncFrequency(),
        renderingColor = renderingColor ?? Colors.orange[800]!;

  RoundSpotConfig.fromJson(Map<String, dynamic> json) : this(
      enabled: json['enabled'],
      maxSessionIdleTime: json['maxSessionIdleTime'],
      minSessionEventCount: json['minSessionEventCount'],
      outputTypes: json['outputTypes'] ? (json['outputTypes'] as List<int>)
	        .map((type) => OutputType.values[type]).toSet() : null,
      syncFrequency: SyncFrequency.fromJson(json['syncFrequency']),
      renderingColor: json['renderingColor'] ?
          Color(int.parse(json['renderingColor'], radix: 16)) : null
  );
}
