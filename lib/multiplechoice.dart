import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MultipleChoice extends StatelessWidget {
  CollectionReference questions =
      FirebaseFirestore.instance.collection('questions');
  final TextEditingController question = TextEditingController();
  final TextEditingController answer = TextEditingController();
  final TextEditingController options = TextEditingController();


  MultipleChoice({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Maak een multiple choices'),
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
              padding: const EdgeInsets.fromLTRB(100, 10, 100, 15),
              child: TextField(
                controller: answer,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.check_box, color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Correct',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(100, 10, 100, 15),
              child: TextField(
                controller: options,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Options separated by a ;'
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
                    if(question.text.trim().isEmpty || answer.text.trim().isEmpty || options.text.trim().isEmpty)
                      {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return const AlertDialog(
                                title: Text('Fill in all fields before submitting'),
                              );
                            });
                      }
                    else{
                    questions
                        .add({
                          'question': question.text,
                          'answer': answer.text,
                          'options': options.text,
                          'type': 'mtp'

                        })
                        .then((value) => showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.of(context).pop(true);
                              });
                              return const AlertDialog(
                                title: Text('Question Added'),
                              );
                            }))
                        .catchError(
                            (error) => print("Failed to add user: $error"));
                  }},
                  child: const Text('Save'),
                ))
          ],
        ));
  }
}
