///
//  Generated code. Do not modify.
//  source: data-batch.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use axisDescriptor instead')
const Axis$json = const {
  '1': 'Axis',
  '2': const [
    const {'1': 'VERTICAL', '2': 0},
    const {'1': 'HORIZONTAL', '2': 1},
  ],
};

/// Descriptor for `Axis`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List axisDescriptor = $convert.base64Decode('CgRBeGlzEgwKCFZFUlRJQ0FMEAASDgoKSE9SSVpPTlRBTBAB');
@$core.Deprecated('Use coordinateDescriptor instead')
const Coordinate$json = const {
  '1': 'Coordinate',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
  ],
};

/// Descriptor for `Coordinate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coordinateDescriptor = $convert.base64Decode('CgpDb29yZGluYXRlEgwKAXgYASABKAJSAXgSDAoBeRgCIAEoAlIBeQ==');
@$core.Deprecated('Use eventRecordDescriptor instead')
const EventRecord$json = const {
  '1': 'EventRecord',
  '2': const [
    const {'1': 'coordinate', '3': 1, '4': 1, '5': 11, '6': '.round_spot.Coordinate', '10': 'coordinate'},
    const {'1': 'time', '3': 2, '4': 1, '5': 3, '10': 'time'},
  ],
};

/// Descriptor for `EventRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventRecordDescriptor = $convert.base64Decode('CgtFdmVudFJlY29yZBI2Cgpjb29yZGluYXRlGAEgASgLMhYucm91bmRfc3BvdC5Db29yZGluYXRlUgpjb29yZGluYXRlEhIKBHRpbWUYAiABKANSBHRpbWU=');
@$core.Deprecated('Use backgroundInfoDescriptor instead')
const BackgroundInfo$json = const {
  '1': 'BackgroundInfo',
  '2': const [
    const {'1': 'offset', '3': 1, '4': 1, '5': 1, '10': 'offset'},
    const {'1': 'axis', '3': 2, '4': 1, '5': 14, '6': '.round_spot.Axis', '10': 'axis'},
    const {'1': 'scroll_extent', '3': 3, '4': 1, '5': 11, '6': '.round_spot.Coordinate', '10': 'scrollExtent'},
    const {'1': 'viewport_size', '3': 4, '4': 1, '5': 1, '10': 'viewportSize'},
  ],
};

/// Descriptor for `BackgroundInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List backgroundInfoDescriptor = $convert.base64Decode('Cg5CYWNrZ3JvdW5kSW5mbxIWCgZvZmZzZXQYASABKAFSBm9mZnNldBIkCgRheGlzGAIgASgOMhAucm91bmRfc3BvdC5BeGlzUgRheGlzEjsKDXNjcm9sbF9leHRlbnQYAyABKAsyFi5yb3VuZF9zcG90LkNvb3JkaW5hdGVSDHNjcm9sbEV4dGVudBIjCg12aWV3cG9ydF9zaXplGAQgASgBUgx2aWV3cG9ydFNpemU=');
@$core.Deprecated('Use dataRecordDescriptor instead')
const DataRecord$json = const {
  '1': 'DataRecord',
  '2': const [
    const {'1': 'page', '3': 1, '4': 1, '5': 9, '10': 'page'},
    const {'1': 'area', '3': 2, '4': 1, '5': 9, '10': 'area'},
    const {'1': 'is_popup', '3': 3, '4': 1, '5': 8, '10': 'isPopup'},
    const {'1': 'background', '3': 4, '4': 1, '5': 12, '10': 'background'},
    const {'1': 'events', '3': 5, '4': 3, '5': 11, '6': '.round_spot.EventRecord', '10': 'events'},
    const {'1': 'start_time', '3': 6, '4': 1, '5': 3, '10': 'startTime'},
    const {'1': 'end_time', '3': 7, '4': 1, '5': 3, '10': 'endTime'},
    const {'1': 'bg_info', '3': 8, '4': 1, '5': 11, '6': '.round_spot.BackgroundInfo', '10': 'bgInfo'},
  ],
};

/// Descriptor for `DataRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataRecordDescriptor = $convert.base64Decode('CgpEYXRhUmVjb3JkEhIKBHBhZ2UYASABKAlSBHBhZ2USEgoEYXJlYRgCIAEoCVIEYXJlYRIZCghpc19wb3B1cBgDIAEoCFIHaXNQb3B1cBIeCgpiYWNrZ3JvdW5kGAQgASgMUgpiYWNrZ3JvdW5kEi8KBmV2ZW50cxgFIAMoCzIXLnJvdW5kX3Nwb3QuRXZlbnRSZWNvcmRSBmV2ZW50cxIdCgpzdGFydF90aW1lGAYgASgDUglzdGFydFRpbWUSGQoIZW5kX3RpbWUYByABKANSB2VuZFRpbWUSMwoHYmdfaW5mbxgIIAEoCzIaLnJvdW5kX3Nwb3QuQmFja2dyb3VuZEluZm9SBmJnSW5mbw==');
@$core.Deprecated('Use dataBatchDescriptor instead')
const DataBatch$json = const {
  '1': 'DataBatch',
  '2': const [
    const {'1': 'records', '3': 1, '4': 3, '5': 11, '6': '.round_spot.DataRecord', '10': 'records'},
  ],
};

/// Descriptor for `DataBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataBatchDescriptor = $convert.base64Decode('CglEYXRhQmF0Y2gSMAoHcmVjb3JkcxgBIAMoCzIWLnJvdW5kX3Nwb3QuRGF0YVJlY29yZFIHcmVjb3Jkcw==');
