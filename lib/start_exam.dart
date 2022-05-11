import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:project/code_corretion_antwoord.dart';
import 'package:project/open_antwoord.dart';

import 'mtp_antwoord.dart';


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
    fetch();
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
      result.add(data );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future:  getquestions(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return Scaffold(
              appBar: AppBar(
                title: const Text("Vragen van het examen"),
              ),
              body: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context,index) {
                  return Card(
                    child: ListTile(
                      onTap: () =>{
                        if(questions[index]["type"] == "opn"){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OpenAntwoord(question: questions[index], key: null,),
                    ),
                          ),}
                        else if(questions[index]["type"] == "mtp"){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MtpAntwoord(question: questions[index], key: null,),
                    ))}
                    else if(questions[index]["type"] == "ccr"){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CodeCorrection(question: questions[index], key: null,),
                            ))}
                      },
                      trailing: const CircleAvatar(
                        child: Icon(Icons.edit),
                      ),
                      title: Text("Question: " + questions[index]["question"]),
                      
                    
                    ),
                  );
                } 
              )
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
