import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/overview.dart';
import 'package:project/start_exam.dart';

import 'main.dart';

class OpenAntwoord extends StatefulWidget {
  OpenAntwoord(
      {required Key? key,
      required this.questions,
      required this.snummer,
      required this.index,
      required this.duration,
      required this.outFocus})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var questions;
  final String snummer;
  final int index;
  int duration;
  int outFocus;

  @override
  _OpenAntwoordState createState() =>
      _OpenAntwoordState(questions, snummer, index, duration, outFocus);
}

class _OpenAntwoordState extends State<OpenAntwoord>
    with WidgetsBindingObserver {
  var questions;
  int duration;
  final int index;
  final String snummer;
  int outFocus;
  _OpenAntwoordState(
      this.questions, this.snummer, this.index, this.duration, this.outFocus);
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    _controller.text = questions[index]['studentAnswer'];
    super.initState();
    startTimer();
  }

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
              "Open vraag                                                                                                                        Resterende tijd: ${formatedTime()}"),
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
                          outFocus: outFocus,
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
