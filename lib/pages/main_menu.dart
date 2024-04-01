import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/ui/widget_overlay/defenders_selection.dart';
import 'package:mw_project/ui/widget_overlay/game_over.dart';
import 'package:mw_project/ui/widget_overlay/loading_screen.dart';
import 'package:mw_project/ui/widget_overlay/pause_button.dart';
import 'package:mw_project/ui/widget_overlay/pause_menu.dart';

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
              , style: TextStyle(fontSize: 32, fontFamily: "Silver"),),
            Expanded(
              child: Image.network(FirebaseAuth.instance.currentUser!.photoURL!
                , width: 150, height: 150,),
            ),
            ElevatedButton(
                onPressed: () {
                  MainframeWarfare game = MainframeWarfare();
                  FlameAudio.bgm.initialize();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => GameWidget(
                              game: kDebugMode ? MainframeWarfare() : game,
                              initialActiveOverlays: [
                                PauseButton.ID
                              ],
                              overlayBuilderMap: {
                                LoadingScreen.ID: (BuildContext context, MainframeWarfare gameRef) => LoadingScreen(gameRef: gameRef,),
                                DefenderSelection.ID: (BuildContext context, MainframeWarfare gameRef) => DefenderSelection(gameRef: gameRef,),
                                PauseButton.ID: (BuildContext context, MainframeWarfare gameRef) => PauseButton(gameRef: gameRef,),
                                PauseMenu.ID: (BuildContext context, MainframeWarfare gameRef) => PauseMenu(gameRef: gameRef,),
                                GameOverMenu.ID: (BuildContext context, MainframeWarfare gameRef) => GameOverMenu(gameRef: gameRef,),
                              },
                          ),
                      )
                  );
                },
                child: Text("Play!", style: TextStyle(fontFamily: "Silver"),)
            ),
            Text("Developed by Tôn Thất Minh Thành. Font made by Poppy Works.", style: TextStyle(fontFamily: "Silver"),),
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

  @override
  void initState() {
    super.initState();
  }
}
