## Instructions

### Running the example
- run `flutter create example_app`
- add the latest versions of those packages as dependencies in `pubspec.yaml`:
  - `round_spot`
  - `path_provider`
- replace the content of `lib/main.dart` with the 
[`example.dart`](https://github.com/stasgora/round-spot/blob/master/example/example.dart)
- connect a device or start an emulator
- run `flutter run`

### Interacting with the application
- tap the `First page` a few times
- go to the `Second page` using a FAB
- scroll the list, tap some items

### Getting the heat maps
- exit the app or put it in background - do not kill it immediately to allow the heat maps to be generated
- the heat maps are saved under a path returned by
[`getApplicationDocumentsDirectory()`](https://pub.dev/documentation/path_provider/latest/path_provider/getApplicationDocumentsDirectory.html)
