import 'package:flutter/material.dart';

class Makeexam extends StatefulWidget {
  const Makeexam({Key? key}) : super(key: key);

  @override
  State<Makeexam> createState() => _MakeexamState();
}

class _MakeexamState extends State<Makeexam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies soort vraag'),
      ),
      body: Align(alignment: Alignment.bottomCenter, child: (Padding(padding: const EdgeInsets.all(20) , child: Row(
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
            onPressed: () {},
            child: const Text('Multiple choice', style: TextStyle(fontSize: 22)),
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
            child: const Text('Open vraag',style: TextStyle(fontSize: 22)),
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
            child: const Text('Code correctie',style: TextStyle(fontSize: 22), textAlign: TextAlign.center,),
          )
        ],
      ),
      )
    )
    )
    );
  }
}