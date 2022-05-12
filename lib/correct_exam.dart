import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/display_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<dynamic> getOpenQuestion() {
    var collection = FirebaseFirestore.instance.collection('taken');
    int score = 0;
    List<dynamic> opns = [];
    for (var item in information["answers"]) {
      if (item["type"] == "opn") {
        opns.add(item);
      } else {
        if (item["answer"].toString().trim().toLowerCase() ==
            item["studentAnswer"].toString().trim().toLowerCase()) {
          score++;
        }
      }
    }
    collection.doc(information["snummer"]).update({
      'score': score,
    });
    return opns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Correct Exam"),
      ),
      body: Column(
        children: [
          RaisedButton(
            child: Text("Show map"),
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
          ),
          RaisedButton(
            child: Text("Mark open questions"),
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
          )
        ],
      ),
    );
  }
}
