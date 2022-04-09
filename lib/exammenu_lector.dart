
import 'package:flutter/material.dart';

class ExammenuLector extends StatefulWidget {
  const ExammenuLector({Key? key}) : super(key: key);

  @override
  State<ExammenuLector> createState() => _ExammenuLectorState();
}

class _ExammenuLectorState extends State<ExammenuLector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Menu'),
      ),
      body: 
      Center(child: Row(
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
              minimumSize: const Size(200, 120),
              maximumSize: const Size(200, 120) //////// HERE
            ),
            onPressed: () {},
            child: const Text('Maak Examen', style: TextStyle(fontSize: 22)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shadowColor: Colors.greenAccent,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              minimumSize: const Size(200, 120), //////// HERE
            ),
            onPressed: () {},
            child: const Text('Verbeter Examen',style: TextStyle(fontSize: 22)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shadowColor: Colors.greenAccent,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              minimumSize: const Size(200, 120),
              maximumSize: const Size(200, 120) //////// HERE
            ),
            onPressed: () {},
            child: const Text('Studenten toevoegen',style: TextStyle(fontSize: 22), textAlign: TextAlign.center,),
          )
        ],
      ),)
    );
  }
}


