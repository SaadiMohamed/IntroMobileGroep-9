import 'package:flutter/material.dart';

class CodeCorrection extends StatefulWidget {
  CodeCorrection({required Key? key, required this.question}) : super(key: key);
  var question;

  @override
  _CodeCorrectionState createState() => _CodeCorrectionState(question);
}


class _CodeCorrectionState extends State<CodeCorrection> {
  var question;
  _CodeCorrectionState(this.question);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: const Text('Code correction'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0,100, 0, 0),
            child: Center( child: Text(question['question'], style: const TextStyle(fontSize: 20))),
          ),
              Container(
                  padding: const EdgeInsets.fromLTRB(100,50,100,0),
                  child: const Center( child: TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.edit, color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Verbeter de code hier',
                    ),
                  )),
                ),
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
                )))
        ],
        
      ));
  }
  

}
