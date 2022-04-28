import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:project/view_students.dart';

class AddStudents extends StatelessWidget {
  Widget manually(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add manually"),
      ),
    );
  }

  SpeedDial _speedDial(BuildContext context) {
    return SpeedDial(
      //child: Icon(Icons.add),
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 30),
      children: [
        SpeedDialChild(
            onTap: () {},
            child: const Icon(Icons.add),
            label: "Add manually",
            backgroundColor: Colors.red),
        SpeedDialChild(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewStudents()));
            },
            child: const Icon(Icons.people_alt_sharp),
            label: "View students",
            backgroundColor: Colors.orange)
      ],
    );
  }

  AddStudents({Key? key}) : super(key: key);
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  final TextEditingController _csvcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Studenten toevoegen'),
        ),
        body: ListView(children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 30),
            child: TextField(
                controller: _csvcontroller,
                keyboardType: TextInputType.multiline,
                maxLines: 35,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter csv',
                )),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(200, 100, 200, 30),
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
                  var add = true;
                  var studentsinfo = _csvcontroller.text.trim().split("\n");
                  for (var i in studentsinfo) {
                    if (i.split(",").length != 3) {
                      add = false;
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.of(context).pop(true);
                            });
                            return const CupertinoAlertDialog(
                              title: Text('Incomplete'),
                              content: Text(
                                  "Make sure every column has been fill in before submitting."),
                            );
                          });
                    }
                  }

                  if (add) {
                    studentsinfo.forEach((element) {
                      List<String> info = element.split(",");
                      students.add({
                        "snumber": info[0],
                        "firstname": info[1],
                        "lastname": info[2]
                      });
                    });
                  }
                },
                child: const Text('Submit', style: TextStyle(fontSize: 22)),
              )),
        ]),
        floatingActionButton: _speedDial(context));
  }
}