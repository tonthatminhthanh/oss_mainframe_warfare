import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/mainframe_warfare.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();

  MainframeWarfare game = MainframeWarfare();

  runApp(GameWidget(game: kDebugMode ? MainframeWarfare() : game));
}