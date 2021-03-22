enum HeatMapStyle { smooth, layered }

extension HeatMapLayerMultiplier on HeatMapStyle {
  int get multiplier =>
      const {HeatMapStyle.smooth: 3, HeatMapStyle.layered: 2}[this]!;
}
