import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/foundation.dart';
import 'package:mw_project/actors/computers/power_supply.dart';
import 'package:mw_project/actors/directors/match_director.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/levels/level.dart';

import 'actors/placeable_entity.dart';

class MainframeWarfare extends FlameGame with HasCollisionDetection
{
  double screenWidth = SCREEN_WIDTH as double;
  double screenHeight = SCREEN_HEIGHT as double;
  late CameraComponent cam;
  late MatchDirector _director;
  
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
    await images.loadAllImages();
    
    _director = MatchDirector(defenderMoney: ValueNotifier(125));
    cam = CameraComponent.withFixedResolution(
        world: world,
        width: screenWidth,
        height: screenHeight
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world, _director]);
    return super.onLoad();
  }

  Level getLevel()
  {
    return world as Level;
  }
}