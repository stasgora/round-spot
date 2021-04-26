# <div align="center"><img src="https://raw.githubusercontent.com/stasgora/round-spot/master/assets/logo.png" alt="icon" width="100"><br> Round Spot</div>

<div align="center">
  Customizable heat map interface analysis library
  
  
  <a href="https://pub.dev/packages/round_spot"><img src="https://img.shields.io/pub/v/round_spot.svg?color=blueviolet" alt="Pub"></a>
  <a href="https://github.com/stasgora/round-spot/actions"><img src="https://github.com/stasgora/round-spot/workflows/build/badge.svg" alt="build"></a>
  <a href="https://github.com/tenhobi/effective_dart"><img src="https://img.shields.io/badge/style-effective_dart-40c4ff.svg" alt="style: effective dart"></a>
  <a href="https://github.com/stasgora/round-spot/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>

**Round Spot** simplifies the UI accessibility and behaviour analysis for Flutter applications by handling the data gathering and processing.
It produces beautiful heat map visualizations that aim to make the UI improvement and troubleshooting easy and intuitive.
</div>

## Examples

<div align="center">

| <img src="https://raw.githubusercontent.com/stasgora/round-spot/master/assets/screens/calendar.png" width=200 /> | <img src="https://raw.githubusercontent.com/stasgora/round-spot/master/assets/screens/form.png" width=200 /> | <img src="https://raw.githubusercontent.com/stasgora/round-spot/master/assets/screens/panel.png" width=200 /> | <img src="https://raw.githubusercontent.com/stasgora/round-spot/master/assets/screens/rating.png" width=200 /> |
| :--------------------: | :--------------------: | :--------------------------: | :-------------------: |
|        Calendar        |         Form           |            Panel             |         Cards         |

(Screens taken from the **[Fokus](https://github.com/fokus-team/fokus)** application)
</div>

## Usage
Import the package in your main file:
```dart
import 'package:round_spot/round_spot.dart' as round_spot;
```
> **⚠️ Note:** Using a `round_spot` prefix is highly recommended to avoid potential name collisions and improve readability

### Setup
Wrap your `MaterialApp` widget to initialize the library:
```dart
void main() {
  runApp(round_spot.initialize(
    child: Application()
  ));
}
```
Add an observer for monitoring the navigator:
```dart
MaterialApp(
  navigatorObservers: [ round_spot.Observer() ]
)
```

### Configuration
Provide the callbacks for saving the processed output:
```dart
round_spot.initialize(
  heatMapCallback: (data, info) => sendHeatMapImage(data)
)
```
Configure the tool to better fit your needs:
```dart
round_spot.initialize(
  config: round_spot.Config(
    minSessionEventCount: 30,
    outputTypes: { round_spot.OutputType.graphicalRender },
    heatMapStyle: round_spot.HeatMapStyle.smooth
  )
)
```
### UI Instrumentation

#### Route naming
Route names are used to differentiate between pages.
Make sure you are consistently specifying them both when 
using [named routes](https://flutter.dev/docs/cookbook/navigation/named-routes) and
pushing [PageRoutes](https://api.flutter.dev/flutter/widgets/PageRoute-class.html)
(inside [RouteSetting](https://api.flutter.dev/flutter/widgets/RouteSettings-class.html))

#### Scrollable widgets
To correctly monitor interactions with any scrollable space a `Detector` 
has to be placed as a direct parent of that widget:
```dart
round_spot.Detector(
  areaID: id,
  child: ListView(
    children: /* children */,
  ),
)
```

## Contributors
Created by [Stanisław Góra](https://github.com/stasgora/)

## License
This tool is licenced under [`MIT License`](https://github.com/stasgora/round-spot/blob/master/LICENSE)
