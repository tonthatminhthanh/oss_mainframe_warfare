import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/objects/match_result.dart';
import 'package:mw_project/pages/main_menu.dart';
import 'package:mw_project/pages/share_result.dart';

import '../../objects/audio_manager.dart';

class GameOverMenu extends StatefulWidget {
  MainframeWarfare gameRef;
  static String ID = "GameOverMenu";
  GameOverMenu({super.key, required MainframeWarfare this.gameRef});

  @override
  State<GameOverMenu> createState() => _GameOverMenuState();
}

class _GameOverMenuState extends State<GameOverMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ShareResultPage(wavesCount: MatchResult.getResult().wavesCount),)
        );
      },
      child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background/bsod.png"),
                  fit: BoxFit.fill
              ),
            ),
      ),
    );
  }

  @override
  void initState() {
    removeSaveFile();
    widget.gameRef.pauseEngine();
    FlameAudio.play("sfx/game_over.mp3",
        volume: AudioManager.getSfxVolune());
    super.initState();
    FlameAudio.bgm.stop();
  }

  void removeSaveFile() async
  {
    String currentId = FirebaseAuth.instance.currentUser!.uid;
    final saveRef = FirebaseStorage.instance.ref().child("saves/$currentId.json");
    bool hasError = false;

    await saveRef.getData().catchError((err) {hasError = true;});
    if(!hasError)
    {
      await saveRef.delete();
    }
  }
}
