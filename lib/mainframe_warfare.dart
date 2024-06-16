import 'dart:async';
import 'dart:io';

import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:mw_project/actors/directors/match_director.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/levels/level.dart';
import 'package:mw_project/objects/audio_manager.dart';
import 'actors/placeable_entity.dart';

class MainframeWarfare extends FlameGame with HasCollisionDetection
{
  double screenWidth = SCREEN_WIDTH as double;
  double screenHeight = SCREEN_HEIGHT as double;
  late CameraComponent cam;
  late MatchDirector _director;
  bool _justAdded = false;
  
  MatchDirector getDirector()
  {
    return _director;
  }

  RaycastResult? getRaycastResult(Ray2 ray, Team myTeam, double maxDistance)
  {
    final result = collisionDetection.raycast(ray,
      maxDistance: maxDistance,
      hitboxFilter: (candidate) {
        var candidateParent = candidate.parent;
        if(candidateParent is PlaceableEntity)
        {
          if(candidateParent.getTeam() != myTeam)
          {
            return true;
          }
          else
          {
            return false;
          }
        }
        else
        {
          return false;
        }
      },
    );

    return result;
  }

  @override
  final world = Level(levelName: 'level');

  @override
  FutureOr<void> onLoad() async {
    await FlameAudio.audioCache.loadAll([
      "sfx/death.wav",
      "sfx/explosion_1.wav",
      "sfx/explosion_2.wav",
      "sfx/game_over.mp3",
      "sfx/pickup_1.wav",
      "sfx/pickup_2.wav",
      "sfx/pickup_3.wav",
      "sfx/pickup_4.wav",
      "sfx/powerup.wav",
    ]);

    AudioManager.loadSfxPool();
    await images.loadAllImages();
    
    _director = MatchDirector(defenderMoney: ValueNotifier(100));
    cam = CameraComponent.withFixedResolution(
        world: world,
        width: screenWidth,
        height: screenHeight
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.priority = 10;
    world.priority = 1;
    addAll([cam, world, _director]);
    return super.onLoad();
  }

  Level getLevel()
  {
    return world as Level;
  }
}