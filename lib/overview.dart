import 'dart:async';

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
  Overview(
      {required Key? key,
      required this.questions,
      required this.snummer,
      required this.duration,
      required this.outFocus})
      : super(key: key);

  dynamic questions;
  String snummer;
  int duration;
  int outFocus;

  @override
  _OverviewState createState() =>
      _OverviewState(questions, snummer, duration, outFocus);
}

class _OverviewState extends State<Overview> with WidgetsBindingObserver {
  _OverviewState(this.questions, this.snummer, this.duration, this.outFocus);
  String snummer;
  dynamic questions;
  int outFocus = 0;

  int duration;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      outFocus++;
      print(outFocus);
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addObserver(this);
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
      "outOfFocus" : outFocus
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
              "Vragen van het examen                                                                                                               Resterende tijd: ${formatedTime()}"),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            indienen();
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
                              outFocus: outFocus,
                              duration: duration,
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
                                outFocus: outFocus,
                                duration: duration,
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
                                  outFocus: outFocus,
                                  duration: duration,
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
