# 0.5.0

- **NEW**: refreshed data output implementation that uses a binary Protobuf serialized format
- **BREAKING**: output types and callbacks have been renamed:
  - `graphicalRender` ➡️ `localRender`
  - `rawData` ➡️ `data` (data callback no longer provides the `OutputInfo` parameter)
- **BREAKING**: only one output type can now be chosen (`Config.outputTypes` ➡️ `Config.outputType`)

# 0.4.0

- **NEW**: support for **popups** 💬
  - **FIX**: popup interactions included in outputs from below them
- **BREAKING**: `Detector.hasGlobalScope` renamed to `Detector.cumulative`
- **NEW**: background screenshot taking improvements:
  - **FIX**: background could be captured before the route transition animation has ended
  - Improved screenshot taking policy in regard to the screen loading period

# 0.3.3

- **FIX**: interactions not cleared when heat map is generated

# 0.3.2

- **FIX**: scroll state loss when switching routes
- **FIX**: incorrect scrollable heat map scaling when using custom `Config.heatMapPixelRatio`

# 0.3.1

- **FIX**: `PageView` config not correctly detected by the `Detector`

# 0.3.0

- **BREAKING**: reworked `Detector` implementation - should be placed around the scrollable widgets
  - **NEW**: support for lazy loaded scrollable widgets like `ListView.builder()`
  - **FIX**: events misreported during scrolling
  - **NEW**: support for custom scrollable widgets - using `Detector.custom()` constructor
  - **NEW**: scrollable heat maps smart cropping - saving on image size
  - **REFACTOR**: removed `ListDetector` - not needed anymore
- **FIX**: rendering bug when `Config.heatMapPixelRatio` was changed during session recording

# 0.2.0

- **NEW**: Adjustable heat map resolution
- **BREAKING**: Unified output callbacks signatures

# 0.1.1

- Example application
- **DOCS**: Private API documentation

# 0.1.0

Initial release

- Heat map creation
- Raw data exporting
- Scrolling spaces support
