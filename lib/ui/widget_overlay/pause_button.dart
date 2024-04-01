import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/ui/widget_overlay/pause_menu.dart';

class PauseButton extends StatelessWidget {
  static const String ID = "PauseButton";
  final MainframeWarfare gameRef;
  const PauseButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(Icons.pause, color: Colors.white,),
        onPressed: () {
          gameRef.pauseEngine();
          FlameAudio.bgm.pause();
          gameRef.overlays.add(PauseMenu.ID);
        },
      ),
    );
  }
}
