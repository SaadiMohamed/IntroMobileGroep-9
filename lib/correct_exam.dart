import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/display_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'open_vraag_verbeter.dart';

class CorrectExam extends StatefulWidget {
  CorrectExam({required Key? key, required this.information}) : super(key: key);
  dynamic information;
  @override
  _CorrectExamState createState() => _CorrectExamState(information);
}

getOpen() {}

class _CorrectExamState extends State<CorrectExam> {
  _CorrectExamState(this.information);
  dynamic information;

  @override
  initState() {
    super.initState();
    getOpenQuestion();
  }

  getOpenQuestion() {
    var collection = FirebaseFirestore.instance.collection('taken');
    int score = 0;
    int total = 0;
    var opns = [];
    for (var item in information["answers"]) {
      if (item["type"] == "opn") {
        item["score"] = 0;
        item["max"] = 0;
        opns.add(item);
      } else if (item["type"] == "mtp") {
        if (item["answer"].toString() == item["studentAnswer"].toString()) {
          score++;
        }

        total++;
      } else {
        if (item["answer"].toString().trim().toLowerCase() ==
            item["studentAnswer"].toString().trim().toLowerCase()) {
          score++;
        }
        total++;
      }
    }
    collection.doc(information["snummer"]).update({
      'score': score,
    });
    collection.doc(information["snummer"]).update({
      'total': total,
    });

    information["score"] = score;
    information["total"] = total;
    information["opns"] = opns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verbeter Examen"),
        ),
        body: ListView(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Center(
                    child: Text(
                  information['firstname'] + " " + information['lastname'],
                  style: const TextStyle(fontSize: 40),
                ))),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Center(
                  child: Text(
                "Score:" + information['score'].toString(),
                style: const TextStyle(fontSize: 20),
              )),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(200, 120),
                        maximumSize: const Size(200, 120) //////// HERE
                        ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OpenVraagVerbeter(
                            information: information,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Verbeter open vragen',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  Flexible(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(200, 120), //////// HERE
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayMap(
                                  latitude: information["lat"],
                                  longitude: information["lng"],
                                  key: null,
                                )),
                      );
                    },
                    child:
                        const Text('Zie kaart', style: TextStyle(fontSize: 22)),
                  )),
                  Flexible(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(200, 120),
                        maximumSize: const Size(200, 120) //////// HERE
                        ),
                    onPressed: () {},
                    child: const Text(
                      'Score opslaan',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ))
                ],
              ),
            )
          ],
        ));
  }
}
