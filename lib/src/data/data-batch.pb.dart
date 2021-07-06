///
//  Generated code. Do not modify.
//  source: data-batch.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'data-batch.pbenum.dart';

export 'data-batch.pbenum.dart';

class Coordinate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Coordinate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'round_spot'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Coordinate._() : super();
  factory Coordinate({
    $core.double? x,
    $core.double? y,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    return _result;
  }
  factory Coordinate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Coordinate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Coordinate clone() => Coordinate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Coordinate copyWith(void Function(Coordinate) updates) => super.copyWith((message) => updates(message as Coordinate)) as Coordinate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Coordinate create() => Coordinate._();
  Coordinate createEmptyInstance() => create();
  static $pb.PbList<Coordinate> createRepeated() => $pb.PbList<Coordinate>();
  @$core.pragma('dart2js:noInline')
  static Coordinate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coordinate>(create);
  static Coordinate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class EventRecord extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventRecord', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'round_spot'), createEmptyInstance: create)
    ..aOM<Coordinate>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coordinate', subBuilder: Coordinate.create)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time')
    ..hasRequiredFields = false
  ;

  EventRecord._() : super();
  factory EventRecord({
    Coordinate? coordinate,
    $fixnum.Int64? time,
  }) {
    final _result = create();
    if (coordinate != null) {
      _result.coordinate = coordinate;
    }
    if (time != null) {
      _result.time = time;
    }
    return _result;
  }
  factory EventRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventRecord clone() => EventRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventRecord copyWith(void Function(EventRecord) updates) => super.copyWith((message) => updates(message as EventRecord)) as EventRecord; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventRecord create() => EventRecord._();
  EventRecord createEmptyInstance() => create();
  static $pb.PbList<EventRecord> createRepeated() => $pb.PbList<EventRecord>();
  @$core.pragma('dart2js:noInline')
  static EventRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventRecord>(create);
  static EventRecord? _defaultInstance;

  @$pb.TagNumber(1)
  Coordinate get coordinate => $_getN(0);
  @$pb.TagNumber(1)
  set coordinate(Coordinate v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoordinate() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoordinate() => clearField(1);
  @$pb.TagNumber(1)
  Coordinate ensureCoordinate() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get time => $_getI64(1);
  @$pb.TagNumber(2)
  set time($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);
}

class BackgroundInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BackgroundInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'round_spot'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offset', $pb.PbFieldType.OD)
    ..e<Axis>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'axis', $pb.PbFieldType.OE, defaultOrMaker: Axis.VERTICAL, valueOf: Axis.valueOf, enumValues: Axis.values)
    ..aOM<Coordinate>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scrollExtent', subBuilder: Coordinate.create)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'viewportSize', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  BackgroundInfo._() : super();
  factory BackgroundInfo({
    $core.double? offset,
    Axis? axis,
    Coordinate? scrollExtent,
    $core.double? viewportSize,
  }) {
    final _result = create();
    if (offset != null) {
      _result.offset = offset;
    }
    if (axis != null) {
      _result.axis = axis;
    }
    if (scrollExtent != null) {
      _result.scrollExtent = scrollExtent;
    }
    if (viewportSize != null) {
      _result.viewportSize = viewportSize;
    }
    return _result;
  }
  factory BackgroundInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BackgroundInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BackgroundInfo clone() => BackgroundInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BackgroundInfo copyWith(void Function(BackgroundInfo) updates) => super.copyWith((message) => updates(message as BackgroundInfo)) as BackgroundInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BackgroundInfo create() => BackgroundInfo._();
  BackgroundInfo createEmptyInstance() => create();
  static $pb.PbList<BackgroundInfo> createRepeated() => $pb.PbList<BackgroundInfo>();
  @$core.pragma('dart2js:noInline')
  static BackgroundInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BackgroundInfo>(create);
  static BackgroundInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get offset => $_getN(0);
  @$pb.TagNumber(1)
  set offset($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => clearField(1);

  @$pb.TagNumber(2)
  Axis get axis => $_getN(1);
  @$pb.TagNumber(2)
  set axis(Axis v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAxis() => $_has(1);
  @$pb.TagNumber(2)
  void clearAxis() => clearField(2);

  @$pb.TagNumber(3)
  Coordinate get scrollExtent => $_getN(2);
  @$pb.TagNumber(3)
  set scrollExtent(Coordinate v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasScrollExtent() => $_has(2);
  @$pb.TagNumber(3)
  void clearScrollExtent() => clearField(3);
  @$pb.TagNumber(3)
  Coordinate ensureScrollExtent() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get viewportSize => $_getN(3);
  @$pb.TagNumber(4)
  set viewportSize($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasViewportSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearViewportSize() => clearField(4);
}

class DataRecord extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DataRecord', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'round_spot'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'page')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'area')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isPopup')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'background', $pb.PbFieldType.OY)
    ..pc<EventRecord>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'events', $pb.PbFieldType.PM, subBuilder: EventRecord.create)
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startTime')
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endTime')
    ..aOM<BackgroundInfo>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bgInfo', subBuilder: BackgroundInfo.create)
    ..hasRequiredFields = false
  ;

  DataRecord._() : super();
  factory DataRecord({
    $core.String? page,
    $core.String? area,
    $core.bool? isPopup,
    $core.List<$core.int>? background,
    $core.Iterable<EventRecord>? events,
    $fixnum.Int64? startTime,
    $fixnum.Int64? endTime,
    BackgroundInfo? bgInfo,
  }) {
    final _result = create();
    if (page != null) {
      _result.page = page;
    }
    if (area != null) {
      _result.area = area;
    }
    if (isPopup != null) {
      _result.isPopup = isPopup;
    }
    if (background != null) {
      _result.background = background;
    }
    if (events != null) {
      _result.events.addAll(events);
    }
    if (startTime != null) {
      _result.startTime = startTime;
    }
    if (endTime != null) {
      _result.endTime = endTime;
    }
    if (bgInfo != null) {
      _result.bgInfo = bgInfo;
    }
    return _result;
  }
  factory DataRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataRecord clone() => DataRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataRecord copyWith(void Function(DataRecord) updates) => super.copyWith((message) => updates(message as DataRecord)) as DataRecord; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataRecord create() => DataRecord._();
  DataRecord createEmptyInstance() => create();
  static $pb.PbList<DataRecord> createRepeated() => $pb.PbList<DataRecord>();
  @$core.pragma('dart2js:noInline')
  static DataRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataRecord>(create);
  static DataRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get page => $_getSZ(0);
  @$pb.TagNumber(1)
  set page($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get area => $_getSZ(1);
  @$pb.TagNumber(2)
  set area($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasArea() => $_has(1);
  @$pb.TagNumber(2)
  void clearArea() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isPopup => $_getBF(2);
  @$pb.TagNumber(3)
  set isPopup($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsPopup() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsPopup() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get background => $_getN(3);
  @$pb.TagNumber(4)
  set background($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBackground() => $_has(3);
  @$pb.TagNumber(4)
  void clearBackground() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<EventRecord> get events => $_getList(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get startTime => $_getI64(5);
  @$pb.TagNumber(6)
  set startTime($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasStartTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartTime() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get endTime => $_getI64(6);
  @$pb.TagNumber(7)
  set endTime($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasEndTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearEndTime() => clearField(7);

  @$pb.TagNumber(8)
  BackgroundInfo get bgInfo => $_getN(7);
  @$pb.TagNumber(8)
  set bgInfo(BackgroundInfo v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasBgInfo() => $_has(7);
  @$pb.TagNumber(8)
  void clearBgInfo() => clearField(8);
  @$pb.TagNumber(8)
  BackgroundInfo ensureBgInfo() => $_ensure(7);
}

class DataBatch extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DataBatch', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'round_spot'), createEmptyInstance: create)
    ..pc<DataRecord>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'records', $pb.PbFieldType.PM, subBuilder: DataRecord.create)
    ..hasRequiredFields = false
  ;

  DataBatch._() : super();
  factory DataBatch({
    $core.Iterable<DataRecord>? records,
  }) {
    final _result = create();
    if (records != null) {
      _result.records.addAll(records);
    }
    return _result;
  }
  factory DataBatch.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataBatch.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DataBatch clone() => DataBatch()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DataBatch copyWith(void Function(DataBatch) updates) => super.copyWith((message) => updates(message as DataBatch)) as DataBatch; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataBatch create() => DataBatch._();
  DataBatch createEmptyInstance() => create();
  static $pb.PbList<DataBatch> createRepeated() => $pb.PbList<DataBatch>();
  @$core.pragma('dart2js:noInline')
  static DataBatch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataBatch>(create);
  static DataBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DataRecord> get records => $_getList(0);
}

