import 'package:flutter/material.dart';

class MainscreenStudent extends StatefulWidget {
  const MainscreenStudent({Key? key}) : super(key: key);

  @override
  State<MainscreenStudent> createState() => _MainscreenStudentState();
}

class _MainscreenStudentState extends State<MainscreenStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You are logged in as a student',
            ),
          ],
        ),
      ),
    );
  }
}
