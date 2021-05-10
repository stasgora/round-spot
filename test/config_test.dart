import 'dart:convert';
import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:mocktail/mocktail.dart';
import 'package:round_spot/round_spot.dart';
import 'package:round_spot/src/components/processors/graphical_processor.dart';
import 'package:round_spot/src/components/processors/raw_data_processor.dart';
import 'package:round_spot/src/models/config/config.dart';
import 'package:round_spot/src/models/event.dart';
import 'package:round_spot/src/utils/components.dart';

import 'session_test_utils.dart';

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
    group('Use', () {
      setUpOnce();
      setUpEveryTime();

      test('events from disabled routes are ignored', () {
        var route = 'disabled-route';
        S.get<Config>().disabledRoutes = {route};
        manager.onRouteOpened(settings: RouteSettings(name: route));
        simpleProcessEvents([Event()], count: 0);
      });
      test('disabling the library ends all sessions', () {
        registerEvent();
        S.get<Config>().enabled = false;
        // TODO remove once changes are being detected
        registerEvent(event: Event(id: 1));
        verify(() => S.get<GraphicalProcessor>().process(any())).called(1);
      });
      test('events are ignored if the library is disabled', () {
        S.get<Config>().enabled = false;
        simpleProcessEvents([Event()], count: 0);
      });
      test('reaching the idle timeout causes sessions to be closed', () {
        var idleTime = 60;
        S.get<Config>().maxSessionIdleTime = idleTime;
        return FakeAsync().run((self) {
          registerEvent();
          verifyNever(() => S.get<GraphicalProcessor>().process(any()));
          self.elapse(Duration(seconds: idleTime));
          verify(() => S.get<GraphicalProcessor>().process(any())).called(1);
        });
      });
      test('minimum event count filters ended sessions', () {
        S.get<Config>().minSessionEventCount = 2;
        simpleProcessEvents([Event()], count: 0);
        simpleProcessEvents([Event(id: 1)], count: 1);
      });
      test('output types determine the invoked processors', () {
        S.get<Config>().outputTypes = {OutputType.rawData};
        simpleProcessEvents([Event()], count: 0);
        verify(() => S.get<RawDataProcessor>().process(any())).called(1);
      });
    });
  });
}

String _loadFile(String location) {
  var schemaFile = File(location);
  expect(schemaFile.existsSync(), isTrue);
  return schemaFile.readAsStringSync();
}
