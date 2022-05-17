import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/make_exam.dart';

class CodeCorrection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController correct = TextEditingController();
    TextEditingController tocomplete = TextEditingController();
    CollectionReference questions =
        FirebaseFirestore.instance.collection('questions');

    return Scaffold(
        appBar: AppBar(
          title: Text('Code Correction'),
        ),
        body: ListView(children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    maxLines: 10,
                    controller: tocomplete,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.cancel, color: Colors.red),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Code to complete',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    maxLines: 10,
                    controller: correct,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.check, color: Colors.green),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Correct Code',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(400, 20, 400, 15),
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
                  questions.add({
                    'question': tocomplete.text,
                    'answer': correct.text,
                    'type': 'ccr'
                  }).then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Makeexam()));
                  });
                },
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              )),
        ]));
  }
}
