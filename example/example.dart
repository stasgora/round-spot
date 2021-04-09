import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:round_spot/round_spot.dart' as round_spot;

void main() {
	runApp(round_spot.initialize(
		child: ExampleApp(),
		config: round_spot.Config(
			uiElementSize: 12,
		),
		heatMapCallback: (data, info) async {
			var path = (await getApplicationDocumentsDirectory()).path;
			File('$path/${info.page}_${info.area}.png').writeAsBytes(data);
		},
	));
}

class ExampleApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Example Application',
			navigatorObservers: [round_spot.Observer()],
			initialRoute: 'first',
			routes: {
				'first': (context) => Scaffold(
					appBar: AppBar(title: Text('First page')),
					floatingActionButton: FloatingActionButton(
						child: Icon(Icons.arrow_forward),
						onPressed: () => Navigator.pushNamed(context, 'second'),
					),
				),
				'second': (context) => Scaffold(
					body: SingleChildScrollView(
						child: round_spot.ListDetector(
							areaID: 'list',
							children: [
								for (int i = 0; i < 50; i++) ListTile(title: Text('$i'))
							],
						),
					),
					appBar: AppBar(title: Text('Second page')),
				)
			},
		);
	}
}
