import 'package:flutter/material.dart';

import 'overview.dart';

class CodeCorrection extends StatefulWidget {
  CodeCorrection(
      {required Key? key,
      required this.questions,
      required this.index,
      required this.snummer})
      : super(key: key);
  var questions;
  final int index;
  final String snummer;

  @override
  _CodeCorrectionState createState() =>
      _CodeCorrectionState(questions, index, snummer);
}

class _CodeCorrectionState extends State<CodeCorrection> {
  var questions;
  final int index;
  final String snummer;

  _CodeCorrectionState(this.questions, this.index, this.snummer);
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
          title: const Text('Code correction vraag'),
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
