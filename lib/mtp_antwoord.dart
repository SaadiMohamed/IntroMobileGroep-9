import 'package:flutter/material.dart';


class MtpAntwoord extends StatefulWidget {
  MtpAntwoord({required Key? key, required this.question}) : super(key: key);
  var question;

  @override
  _MtpAntwoordState createState() => _MtpAntwoordState(question);
}

class _MtpAntwoordState extends State<MtpAntwoord> {
  var question;
  String answer ="";
  List<String> options = [];
  _MtpAntwoordState(this.question);

  @override
  void initState() {
    var test = question['options'].toString() + ";" + question['answer'].toString();
    options = test.split(";");
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
          Container(padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Center(child: Text(question['question'], style: const TextStyle(fontSize: 20),),)
      ),
      Center( child: Column(
        children:
        options.map((option) => RadioListTile(
          title: Text(option),
          value: option,
          groupValue: answer,
          onChanged: (value) {
            setState(() {
              answer = value.toString();
            });
          },
        )).toList(),
      ) ),
                Container(
                padding: const EdgeInsets.fromLTRB(400, 120, 400, 15),
                child: Center( child: ElevatedButton(
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
                   onPressed: () {  },
                  child: const Text("Save"),
                )))],
      )
      ,
    );
  }
}