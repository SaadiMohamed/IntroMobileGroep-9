
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/correct_exam.dart';

class OpenVraagVerbeter extends StatefulWidget {
  OpenVraagVerbeter({Key? key, required this.questions}) : super(key: key);
  var questions;

  @override
  State<StatefulWidget> createState() => _OpenVraagVerbeter(questions);
}

class _OpenVraagVerbeter extends State<OpenVraagVerbeter> {
  _OpenVraagVerbeter(this.questions);
  var questions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verbeter open vragen"),
        ),
        body: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    onTap: () {
                    },
                    title: Text(questions[index]["question"]),
                    subtitle: Text("answer: " + questions[index]["studentAnswer"], style: const TextStyle(fontSize: 15),) ));},
        )
    );
            }
  }
