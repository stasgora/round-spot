/// Available heat map styles.
enum HeatMapStyle {
  /// The default smoothed out look.
  smooth,

  /// Alternative layered style.
  layered
}

/// An extensions specifying the [multiplier]
extension HeatMapLayerMultiplier on HeatMapStyle {
  /// A layer number multiplier used by the [GraphicalProcessor]
  int get multiplier {
    return const {
      HeatMapStyle.smooth: 3,
      HeatMapStyle.layered: 2,
    }[this]!;
  }
}
