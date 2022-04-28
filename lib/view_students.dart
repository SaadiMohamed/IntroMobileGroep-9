import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewStudents extends StatefulWidget{
  const ViewStudents({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _ViewStudents();

}

class _ViewStudents extends State<ViewStudents>{

  @override
  initState()  {
    super.initState();
    fetch();
  }

  List students = [];

  fetch() async{
    dynamic result = await getStudents();
    if(result != null) {
      setState(() {
        students = result;
      });
    } else {
      print("unable to retrieve");
    }
  }
  Future getStudents() async {
    var collection = FirebaseFirestore.instance.collection('students');
    var querySnapshot = await collection.get();
    var result = [];
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
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
                  leading: const CircleAvatar(
                    child: Icon(Icons.person)
                  ),
                    title: Text("Name: "+students[index]["firstname"] + " " + students[index]["lastname"]),
                    subtitle: Text("snummer: " + students[index]["snumber"])
                ),
              );
            })
    );
  }

}