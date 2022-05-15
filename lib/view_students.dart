import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/correct_exam.dart';
import 'package:project/exammenu_lector.dart';

class ViewStudents extends StatefulWidget {
  const ViewStudents({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewStudents();
}

class _ViewStudents extends State<ViewStudents> {
  @override
  initState() {
    super.initState();
    fetch();
  }

  List students = [];

  fetch() async {
    dynamic result = await getStudents();
    if (result != null) {
      setState(() {
        students = result;
      });
    } else {
      print("unable to retrieve");
    }
  }

  Future getStudents() async {
    var collection = FirebaseFirestore.instance.collection('taken');
    var querySnapshot = await collection.get();
    var result = [];
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      data["snummer"] = queryDocumentSnapshot.id;
      if (data["done"] != true) {
        result.add(data);
        print(data["score"]);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getStudents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Studenten"),
                  ),
                  body: students.isEmpty
                      ? Center(
                          child: Container(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                shadowColor: Colors.greenAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: const Size(200, 150),
                                maximumSize: const Size(200, 150) //////// HERE
                                ),
                            child: const Text(
                              "Go back",
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ExammenuLector(key: null)));
                            },
                          ),
                        ))
                      : ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                  onTap: students[index]["done"] == null ||
                                          students[index]["done"] == false
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CorrectExam(
                                                information: students[index],
                                                key: null,
                                              ),
                                            ),
                                          );
                                        }
                                      : () {
                                          print(students[index]["done"]);
                                        },
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.person)),
                                  title: Text("Naam: " +
                                      students[index]["firstname"] +
                                      " " +
                                      students[index]["lastname"]),
                                  subtitle: Text("s-nummer: " +
                                      students[index]["snummer"])),
                            );
                          }));
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
