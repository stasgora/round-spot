import 'heat_map_style.dart';
import 'output_type.dart';

/// Holds the configuration relating to the
/// specifics of data gathering and processing.
class Config {
  bool enabled;
  double uiElementSize; // 5 - 20

  // Session
  Set<String>? disabledRoutes;
  int? maxSessionIdleTime;
  int minSessionEventCount;
  Set<OutputType> outputTypes;

  // Visuals
  /// Determines the style of the generated heat maps.
  HeatMapStyle heatMapStyle;
  int heatMapTransparency;

  Config({
    bool? enabled,
    double? uiElementSize,
    this.disabledRoutes,
    this.maxSessionIdleTime,
    int? minSessionEventCount,
    Set<OutputType>? outputTypes,
    HeatMapStyle? heatMapStyle,
    int? heatMapTransparency,
  })  : assert(minSessionEventCount == null || minSessionEventCount >= 1),
        assert(maxSessionIdleTime == null || maxSessionIdleTime >= 1),
        assert(heatMapTransparency == null ||
            heatMapTransparency >= 0 && heatMapTransparency <= 255),
        enabled = enabled ?? true,
        uiElementSize = uiElementSize ?? 10,
        minSessionEventCount = minSessionEventCount ?? 1,
        outputTypes = outputTypes ?? {OutputType.graphicalRender},
        heatMapStyle = heatMapStyle ?? HeatMapStyle.smooth,
        heatMapTransparency = (heatMapTransparency ?? 230) % 256;

  Config.fromJson(Map<String, dynamic> json)
      : this(
          enabled: json['enabled'],
          uiElementSize: json['uiElementSize'],
          disabledRoutes: json['disabledRoutes']
              ? (json['disabledRoutes'] as List<String>).toSet()
              : null,
          maxSessionIdleTime: json['maxSessionIdleTime'],
          minSessionEventCount: json['minSessionEventCount'],
          outputTypes: json['outputTypes']
              ? (json['outputTypes'] as List<int>)
                  .map((type) => OutputType.values[type])
                  .toSet()
              : null,
          heatMapStyle: json['heatMap']?['style'] != null
              ? HeatMapStyle.values[json['outputTypes']]
              : null,
          heatMapTransparency: json['heatMap']?['transparency'],
        );
}
