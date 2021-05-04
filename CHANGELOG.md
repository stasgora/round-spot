# 0.3.1

- **FIX**: `PageView` config was not correctly detected by the `Detector`

# 0.3.0

- **BREAKING**: reworked `Detector` implementation - should be placed around the scrolling widgets
  - **NEW**: support for lazy loaded scroll widgets like `ListView.builder()`
  - **FIX**: events misreported during scrolling
  - **NEW**: support for custom scroll widgets - using `Detector.custom()` constructor
  - **NEW**: scrolling heat maps smart cropping - saves on image size
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
