import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
  int duration = 0;

  fetch() async {
    dynamic result = await getquestions();
    if (result != null) {
      setState(() {
        questions = result["result"];
        duration = int.parse(result["duration"].toString());
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

    var time = FirebaseFirestore.instance.collection('time');
    var querySnapshot2 = await time.get();
    var duration = querySnapshot2.docs[0].data()['duration'];
    var t = {};
    t['duration'] = duration;
    t["result"] = result;
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Start me examen"),
        ),
        body: FutureBuilder(
          future: getquestions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  Text("You have ${duration} minutes to complete this exam"),
                  Container(
                    padding: EdgeInsets.fromLTRB(350, 0, 350, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: const Size(200, 100),
                          maximumSize: const Size(200, 100) //////// HERE
                          ),
                      child: const Text(
                        "Start examen",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Overview(
                              questions: questions,
                              snummer: snummer,
                              key: null,
                            ),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  )
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
