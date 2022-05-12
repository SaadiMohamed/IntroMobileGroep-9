import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:http/http.dart' as http;

class DisplayMap extends StatelessWidget {
  const DisplayMap(
      {required Key? key, required this.latitude, required this.longitude})
      : super(key: key);
  final double latitude;
  final double longitude;

  Future<String> address() async {
    String url =
        "http://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}&zoom=18&addressdetails=";
    var response = await http.get(Uri.parse(url));
    var address = json.decode(response.body)["address"];
    var displayname = json.decode(response.body)["display_name"];
    return displayname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: address(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(title: Text(snapshot.data.toString())),
                floatingActionButton: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3),
                  child: const Text("Done"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                body: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                  child: FlutterMap(
                      options: MapOptions(
                          center: ll.LatLng(latitude, longitude),
                          minZoom: 10.0),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayerOptions(markers: [
                          Marker(
                              width: 100.0,
                              height: 100.0,
                              point: ll.LatLng(latitude, longitude),
                              builder: (context) => Container(
                                    child: IconButton(
                                        icon: const Icon(Icons.location_on),
                                        color: Colors.red,
                                        onPressed: () {}),
                                  ))
                        ])
                      ]),
                ));
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
