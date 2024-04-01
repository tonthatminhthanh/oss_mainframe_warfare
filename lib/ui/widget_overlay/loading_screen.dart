import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/mainframe_warfare.dart';

class LoadingScreen extends StatelessWidget {
  static String ID = "LoadingScreen";
  MainframeWarfare gameRef;
  LoadingScreen({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.blue),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Loading...", style: TextStyle(fontSize: 24, decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal, color: Colors.black, fontFamily: "Silver"),)
            ],),
        )
      ],
    );
  }
}
