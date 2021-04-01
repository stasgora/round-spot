import '../../entry_point.dart';

/// Available output data types.
enum OutputType {
  /// The default heat map output, corresponds to the [HeatMapCallback].
  graphicalRender,

  /// Raw data output, corresponds to the [RawDataCallback].
  rawData,
}
