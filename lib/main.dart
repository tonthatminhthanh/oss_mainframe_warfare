import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/firebase/establish_connection.dart';
import 'package:mw_project/login_page.dart';
import 'package:mw_project/mainframe_warfare.dart';

import 'firebase_options.dart';

class MainframeWarfareApp extends StatefulWidget {
  const MainframeWarfareApp({super.key});

  @override
  State<MainframeWarfareApp> createState() => _MainframeWarfareAppState();
}

class _MainframeWarfareAppState extends State<MainframeWarfareApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Silver'
      ),
      home: Scaffold(
        body: FirebaseConnectionPage(builder: (context) => LoginPage(),),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Flame.device.setLandscape();

  MainframeWarfare game = MainframeWarfare();

  runApp(MainframeWarfareApp());
}