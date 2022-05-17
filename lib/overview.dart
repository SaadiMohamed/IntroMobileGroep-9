import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main.dart';
import 'package:project/mainscreen_student.dart';
import 'package:project/start_exam.dart';
import 'code_corretion_antwoord.dart';
import 'mtp_antwoord.dart';
import 'open_antwoord.dart';

class Overview extends StatefulWidget {
  Overview({required Key? key, required this.questions, required this.snummer})
      : super(key: key);

  dynamic questions;
  String snummer;

  @override
  _OverviewState createState() => _OverviewState(questions, snummer);
}

class _OverviewState extends State<Overview> {
  _OverviewState(this.questions, this.snummer);
  String snummer;
  dynamic questions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Vragen van het examen"),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            CollectionReference taken =
                FirebaseFirestore.instance.collection('taken');
            taken.doc(snummer).update({
              'answers': questions,
            });

            CollectionReference students =
                FirebaseFirestore.instance.collection("students");
            students.doc(snummer).delete();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
          child: const Text("Indienen"),
        ),
        body: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () => {
                    if (questions[index]["type"] == "opn")
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpenAntwoord(
                              snummer: snummer,
                              index: index,
                              questions: questions,
                              key: null,
                            ),
                          ),
                        ),
                      }
                    else if (questions[index]["type"] == "mtp")
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MtpAntwoord(
                                questions: questions,
                                snummer: snummer,
                                index: index,
                                key: null,
                              ),
                            ))
                      }
                    else if (questions[index]["type"] == "ccr")
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CodeCorrection(
                                  key: null,
                                  questions: questions,
                                  snummer: snummer,
                                  index: index),
                            ))
                      }
                  },
                  trailing: CircleAvatar(
                    child: const Icon(Icons.edit),
                    foregroundColor: questions[index]["studentAnswer"] == ""
                        ? Colors.blue
                        : Color.fromARGB(255, 0, 252, 8),
                  ),
                  title: Text("Question: " + questions[index]["question"]),
                ),
              );
            }));
  }
}
