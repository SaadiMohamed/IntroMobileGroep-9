import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:project/code_corretion_antwoord.dart';
import 'package:project/open_antwoord.dart';
import 'package:project/overview.dart';

import 'mtp_antwoord.dart';

class StartExam extends StatefulWidget {
  StartExam(
      {required Key? key,
      required this.snummer,
      required this.firstname,
      required this.lastname})
      : super(key: key);
  final String snummer;
  final String firstname;
  final String lastname;

  @override
  _StartExamState createState() =>
      _StartExamState(this.snummer, this.firstname, this.lastname);
}

class _StartExamState extends State<StartExam> {
  _StartExamState(this.snummer, this.firstname, this.lastname);
  final String snummer;
  final String firstname;
  final String lastname;

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
    CollectionReference taken = FirebaseFirestore.instance.collection('taken');
    taken.doc(snummer).set(
      {
        'lat': lat,
        'lng': lng,
        'firstname': firstname,
        'lastname': lastname,
      },
    );
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
      data['studentAnswer'] = "";
      result.add(data);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Start me examen"),
        ),
        body: ElevatedButton(
          child: Text("Start examen"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Overview(
                  snummer: snummer,
                  questions: questions,
                  key: null,
                ),
              ),
            );
          },
        ));
  }
}
