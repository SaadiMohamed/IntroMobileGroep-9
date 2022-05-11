import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ll;
import 'package:project/display_map.dart';

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
  double? lat = 50;
  double? lng = 4;
  String displayName = "";
  late Future future;
  @override
  initState() {
    future = getLocation();
    super.initState();
    fetch();
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
    setState(() {
      lat = currentLocation.latitude;
      lng = currentLocation.longitude;
    });
    return;
  }

  List questions = [];

  fetch() async {
    dynamic result = await getquestions();
    if (result != null) {
      setState(() {
        questions = result;
      });
    } else {
      print("unable to retrieve");
    }
  }

  Future getquestions() async {
    var collection = FirebaseFirestore.instance.collection('questions');
    var querySnapshot = await collection.get();
    var result = [];
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      data['id'] = queryDocumentSnapshot.id;
      result.add(data);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return DisplayMap(
                  latitude: lat!,
                  longitude: lng!,
                  key: null,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
