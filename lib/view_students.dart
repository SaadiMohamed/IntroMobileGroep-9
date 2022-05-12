import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/correct_exam.dart';

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
      result.add(data);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("View Students"),
        ),
        body: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CorrectExam(
                            information: students[index],
                            key: null,
                          ),
                        ),
                      );
                    },
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text("Name: " +
                        students[index]["firstname"] +
                        " " +
                        students[index]["lastname"]),
                    subtitle: Text("snummer: " + students[index]["snummer"])),
              );
            }));
  }
}
