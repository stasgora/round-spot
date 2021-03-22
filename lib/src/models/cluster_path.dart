import 'dart:ui';

class ClusterPath {
  final Path path;
  final Offset center;
  final int clusterSize;

  ClusterPath({required this.path, required List<Offset> points})
      : clusterSize = points.length,
        center = Offset(
            average(points.map((e) => e.dx)), average(points.map((e) => e.dy)));

  static double average(Iterable<double> list) =>
      list.reduce((a, b) => a + b) / list.length;
}
