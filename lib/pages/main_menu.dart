import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mw_project/pages/achievements_page.dart';
import 'package:mw_project/pages/settings_page.dart';
import 'package:mw_project/ui/widget_overlay/wave_display.dart';
import 'package:timer_builder/timer_builder.dart';
import 'login_page.dart';
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
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background/wallpaper.jpg"),
              fit: BoxFit.fill
          ),
        ),
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
                              game: game,
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
                Stack(
                  children: [
                    IconButton(icon: Icon(Icons.wallet_giftcard_rounded, color: Colors.yellowAccent, size: 64,),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: (context) => AchievementsPage(),)
                        );
                      },
                    ),
                    Positioned(
                      left: 4,
                      bottom: -5,
                      child: Text("Achievements", style: TextStyle(
                          fontFamily: "Silver", fontSize: 16, decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal, color: Colors.white),),)
                  ],
                ),
              ],
            )
      );
  }

  Widget _createTaskbar(BuildContext context)
  {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
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
                                        , width: 64, height: 64,),
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
            icon: Icon(Icons.adb, color: Colors.green, size: 32,),
          ),
          IconButton(
            icon: Icon(Icons.settings, size: 32,),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SettingsPage(),)
              );
            },
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
