import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/make_exam.dart';

class SetTime extends StatefulWidget {
  @override
  _SetTimeState createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> {

  var time = FirebaseFirestore.instance.collection('time');

  TimeOfDay? start;
  TimeOfDay? end;
  Future<void> _selectTime(BuildContext context, bool choice) async {
    final TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
          );
        },
    );

    if (t != null) {
      setState(() {
        if (choice) {
          start = t;
        } else {
          end = t;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Time'),
      ),
      body: ListView(
        children: <Widget>[
         Row(
          children: [
            ElevatedButton(
              onPressed: () => _selectTime(context,true),
              child: Text('Start Time'),
            ),
            start == null
                ? Text('Time not selected')
                : Text('Selected Time: ${start?.hour}:${start?.minute}'),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _selectTime(context, false),
              child: Text('End Time'),
            ),
            end == null
                ? Text('Time not selected')
                : Text('Selected Time: ${end?.hour}:${end?.minute}'),
          ],
        ),Container(
              padding: const EdgeInsets.fromLTRB(400, 120, 400, 15),
    child:
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(100, 80),
                  maximumSize: const Size(100, 80) //////// HERE
              ),
              onPressed: () {
                time.doc('time').set({
                  'start': '${start?.hour}:${start?.minute}',
                  'end': '${end?.hour}:${end?.minute}',
                }).then((value) {
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Makeexam() ));
                });
              },
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            )
          )]),
        
    );
  }
}