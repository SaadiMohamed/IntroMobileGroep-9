import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/multiplechoice.dart';

class Makeexam extends StatefulWidget {
  const Makeexam({Key? key}) : super(key: key);

  @override
  State<Makeexam> createState() => _MakeexamState();
}

class _MakeexamState extends State<Makeexam> {
  @override
   initState()  {
    super.initState();
    fetch();
  }

   List questions = [];

  fetch() async{
    dynamic result = await getquestions();
    if(result != null) {
      setState(() {
        questions = result;
      });

    } else {
      print("unable to retrieve");
    }
  }
  Future getquestions() async {
    var collection = FirebaseFirestore.instance.collection('questions');
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
        title: const Text('Kies soort vraag'),
      ),
      body: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text("Question: "+questions[index]["question"]),
                subtitle: Text("Answer: " + questions[index]["answer"])
              ),
            );
          }),
      floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: (Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(200, 80),
                      maximumSize: const Size(200, 80) //////// HERE
                      ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultipleChoice()));
                  },
                  child: const Text('Multiple choice',
                      style: TextStyle(fontSize: 22)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.greenAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: const Size(200, 80), //////// HERE
                  ),
                  onPressed: () {},
                  child:
                      const Text('Open vraag', style: TextStyle(fontSize: 22)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(200, 80),
                      maximumSize: const Size(200, 80) //////// HERE
                      ),
                  onPressed: () {},
                  child: const Text(
                    'Code correctie',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ))),
    );
  }
}
