import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mw_project/login_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.network(FirebaseAuth.instance.currentUser!.photoURL!),
          Text(FirebaseAuth.instance.currentUser!.displayName!),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage(),)
                );
              },
              child: Text("Log out")
          )
        ],
      ),
    );
  }
}
