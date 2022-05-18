import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'open_vraag_verbeter.dart';

class MarkOpenQuestion extends StatefulWidget {
  MarkOpenQuestion({Key? key, required this.information, required this.index})
      : super(key: key);
  var information;
  final int index;

  @override
  State<StatefulWidget> createState() => _MarkOpenQuestion(information, index);
}

class _MarkOpenQuestion extends State<MarkOpenQuestion> {
  _MarkOpenQuestion(this.information, this.index);
  var information;
  final int index;
  @override
  Widget build(BuildContext context) {
    TextEditingController score = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Open vraag verbeteren"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Text(information["opns"][index]["question"]),
              Text(information["opns"][index]["studentAnswer"]),
              Text(
                  "Max score: " + information["opns"][index]["max"].toString()),
              TextField(
                controller: score,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Score",
                ),
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () {
                  information["opns"][index]["score"] = int.parse(score.text);
                  information["opns"][index]["done"] = true;
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OpenVraagVerbeter(
                          information: information,
                        ),
                      ));
                },
              )
            ],
          ),
        ));
  }
}
