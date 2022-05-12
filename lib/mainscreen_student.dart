import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:project/start_exam.dart';

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
      data["snummer"] = queryDocumentSnapshot.id;
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
              child: Text(student['snummer'] +
                  " " +
                  student['firstname'] +
                  " " +
                  student['lastname']),
              value: student,
            );
          }).toList(),
        )),
        Container(
          padding: EdgeInsets.fromLTRB(400, 50, 400, 0),
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartExam(
                            snummer: valueChoose["snummer"],
                            firstname: valueChoose["firstname"],
                            lastname: valueChoose["lastname"],
                            key: null,
                          )));
            },
          ),
        )
      ],
    ));
  }
}
