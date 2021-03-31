import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_cluster/simple_cluster.dart';

import '../models/cluster_path.dart';
import '../models/session.dart';

typedef ScaleFunction = double Function(double level, double scaleFactor);

class HeatMap {
  double pointProximity;
  double clusterScale; // 0.5 - 1.5
  DBSCAN dbScan;
  Session session;
  final _paths = <ClusterPath>[];

  late int largestCluster;
  late int smallestCluster;

  HeatMap({
    required this.session,
    required this.pointProximity,
    this.clusterScale = 0.5,
  }) : dbScan = DBSCAN(epsilon: pointProximity) {
    var dbPoints = session.events.map<List<double>>((e) => e.locationAsList);
    dbScan.run(dbPoints.toList());
    _createClusterPaths();

    var sizes = dbScan.cluster.map((e) => e.length);
    largestCluster = sizes.isNotEmpty ? sizes.reduce(max) : 1;
    smallestCluster = dbScan.noise.isNotEmpty ? 1 : sizes.reduce(min);
  }

  Path getPathLayer(
    double layer, {
    ScaleFunction scaleFunc = logBasedLevelScale,
  }) {
    var joinedPath = Path();
    var paths = _paths.where((p) => p.clusterSize / largestCluster >= layer);
    for (var cluster in paths) {
      var scaleInput = cluster.clusterSize - layer * largestCluster;
      var transform = Matrix4.identity()
        ..translate(cluster.center.dx, cluster.center.dy)
        ..scale(scaleFunc(scaleInput, 1 / clusterScale))
        ..translate(-cluster.center.dx, -cluster.center.dy);
      var path = cluster.path.transform(transform.storage);
      joinedPath = Path.combine(PathOperation.union, joinedPath, path);
    }
    return joinedPath;
  }

  void _createClusterPaths() {
    var pointRadius = pointProximity * 0.75;
    for (var cluster in dbScan.cluster) {
      var clusterPath = Path();
      for (var pointIndex in cluster) {
        var pointPath = session.events[pointIndex].asPath(pointRadius);
        clusterPath = Path.combine(PathOperation.union, clusterPath, pointPath);
      }
      _paths.add(ClusterPath(
          path: clusterPath,
          points: cluster.map((e) => session.events[e].location).toList()));
    }
    simpleCluster(index) => ClusterPath(
        path: session.events[index].asPath(pointRadius),
        points: [session.events[index].location]);
    _paths.addAll(dbScan.noise.map(simpleCluster));
  }

  static double logBasedLevelScale(double level, double scaleFactor) =>
      1 + log(level + 0.5 / scaleFactor) / scaleFactor;
}
