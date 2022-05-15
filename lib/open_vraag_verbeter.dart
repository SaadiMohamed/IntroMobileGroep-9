import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/correct_exam.dart';
import 'package:project/mark_open_question.dart';
import 'package:project/view_students.dart';

class OpenVraagVerbeter extends StatefulWidget {
  OpenVraagVerbeter({Key? key, required this.information}) : super(key: key);
  var information;

  @override
  State<StatefulWidget> createState() => _OpenVraagVerbeter(information);
}

class _OpenVraagVerbeter extends State<OpenVraagVerbeter> {
  _OpenVraagVerbeter(this.information);
  var information;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verbeter open vragen"),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () async {
            var collection = FirebaseFirestore.instance.collection('taken');
            int score = int.parse(information["score"].toString());
            int total = int.parse(information["total"].toString());
            for (var item in information["opns"]) {
              score += int.parse(item["score"].toString());
              total += int.parse(item["max"].toString());
            }
            collection.doc(information["snummer"]).update({'score': score});
            collection.doc(information["snummer"]).update({'total': total});
            collection.doc(information["snummer"]).update({'done': true});
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewStudents(key: null)));
          },
          child: const Text("Indienen"),
        ),
        body: ListView.builder(
          itemCount: information["opns"].length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                    trailing: information["opns"][index]["done"] != false
                        ? const Icon(Icons.check)
                        : const Icon(Icons.close),
                    iconColor: information["opns"][index]["done"] != false
                        ? Colors.green
                        : Colors.red,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MarkOpenQuestion(
                              information: information,
                              index: index,
                            ),
                          ));
                    },
                    title: Text(information["opns"][index]["question"]),
                    subtitle: Text(
                      "answer: " + information["opns"][index]["studentAnswer"],
                      style: const TextStyle(fontSize: 15),
                    )));
          },
        ));
  }
}
