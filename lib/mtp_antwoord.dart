import 'package:flutter/material.dart';

import 'overview.dart';

class MtpAntwoord extends StatefulWidget {
  MtpAntwoord({
    required Key? key,
    required this.questions,
    required this.index,
    required this.snummer,
  }) : super(key: key);
  var questions;
  final String snummer;
  final int index;
  @override
  _MtpAntwoordState createState() =>
      _MtpAntwoordState(questions, snummer, index);
}

class _MtpAntwoordState extends State<MtpAntwoord> {
  var questions;
  final String snummer;
  final int index;

  String answer = "";
  List<String> options = [];
  _MtpAntwoordState(this.questions, this.snummer, this.index);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple question'),
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
