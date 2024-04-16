import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mw_project/objects/match_result.dart';

class WaveDisplay extends StatelessWidget {
  static String ID = "WaveDisplay";
  WaveDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: MatchResult.getResult().mainWavesCount,
            builder: (context, value, child) {
                return Text(
                "Main wave: $value ", style: TextStyle(
    fontFamily: "Silver", fontSize: 24, decoration: TextDecoration.none,
    fontWeight: FontWeight.normal, color: Colors.white),);
              },),
            ValueListenableBuilder(
              valueListenable: MatchResult.getResult().wavesCount,
              builder: (context, value, child) {
                return Text("Wave: ${MatchResult.getResult().wavesCount.value}/20", style: TextStyle(
                    fontFamily: "Silver", fontSize: 24, decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal, color: Colors.white),);
          },)
        ],
      )
    );
  }
}
