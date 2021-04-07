import 'package:enum_to_string/enum_to_string.dart';

import '../../entry_point.dart';
import '../../utils/utils.dart';
import '../../widgets/detector.dart';
import 'heat_map_style.dart';
import 'output_type.dart';

/// Holds the configuration relating to the
/// specifics of data gathering and processing.
///
/// All properties can be changed at any moment.
class Config {
  /// Specifies whether the library is currently active and collecting data.
  ///
  /// Set to `true` by default;
  bool enabled;

  /// Allows to adjust for the general UI size.
  ///
  /// This parameter controls the range inside which input event
  /// are clustered together as well as the size of rendered heat map elements.
  ///
  /// Permitted values range from above 0 for large screens and very small
  /// UI elements to around 30 for tiny screens with few large elements.
  /// Suggested range for mobile phones is between 5 and 20.
  /// The default value is 10.
  double uiElementSize;

  /// Holds the route names on which event collection is disabled.
  ///
  /// This does not apply to areas marked as global
  /// through [Detector.hasGlobalScope] flag.
  Set<String> disabledRoutes;

  /// Specifies what output data forms should be generated.
  ///
  /// This corresponds to the [HeatMapCallback] and [RawDataCallback]
  /// callbacks passed during [initialize()].
  ///
  /// The default value contains [OutputType.graphicalRender].
  Set<OutputType> outputTypes;

  // Session

  /// Sets the time in seconds after which all current sessions will be closed.
  ///
  /// The default `null` value means there is no maximum time.
  int? maxSessionIdleTime;

  /// Sets the minimum event count for a session to be closed.
  ///
  /// It's set to 1 by default which is the minimum supported value.
  int minSessionEventCount;

  // Visuals

  /// Determines the style of the generated heat maps.
  ///
  /// The default value is [HeatMapStyle.smooth].
  HeatMapStyle heatMapStyle;

  /// Sets the transparency of the heat map overlay.
  ///
  /// Takes values between 0 and 1, it's set to 0.75 by default.
  double heatMapTransparency;

  /// Initializes the configuration.
  Config({
    bool? enabled,
    double? uiElementSize,
    Set<String>? disabledRoutes,
    this.maxSessionIdleTime,
    int? minSessionEventCount,
    Set<OutputType>? outputTypes,
    HeatMapStyle? heatMapStyle,
    double? heatMapTransparency,
  })  : assert(minSessionEventCount == null || minSessionEventCount >= 1),
        assert(maxSessionIdleTime == null || maxSessionIdleTime >= 1),
        assert(heatMapTransparency == null ||
            heatMapTransparency >= 0 && heatMapTransparency <= 255),
        enabled = enabled ?? true,
        uiElementSize = uiElementSize ?? 10,
        disabledRoutes = disabledRoutes ?? {},
        minSessionEventCount = minSessionEventCount ?? 1,
        outputTypes = outputTypes ?? {OutputType.graphicalRender},
        heatMapStyle = heatMapStyle ?? HeatMapStyle.smooth,
        heatMapTransparency =
            (heatMapTransparency ?? 0.75).clamp(0, 1).toDouble();

  /// Creates the configuration from a json map.
  ///
  /// Allows for easy parsing when fetching the config from a remote location.
  Config.fromJson(Map<String, dynamic> json)
      : this(
          enabled: json['enabled'],
          uiElementSize: json['uiElementSize'].toDouble(),
          disabledRoutes: json['disabledRoutes'] != null
              ? (json['disabledRoutes'] as List<String>).toSet()
              : null,
          maxSessionIdleTime: json['session']?['maxIdleTime'],
          minSessionEventCount: json['session']?['minEventCount'],
          outputTypes: json['outputTypes'] != null
              ? filterNotNull(EnumToString.fromList(
                      OutputType.values, json['outputTypes']))
                  .toSet()
              : null,
          heatMapStyle: json['heatMap']?['style'] != null
              ? EnumToString.fromString(
                  HeatMapStyle.values, json['heatMap']?['style'])
              : null,
          heatMapTransparency: json['heatMap']?['transparency'].toDouble(),
        );
}
