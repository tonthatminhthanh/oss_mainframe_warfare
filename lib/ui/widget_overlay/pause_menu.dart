import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/objects/audio_manager.dart';
import 'package:mw_project/pages/main_menu.dart';
import 'package:mw_project/ui/widget_overlay/pause_button.dart';
import 'package:mw_project/ui/widget_overlay/volume_slider.dart';
import 'package:mw_project/ui/widget_overlay/wave_display.dart';

class PauseMenu extends StatelessWidget {
  static String ID = "PauseMenu";
  MainframeWarfare gameRef;
  PauseMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Paused", style: TextStyle(fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: Colors.white,fontSize: 50, fontFamily: "Silver")),
            SizedBox(height: 20,),
            Expanded(child: VolumeSlider()),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () {
                  gameRef.resumeEngine();
                  if(AudioManager.bgmAudioAdjusted())
                    {
                      FlameAudio.bgm.play('bgm/deepdive.wav', volume: AudioManager.getBgmVolume().value);
                    }
                  else
                    {
                      FlameAudio.bgm.resume();
                    }
                  gameRef.overlays.remove(PauseMenu.ID);
                  gameRef.overlays.add(PauseButton.ID);
                },
                child: Text("Resume")
            ),
            SizedBox(height: 5,),
            ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(PauseMenu.ID);
                  gameRef.overlays.remove(WaveDisplay.ID);
                  FlameAudio.bgm.dispose();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainMenuPage(),)
                  );
                },
                child: Text("Main menu")
            ),
          ],
        ),
      ),
    );
  }
}
