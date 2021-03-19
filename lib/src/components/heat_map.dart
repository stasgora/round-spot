import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_cluster/simple_cluster.dart';

import '../models/cluster_path.dart';
import '../models/session.dart';

typedef ScaleFunction = double Function(int level, int clusterSize);

class HeatMap {
	double maxDistance;
	double detailLevel;
	DBSCAN dbScan;
	Session session;
	final _paths = <ClusterPath>[];

	late int largestCluster;
	late int smallestCluster;

	HeatMap({
		required this.session,
		required this.maxDistance,
		this.detailLevel = .2})
			: dbScan = DBSCAN(epsilon: maxDistance) {
		var dbPoints = session.events.map<List<double>>((e) => e.locationAsList);
		dbScan.run(dbPoints.toList());
		_createClusterPaths();

		var sizes = dbScan.cluster.map((e) => e.length);
		largestCluster = sizes.isNotEmpty ? sizes.reduce(max) : 1;
		smallestCluster = dbScan.noise.isNotEmpty ? 1 : sizes.reduce(min);
	}

	Path getPathLayer(int level, {ScaleFunction scaleFunc = logBasedLevelScale}) {
		var joinedPath = Path();
		for (var cluster in _paths.where((p) => p.clusterSize >= level)) {
			var transform = Matrix4.identity()
				..translate(cluster.center.dx, cluster.center.dy)
				..scale(scaleFunc(level, cluster.clusterSize))
				..translate(-cluster.center.dx, -cluster.center.dy);
			var path = cluster.path.transform(transform.storage);
			joinedPath = Path.combine(PathOperation.union, joinedPath, path);
		}
		return joinedPath;
	}

	void _createClusterPaths() {
		var pointRadius = (1 - detailLevel) * maxDistance;
		for (var cluster in dbScan.cluster) {
			var clusterPath = Path();
			for (var pointIndex in cluster) {
				var pointPath = session.events[pointIndex].asPath(pointRadius);
				clusterPath = Path.combine(PathOperation.union, clusterPath, pointPath);
			}
			_paths.add(ClusterPath(
				path: clusterPath,
				points: cluster.map((e) => session.events[e].location).toList())
			);
		}
		simpleCluster(index) => ClusterPath(
			path: session.events[index].asPath(pointRadius),
			points: [session.events[index].location]
		);
		_paths.addAll(dbScan.noise.map(simpleCluster));
	}

	static double logBasedLevelScale(int level, int clusterSize) =>
			1 + log(clusterSize - level + 1);
}
