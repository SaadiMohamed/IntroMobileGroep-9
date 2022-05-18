import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'overview.dart';

class CodeCorrection extends StatefulWidget {
  CodeCorrection(
      {required Key? key,
      required this.questions,
      required this.index,
      required this.snummer,
      required this.duration})
      : super(key: key);
  var questions;
  final int index;
  final String snummer;
  int duration;

  @override
  _CodeCorrectionState createState() =>
      _CodeCorrectionState(questions, index, snummer, duration);
}

class _CodeCorrectionState extends State<CodeCorrection> {
  var questions;
  final int index;
  final String snummer;
  int duration;

  _CodeCorrectionState(this.questions, this.index, this.snummer, this.duration);
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _controller.text = questions[index]['studentAnswer'];
    super.initState();
    startTimer();
  }

  late Timer _timer;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (duration == 0) {
          setState(() {
            timer.cancel();
          });
          indienen();
        } else {
          setState(() {
            duration--;
          });
        }
      },
    );
  }

  indienen() {
    CollectionReference taken = FirebaseFirestore.instance.collection('taken');
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
  }

  formatedTime() {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = duration ~/ 60;
    int sec = duration % 60;

    String parsedTime =
        getParsedTime(min.toString()) + " : " + getParsedTime(sec.toString());

    return parsedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Code correction vraag                                                                                                       Resterende tijd: ${formatedTime()}"),
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Center(
                  child: Text(questions[index]['question'],
                      style: const TextStyle(fontSize: 20))),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(100, 50, 100, 0),
              child: Center(
                  child: TextField(
                controller: _controller,
                maxLines: 10,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.edit, color: Colors.blue),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Antwoord',
                ),
              )),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(400, 120, 400, 15),
                child: Center(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(100, 50),
                      maximumSize: const Size(100, 50) //////// HERE
                      ),
                  onPressed: () {
                    questions[index]["studentAnswer"] = _controller.text;
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            Overview(
                          duration: duration,
                          snummer: snummer,
                          key: null,
                          questions: questions,
                        ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text("Save"),
                )))
          ],
        ));
  }
}
