import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:mw_project/actors/computers/power_supply.dart';
import 'package:mw_project/actors/directors/match_director.dart';
import 'package:mw_project/components/team.dart';
import 'package:mw_project/levels/level.dart';

class MainframeWarfare extends FlameGame with HasCollisionDetection
{
  late CameraComponent cam;
  late MatchDirector director;
  
  MatchDirector getDirector()
  {
    return director;
  }
  
  @override
  final world = Level(levelName: 'level');

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    
    director = MatchDirector(defenderMoney: ValueNotifier(125));
    cam = CameraComponent.withFixedResolution(
        world: world,
        width: 1280,
        height: 768
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world, director]);

    return super.onLoad();
  }
}