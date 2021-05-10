/// Available output data types.
enum OutputType {
  /// The default heat map output, corresponds to the `heatMapCallback`.
  graphicalRender,

  /// Raw json data output, corresponds to the `rawDataCallback`:
  ///
  /// * **page** `string` - A page where the data was captured
  /// * **area** `string` - The visual region
  /// identifier provided to the Detector
  /// * **span** `object` - Time period in which this session was recorded:
  ///   * **start** `integer` - Timestamp of the
  /// first event included in the heat map (in ms)
  ///   * **end** `integer` - Timestamp of the
  /// last event included in the heat map (in ms)
  /// * **events** `array` - List of events captured during this session:
  ///   * **event** `object` - Information about a single user interaction:
  ///     * **location** `object` - Area relative touch screen coordinates:
  ///       * **x** `double` - X axis component
  ///       * **y** `double` - Y axis component
  ///     * **time** `integer` - Timestamp
  ///     of when this event was recorded (in ms)
  rawData,
}
