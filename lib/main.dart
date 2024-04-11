import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/firebase/establish_connection.dart';
import 'package:mw_project/login_page.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/objects/audio_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

SharedPreferences? _preferences;

Future<bool> _grabPrefs() async
{
  _preferences = await SharedPreferences.getInstance();
  if(_preferences!.getDouble("sfx") == null)
    {
      _preferences!.setDouble("sfx", 1.0);
    }
  if(_preferences!.getDouble("bgm") == null)
  {
    _preferences!.setDouble("bgm", 1.0);
  }

  AudioManager.createManager(sfxVolune: _preferences!.getDouble("sfx")!,
      bgmVolume: _preferences!.getDouble("bgm")!);
  return true;
}

class MainframeWarfareApp extends StatefulWidget {
  const MainframeWarfareApp({super.key});

  @override
  State<MainframeWarfareApp> createState() => _MainframeWarfareAppState();
}

class _MainframeWarfareAppState extends State<MainframeWarfareApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  @override
  void initState() {
    super.initState();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Flame.device.setLandscape();
  MainframeWarfare game = MainframeWarfare();
  _grabPrefs();
  runApp(MainframeWarfareApp());
}