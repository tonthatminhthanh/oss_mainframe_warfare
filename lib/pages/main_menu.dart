import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
<<<<<<< Updated upstream
<<<<<<< Updated upstream
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/pages/leaderboard.dart';
import 'package:mw_project/ui/widget_overlay/defenders_selection.dart';
import 'package:mw_project/ui/widget_overlay/game_over.dart';
import 'package:mw_project/ui/widget_overlay/loading_screen.dart';
import 'package:mw_project/ui/widget_overlay/pause_button.dart';
import 'package:mw_project/ui/widget_overlay/pause_menu.dart';
=======
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';
>>>>>>> Stashed changes
=======
import 'package:intl/intl.dart';
import 'package:mw_project/ui/widget_overlay/wave_display.dart';
import 'package:timer_builder/timer_builder.dart';
>>>>>>> Stashed changes

import '../login_page.dart';
import '../mainframe_warfare.dart';
import '../ui/widget_overlay/defenders_selection.dart';
import '../ui/widget_overlay/game_over.dart';
import '../ui/widget_overlay/loading_screen.dart';
import '../ui/widget_overlay/pause_button.dart';
import '../ui/widget_overlay/pause_menu.dart';
import 'leaderboard.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            _createTaskbar(context),
            _createDesktop(context),
          ],
      ),
    );
  }

  Widget _createDesktop(BuildContext context)
  {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background/wallpaper.jpg"),
              fit: BoxFit.fill
          ),
        ),
        child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                ),
                Stack(
                  children: [
                    IconButton(icon: Icon(Icons.play_circle, color: Colors.green, size: 64,),
                        onPressed: () {
                          MainframeWarfare game = MainframeWarfare();
                          FlameAudio.bgm.initialize();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
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
                                WaveDisplay.ID: (BuildContext context, MainframeWarfare gameRef) => WaveDisplay(),
                              },
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                          ),
                      )
                  );
                },
                child: Text("Play!", style: TextStyle(fontFamily: "Silver"),)
            ),
            Text("Developed by Tôn Thất Minh Thành. Font made by Poppy Works.", style: TextStyle(fontFamily: "Silver"),),
            Align(
              child: Row(
                children: [
                  Container(
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
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.book),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LeaderboardPage(),)
                        );
                      },
                    ),
                  ),
                ],
              ),
              alignment: Alignment.bottomLeft,)
          ],
=======
=======
>>>>>>> Stashed changes
                            ),
                          )
                          );
                        },
                    ),
                    Positioned(
                      left: 4,
                      bottom: -5,
                      child: Text("Play", style: TextStyle(
                        fontFamily: "Silver", fontSize: 16, decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal, color: Colors.white),),)
                  ],
                ),
                Stack(
                  children: [
                    IconButton(icon: Icon(Icons.book, color: Colors.blueAccent, size: 64,),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: (context) => LeaderboardPage(),)
                        );
                      },
                    ),
                    Positioned(
                      left: 4,
                      bottom: -5,
                      child: Text("Leaderboard", style: TextStyle(
                          fontFamily: "Silver", fontSize: 16, decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal, color: Colors.white),),)
                  ],
                ),
              ],
            )
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        ),
      ),
    );
  }

  Widget _createTaskbar(BuildContext context)
  {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      decoration: BoxDecoration(
        color: Colors.indigo
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.indigo
                      ),
                      child: Row(
                                        children: [
                      Text(FirebaseAuth.instance.currentUser!.displayName!
                        , style: TextStyle(fontSize: 16, fontFamily: "Silver"),),
                      Image.network(FirebaseAuth.instance.currentUser!.photoURL!
                                        , width: 32, height: 32,),
                                        ],
                                      ),
                    )),
                PopupMenuItem(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.logout_outlined, color: Colors.deepPurpleAccent, size: 16,),
                            Text("Log out"
                              , style: TextStyle(fontSize: 16, fontFamily: "Silver", color: Colors.black),),
                          ],
                        ),
                      ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    GoogleSignIn().signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage(),)
                    );
                  },
                ),
                PopupMenuItem(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.close, color: Colors.red, size: 16,),
                        Text("Shut down"
                          , style: TextStyle(fontSize: 16, fontFamily: "Silver", color: Colors.black),),
                      ],
                    ),
                  ),
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
              ];
            },
            icon: Icon(Icons.adb, color: Colors.green, size: 24,),
          ),
          Expanded(
            child: Container(
            ),
          ),
          TimerBuilder.periodic(Duration(seconds: 1),
              builder: (context) {
                DateTime now = DateTime.now();
                String formattedDate = DateFormat('dd-MM-yyyy kk:mm').format(now);
                return Text("$formattedDate", style: TextStyle(
                    fontFamily: "Silver", fontSize: 24, decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal, color: Colors.white),);
              }
          )
        ],
      ),
    );
  }
}
