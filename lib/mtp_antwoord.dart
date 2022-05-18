import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'overview.dart';

class MtpAntwoord extends StatefulWidget {
  MtpAntwoord(
      {required Key? key,
      required this.questions,
      required this.index,
      required this.snummer,
      required this.duration})
      : super(key: key);
  var questions;
  final String snummer;
  final int index;
  int duration;
  @override
  _MtpAntwoordState createState() =>
      _MtpAntwoordState(questions, snummer, index, duration);
}

class _MtpAntwoordState extends State<MtpAntwoord> {
  var questions;
  final String snummer;
  final int index;
  int duration;

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

  String answer = "";
  List<String> options = [];
  _MtpAntwoordState(this.questions, this.snummer, this.index, this.duration);

  @override
  void initState() {
    var test = questions[index]['options'].toString() +
        ";" +
        questions[index]['answer'].toString();
    options = test.split(";");
    if (questions[index]["studentAnswer"] != "") {
      answer = questions[index]["studentAnswer"];
    }
    options.shuffle();
    super.initState();
    startTimer();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Multiple choice vraag                                                                                                                      Resterende tijd: ${formatedTime()}"),
      ),
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Center(
                child: Text(
                  questions[index]['question'],
                  style: const TextStyle(fontSize: 20),
                ),
              )),
          Center(
              child: Column(
            children: options
                .map((option) => RadioListTile(
                      title: Text(option),
                      value: option,
                      groupValue: answer,
                      onChanged: (value) {
                        setState(() {
                          answer = value.toString();
                        });
                      },
                    ))
                .toList(),
          )),
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
                  questions[index]['studentAnswer'] = answer;
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
      ),
    );
  }
}
