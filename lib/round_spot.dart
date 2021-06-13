/// Customizable heat map interface analysis library
///
/// ## Usage
///
/// ### Setup
/// Wrap your [MaterialApp] widget to [initialize()] the library:
/// ```dart
/// void main() {
///   runApp(round_spot.initialize(
///     child: Application()
///   ));
/// }
/// ```
/// Add an [Observer] for monitoring the navigator:
/// ```dart
/// MaterialApp(
///   navigatorObservers: [ round_spot.Observer() ]
/// )
/// ```
///
/// ### Configuration
/// Provide the callbacks for saving the processed output:
/// ```dart
/// round_spot.initialize(
///   localRenderCallback: (data, info) => sendHeatMapImage(data)
/// )
/// ```
/// Use [Config] to make the tool better fit your needs:
/// ```dart
/// round_spot.initialize(
///   config: round_spot.Config(
///     minSessionEventCount: 5,
///     uiElementSize: 15,
///     heatMapPixelRatio: 2.0,
///   ),
///   loggingLevel: round_spot.LogLevel.warning // recommended for integration testing
/// )
/// ```
///
/// ## Important aspects
///
/// ### Route naming
/// Route names are used to differentiate between pages.
/// Read about their usage in relation to this library at [Observer] page.
///
/// ### Scrollable widgets
/// Scrollable spaces need manual instrumentation to be correctly monitored.
/// Read about the use of a [Detector] widget to learn more.
///
/// ### Current limitations
/// Widgets that dynamically change their size, position, dis/appear
/// or otherwise cause other widgets to shift their positions relative to
/// the viewport (for example in response to a user action) are not supported.
///
/// When that happens during a session recording it will cause
/// some of the gathered interactions to be displaced in relation
/// to the background image and the rest of data making
/// the heat map difficult to interpret and understand.
///
/// ## Commonly used terms
///
/// ### Area
/// A visual space taken by a particular widget and its children.
/// Can be portion or the whole screen.
///
/// ### Session
/// A collection of user interactions recorded in
/// a particular area during some period of time.
/// It is a base for a single heat map output.
///
/// All current sessions are ended when user puts the application
/// into background, as defined by the [AppLifecycleState.paused] state.
/// You can additionally control it by setting the [Config.maxSessionIdleTime].
library round_spot;

export 'src/entry_point.dart';
export 'src/models/config/config.dart';
export 'src/models/config/heat_map_style.dart' hide HeatMapLayerMultiplier;
export 'src/models/config/output_type.dart';
export 'src/models/log_level.dart' hide LogLevelLoggingMap;
export 'src/models/output_info.dart';
export 'src/navigator_observer.dart';
export 'src/widgets/detector.dart';
