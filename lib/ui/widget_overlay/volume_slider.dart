import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/objects/audio_manager.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider({super.key});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Sound effects volume",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    color: Colors.white,fontSize: 16, fontFamily: "Silver")),
            ValueListenableBuilder(
              valueListenable: AudioManager.getSfxVolume(),
              builder: (context, value, child) => Slider(
                label: value.toString(),
                  value: value,
                  onChanged: (value) {
                    AudioManager.setSfxVolume(value);
                  },
              ),
            ),
            Text("Background music volume",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    color: Colors.white,fontSize: 16, fontFamily: "Silver")),
            ValueListenableBuilder(
              valueListenable: AudioManager.getBgmVolume(),
              builder: (context, value, child) => Slider(
                label: value.toString(),
                value: value,
                onChanged: (value) {
                  AudioManager.setBgmVolume(value);
                },
              ),
            ),
          ],
    );
  }
}
