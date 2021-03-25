import 'heat_map_style.dart';
import 'output_type.dart';
import 'sync_frequency.dart';

class RoundSpotConfig {
  bool enabled;
  double uiElementSize; // 5 - 20

  // Session
  Set<String>? disabledRoutes;
  int? maxSessionIdleTime; // TODO Implement
  int minSessionEventCount;
  Set<OutputType> outputTypes;
  SyncFrequency syncFrequency; // TODO Implement
  // Visuals
  HeatMapStyle heatMapStyle;
  int heatMapTransparency;

  RoundSpotConfig(
      {bool? enabled,
      double? uiElementSize,
      this.disabledRoutes,
      this.maxSessionIdleTime,
      int? minSessionEventCount,
      Set<OutputType>? outputTypes,
      SyncFrequency? syncFrequency,
      HeatMapStyle? heatMapStyle,
      int? heatMapTransparency})
      : assert(minSessionEventCount == null || minSessionEventCount >= 1),
        assert(maxSessionIdleTime == null || maxSessionIdleTime >= 1),
        assert(heatMapTransparency == null ||
            heatMapTransparency >= 0 && heatMapTransparency <= 255),
        enabled = enabled ?? true,
        uiElementSize = uiElementSize ?? 10,
        minSessionEventCount = minSessionEventCount ?? 1,
        outputTypes = outputTypes ?? {OutputType.graphicalRender},
        syncFrequency = syncFrequency ?? SyncFrequency(),
        heatMapStyle = heatMapStyle ?? HeatMapStyle.smooth,
        heatMapTransparency = (heatMapTransparency ?? 230) % 256;

  RoundSpotConfig.fromJson(Map<String, dynamic> json)
      : this(
            enabled: json['enabled'],
					  uiElementSize: json['uiElementSize'],
		        disabledRoutes: json['disabledRoutes']
				        ? (json['disabledRoutes'] as List<String>).toSet() : null,
            maxSessionIdleTime: json['maxSessionIdleTime'],
            minSessionEventCount: json['minSessionEventCount'],
            outputTypes: json['outputTypes']
                ? (json['outputTypes'] as List<int>)
                    .map((type) => OutputType.values[type])
                    .toSet()
                : null,
            syncFrequency: SyncFrequency.fromJson(json['syncFrequency']),
            heatMapStyle: json['heatMap']?['style'] != null
                ? HeatMapStyle.values[json['outputTypes']]
                : null,
            heatMapTransparency: json['heatMap']?['transparency']);
}
