import 'package:flutter/material.dart';
import 'package:project/overview.dart';
import 'package:project/start_exam.dart';

class OpenAntwoord extends StatefulWidget {
  OpenAntwoord(
      {required Key? key,
      required this.questions,
      required this.snummer,
      required this.index})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var questions;
  final String snummer;
  final int index;

  @override
  _OpenAntwoordState createState() =>
      _OpenAntwoordState(questions, snummer, index);
}

class _OpenAntwoordState extends State<OpenAntwoord> {
  var questions;
  final int index;
  final String snummer;
  _OpenAntwoordState(this.questions, this.snummer, this.index);
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = questions[index]['studentAnswer'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Open vraag'),
          automaticallyImplyLeading: false,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Overview(
                                snummer: snummer,
                                key: null,
                                questions: questions,
                              )),
                    );
                  },
                  child: const Text("Save"),
                )))
          ],
        ));
  }
}
