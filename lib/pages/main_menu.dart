import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mw_project/mainframe_warfare.dart';

import '../login_page.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome back,"
                " ${FirebaseAuth.instance.currentUser!.displayName}"
              , style: TextStyle(fontSize: 32),),
            Expanded(
              child: Image.network(FirebaseAuth.instance.currentUser!.photoURL!
                , width: 150, height: 150,),
            ),
            ElevatedButton(
                onPressed: () {
                  MainframeWarfare game = MainframeWarfare();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder:
                          (context) => GameWidget(game: kDebugMode ? MainframeWarfare() : game),
                      )
                  );
                },
                child: Text("Play!")
            ),
            Align(child: Container(
              child: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage(),)
                  );
                },
              ),
            ), alignment: Alignment.bottomLeft,)
          ],
        ),
      ),
    );
  }
}
