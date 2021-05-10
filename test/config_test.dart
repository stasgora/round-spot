import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:round_spot/round_spot.dart';
import 'package:round_spot/src/models/config/config.dart';

final String _schemaPath = 'assets/config-schema.json';
final String _configPath = 'assets/example-config.json';
final Config _config = Config(
  enabled: true,
  uiElementSize: 10,
  disabledRoutes: {'some-unimportant-route'},
  outputTypes: {OutputType.graphicalRender},
  minSessionEventCount: 1,
  maxSessionIdleTime: 60,
  heatMapStyle: HeatMapStyle.smooth,
  heatMapTransparency: 0.6,
  heatMapPixelRatio: 2,
);

void main() {
  group('Configuration', () {
    group('Example', () {
      test('exists and is valid', () {
        var schema = JsonSchema.createSchema(_loadFile(_schemaPath));
        schema.validate(_loadFile(_configPath));
      });
      test('is properly loaded', () {
        var configFile = _loadFile(_configPath);
        var config = Config.fromJson(json.decode(configFile));
        expect(config, equals(_config));
      });
    });
  });
}

String _loadFile(String location) {
  var schemaFile = File(location);
  expect(schemaFile.existsSync(), isTrue);
  return schemaFile.readAsStringSync();
}
