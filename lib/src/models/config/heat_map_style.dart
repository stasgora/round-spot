/// Available heat map styles.
enum HeatMapStyle {
  /// The default smoothed out look.
  smooth,

  /// Alternative layered style.
  layered
}

extension HeatMapLayerMultiplier on HeatMapStyle {
  int get multiplier {
    return const {
      HeatMapStyle.smooth: 3,
      HeatMapStyle.layered: 2,
    }[this]!;
  }
}
