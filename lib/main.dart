import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/objects/audio_manager.dart';
import 'package:mw_project/pages/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  AudioManager.createManager(sfxVolume: _preferences!.getDouble("sfx")!,
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
        body: MainMenuPage(),
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
  Flame.device.setLandscape();
  _grabPrefs();
  runApp(MainframeWarfareApp());
}