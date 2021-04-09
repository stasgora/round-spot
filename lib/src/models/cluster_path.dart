import 'dart:ui';

/// Contains information about group of clustered events.
class ClusterPath {
  /// A [Path] that describes this cluster
  final Path path;

  /// The center of this cluster
  final Offset center;

  /// Number of events in this cluster
  final int clusterSize;

  /// Creates a [ClusterPath] that holds information about event cluster
  ClusterPath({required this.path, required List<Offset> points})
      : clusterSize = points.length,
        center = Offset(
          _average(points.map((e) => e.dx)),
          _average(points.map((e) => e.dy)),
        );

  static double _average(Iterable<double> list) =>
      list.reduce((a, b) => a + b) / list.length;
}
