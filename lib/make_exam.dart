import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/code_correction.dart';
import 'package:project/multiplechoice.dart';
import 'package:project/open.dart';
import 'package:project/set_time.dart';

class Makeexam extends StatefulWidget {
  const Makeexam({Key? key}) : super(key: key);

  @override
  State<Makeexam> createState() => _MakeexamState();
}

class _MakeexamState extends State<Makeexam> {
  var options = [
    Text(""),
    OpenQuestion(),
    MultipleChoice(),
    CodeCorrection(),
    SetTime()
  ];

  @override
  initState() {
    super.initState();
    fetch();
  }

  List questions = [];

  fetch() async {
    dynamic result = await getquestions();
    if (result != null) {
      setState(() {
        questions = result[0];
        takenexam = result[1];
      });
    } else {
      print("unable to retrieve");
    }
  }

  List takenexam = [];
  Future takenexamen() async {
    var collection = FirebaseFirestore.instance.collection("taken");
    var querySnapshot = await collection.get();
    var result = [];
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      data['id'] = queryDocumentSnapshot.id;
      result.add(data);
    }
    return result;
  }

  Future getquestions() async {
    var collection = FirebaseFirestore.instance.collection('questions');
    var querySnapshot = await collection.get();
    var result = [];
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      data['id'] = queryDocumentSnapshot.id;
      result.add(data);
    }

    var collection2 = FirebaseFirestore.instance.collection("taken");
    var querySnapshot2 = await collection2.get();
    var result2 = [];
    for (var queryDocumentSnapshot in querySnapshot2.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      data['id'] = queryDocumentSnapshot.id;
      result2.add(data);
    }
    return [result, result2];
  }

  Widget main(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make Exam"),
      ),
      floatingActionButton: questions.isEmpty
          ? null
          : ElevatedButton(
              child: const Text("Delete all"),
              onPressed: () {
                var collection =
                    FirebaseFirestore.instance.collection('questions');

                for (var item in questions) {
                  collection.doc(item['id']).delete();
                }

                var done = FirebaseFirestore.instance.collection('done');
                var taken = FirebaseFirestore.instance.collection('taken');
                Map<String, dynamic> all = {};
                for (var item in takenexam) {
                  all[item['id']] = {
                    'firstname': item['firstname'],
                    'lastname': item['lastname'],
                    'score': item['score'],
                    'total': item['total'],
                  };
                  taken.doc(item['id']).delete();
                }
                if (all.length > 0) {
                  done.add(all);
                }

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Makeexam()));
              }),
      body: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text("Question: " + questions[index]["question"]),
                subtitle: questions[index]["type"] != 'opn'
                    ? Text("Answer: " + questions[index]["answer"])
                    : const Text("This is an open question"),
              ),
            );
          }),
    );
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          backgroundColor: Colors.blue,
          currentIndex: _currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "View questions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              label: 'Open question',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              label: "Multiple choice",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.code),
              label: "Code correction",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: "Set time",
            ),
          ],
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ), // ,
        body: FutureBuilder(
            future: getquestions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_currentIndex == 0) {
                  return main(context);
                }
                return options[_currentIndex];
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
