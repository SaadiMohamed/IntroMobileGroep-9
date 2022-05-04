import 'dart:convert';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class StartExam extends StatefulWidget {
  StartExam({required Key? key, required this.snummer}) : super(key: key);
  final String snummer;

  @override
  _StartExamState createState() => _StartExamState(this.snummer);
}

class _StartExamState extends State<StartExam> {
  _StartExamState(this.snummer);
  final String snummer;

  Location location = Location();
  String displayName ="";
  @override
  initState()  {
    super.initState();
    getLocation();
  }

  Future getLocation() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    var currentLocation = await location.getLocation();
    String url =
        "http://nominatim.openstreetmap.org/reverse?format=json&lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&zoom=18&addressdetails=";
    var response = await http.get(Uri.parse(url));
    var address = json.decode(response.body)["address"];
    var displayname = json.decode(response.body)["display_name"];
    setState(() {
      displayName = displayname;
    });
    return displayname;
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body:FutureBuilder(
       future: getLocation(),
       builder: (context, snapshot) {
         if (snapshot.hasData) {
           return Center(
             child: Text(displayName),
           );
         } else {
           return const Center(
             child: CircularProgressIndicator(),
           );
         }
       },
     )
   );
  }
}
