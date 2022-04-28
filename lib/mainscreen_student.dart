import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_platform_interface/location_platform_interface.dart' as LocationAccuracy;
import 'package:http/http.dart' as http;

class MainscreenStudent extends StatefulWidget {
  const MainscreenStudent({Key? key}) : super(key: key);

  @override
  State<MainscreenStudent> createState() => _MainscreenStudentState();
}

class _MainscreenStudentState extends State<MainscreenStudent> {
  @override
  initState() {
    super.initState();
    fetch();
  }

  dynamic valueChoose;
  List students = [];

  fetch() async {
    dynamic result = await getStudents();
    if (result != null) {
      setState(() {
        students = result;
      });
    } else {
      print("unable to retrieve");
    }
  }

  Future getStudents() async {
    var collection = FirebaseFirestore.instance.collection('students');
    var querySnapshot = await collection.get();
    var result = [];
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      result.add(data);
    }
    return result;
  }
Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Center(
            child: DropdownButton(
          value: valueChoose,
          hint: const Text("Select your name"),
          onChanged: (newValue) {
            setState(() {
              valueChoose = newValue;
            });
          },
          items: students.map((dynamic student) {
            return DropdownMenuItem(
              child: Text(student['snumber'] +
                  " " +
                  student['firstname'] +
                  " " +
                  student['lastname']),
              value: student,
            );
          }).toList(),
        )),
        Container(
          padding: EdgeInsets.fromLTRB(400,50, 400, 0),
          child: ElevatedButton(

            style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shadowColor: Colors.greenAccent,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: const Size(40, 80),
                maximumSize: const Size(40, 80) //////// HERE
                ),
            child: const Text("Confirm"),
            onPressed: () {
              if (valueChoose != null) {
                // show dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                          "Confirm ${valueChoose['snumber']} ${valueChoose['firstname']} ${valueChoose['lastname']}",
                          textAlign: TextAlign.center),
                      content: const Text("Are you sure this is you",
                          textAlign: TextAlign.center),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Text("Yes"),
                              onPressed: () async {
                                    var serviceEnabled = await location.serviceEnabled();
                                    if(!serviceEnabled){
                                      serviceEnabled = await location.requestService();
                                      if(serviceEnabled){
                                        return;
                                      }
                                    }

                                    var permissionGranted = await location.hasPermission();
                                    if(permissionGranted == PermissionStatus.denied){
                                      permissionGranted = await location.requestPermission();
                                      if(permissionGranted != PermissionStatus.granted){
                                        return;
                                      }
                                    }
                                    var currentLocation = await location.getLocation();
                                    String url = "http://nominatim.openstreetmap.org/reverse?format=json&lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&zoom=18&addressdetails=";
                                    var response = await http.get(Uri.parse(url));
                                    var address = json.decode(response.body)["address"];
                                    var displayname = json.decode(response.body)["display_name"];
                                    print(displayname);
                                    print("${address["road"]} ${address["house_number"]} \n${address["postcode"]} ${address["town"]}\n${address["state"]} ${address["country"]}");
                                    },

                            ),
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        )
                      ],
                    );
                  },
                );
              }
            },
          ),
        )
      ],
    ));
  }
}
