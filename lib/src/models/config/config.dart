import 'package:enum_to_string/enum_to_string.dart';

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
  /// The default value is 12.
  double uiElementSize;

  /// Holds the route names on which event collection is disabled.
  ///
  /// This does not apply to areas marked as global
  /// through [Detector.hasGlobalScope] flag.
  Set<String> disabledRoutes;

  /// Specifies what output data forms should be generated.
  ///
  /// This corresponds to the `heatMapCallback` and
  /// `rawDataCallback` passed during [initialize()].
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

  /// Determines the heat map image resolution.
  ///
  /// This parameter describes the scale between the
  /// logical pixels and the size of the output image.
  /// By default it is equal to one which means the image resolution
  /// will be equal to the logical device resolution.
  ///
  /// As an example in order to generate heat maps in the screen resolution
  /// you should pass the [FlutterView.devicePixelRatio] here.
  double heatMapPixelRatio;

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
    double? heatMapPixelRatio,
  })  : assert(minSessionEventCount == null || minSessionEventCount >= 1),
        assert(maxSessionIdleTime == null || maxSessionIdleTime >= 1),
        assert(heatMapTransparency == null ||
            heatMapTransparency >= 0 && heatMapTransparency <= 255),
        enabled = enabled ?? true,
        uiElementSize = uiElementSize ?? 12,
        disabledRoutes = disabledRoutes ?? {},
        minSessionEventCount = minSessionEventCount ?? 1,
        outputTypes = outputTypes ?? {OutputType.graphicalRender},
        heatMapStyle = heatMapStyle ?? HeatMapStyle.smooth,
        heatMapTransparency =
            (heatMapTransparency ?? 0.75).clamp(0, 1).toDouble(),
        heatMapPixelRatio = heatMapPixelRatio ?? 1;

  /// Creates the configuration from a json map.
  ///
  /// Allows for easy parsing when fetching the config from a remote location.
  ///
  /// ### References
  /// * [Example config file](https://github.com/stasgora/round-spot/blob/master/assets/example-config.json)
  /// * [Schema for config validation](https://github.com/stasgora/round-spot/blob/master/assets/config-schema.json)
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
          heatMapPixelRatio: json['heatMap']?['pixelRatio'].toDouble(),
        );
}
