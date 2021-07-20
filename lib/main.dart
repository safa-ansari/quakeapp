import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List quake = [];

void main() async {
  quake = await getQuake();

  runApp(new MaterialApp(
    home: new Quake(),
  ));
}

class Quake extends StatelessWidget {
  const Quake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Quakes app"),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: new Center(
          child: new ListView.builder(
        itemCount: quake.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (context, index) {
          var feature = quake[index];
          return Card(
            child: ListTile(
              title: Text(feature['properties']['mag'].toString()),
              subtitle: Text(feature['properties']['place']),
              onTap: () {
                _showAlertPage(context, feature['properties']['place']);
              },
            ),
          );
        },
      )),
    );
  }

  void _showAlertPage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: Text('quake'),
      content: Text(message),
      actions: [
        FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ok'),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}

Future<List> getQuake() async {
  Uri apiURl = Uri.parse(
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson');

  var response = await http.get(apiURl);
  var body = jsonDecode(response.body);
  return body['features'];
}
