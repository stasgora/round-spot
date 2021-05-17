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
