import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/rendering.dart' as flutter;

import '../../data/data-batch.pb.dart';
import '../../models/session.dart';
import '../../utils/utils.dart';

/// Processes sessions into raw json format
class DataSerializer {
  /// Serializes a set of sessions into a data batch for storage and processing
  Future<Uint8List> process(Iterable<Session> sessions) async {
    var batch = DataBatch();
    for (var session in sessions) {
      if (session.background == null) {
        continue;
      }
      var record = DataRecord(
        startTime: Int64(session.startTime),
        endTime: Int64(session.endTime),
        isPopup: session.isPopup,
        background: List.from(await imageToBytes(session.background!)),
      );
      if (session.page != null) record.page = session.page!;
      record.area = session.area;
      if (session.scrollable) {
        record.bgInfo = BackgroundInfo(
          offset: session.backgroundStatus!.position,
          axis: _toAxis(session.scrollStatus!.axis),
          scrollExtent: _toCoord(session.scrollStatus!.extent),
          viewportSize: session.backgroundStatus!.viewportDimension,
        );
      }
      for (var event in session.events) {
        record.events.add(EventRecord(
          coordinate: _toCoord(event.location),
          time: Int64(event.timestamp),
        ));
      }
      batch.records.add(record);
    }
    return batch.writeToBuffer();
  }

  Coordinate _toCoord(flutter.Offset o) => Coordinate(x: o.dx, y: o.dy);
  Axis _toAxis(flutter.Axis a) =>
      a == flutter.Axis.vertical ? Axis.VERTICAL : Axis.HORIZONTAL;
}
