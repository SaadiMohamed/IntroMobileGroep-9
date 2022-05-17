import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/exammenu_lector.dart';

import 'make_exam.dart';

class OpenQuestion extends StatelessWidget {
  OpenQuestion({Key? key}) : super(key: key);
  TextEditingController question = TextEditingController();
  TextEditingController max = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference questions =
        FirebaseFirestore.instance.collection('questions');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Maak een open vraag'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: TextField(
                controller: question,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.question_answer, color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Question',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: TextField(
                controller: max,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.question_answer, color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Max score',
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(400, 120, 400, 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(100, 80),
                      maximumSize: const Size(100, 80) //////// HERE
                      ),
                  onPressed: () {
                    if (question.text.trim().isEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return const AlertDialog(
                              title:
                                  Text('Fill in all fields before submitting'),
                            );
                          });
                    } else {
                      questions
                          .add({
                            'question': question.text,
                            'type': 'opn',
                            'max': int.parse(max.text)
                          })
                          .then((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Makeexam())))
                          .catchError(
                              (error) => print("Failed to add user: $error"));
                    }
                  },
                  child: const Text('Save'),
                ))
          ],
        ));
  }
}
