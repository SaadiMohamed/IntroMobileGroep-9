import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/exammenu_lector.dart';

class MainscreenLector extends StatefulWidget {
  const MainscreenLector({Key? key}) : super(key: key);

  @override
  State<MainscreenLector> createState() => _MainscreenLectorState();
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  static Future<User?> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("Wrong credentials");
      }
    }
    return user;
  }

  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _usernamecontroller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail, color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Gebruikersnaam',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
              child: TextField(
                controller: _passwordcontroller,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                  border: OutlineInputBorder(),
                  labelText: 'Wachtwoord',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    User? user = await login(
                        email: _usernamecontroller.text.trim(),
                        password: _passwordcontroller.text.trim(),
                        context: context);
                    if (user != null) {
                      Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExammenuLector(),
                            ),
                          );
                    }
                  },
                )),
          ],
        ));
  }
}

class _MainscreenLectorState extends State<MainscreenLector> {
  Future<FirebaseApp> _initializeFireBaseApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Login());
  }
}
