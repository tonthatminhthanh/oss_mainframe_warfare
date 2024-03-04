import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/mainframe_warfare.dart';

abstract class Entity extends SpriteAnimationGroupComponent
    with HasGameRef<MainframeWarfare>
{
  void checkHealth();
  void entityMovement(double dt);
  void loadAllAnimation();

  void setPosition(Vector2 myPos)
  {
    position = Vector2(myPos.x, myPos.y);
  }

  @override
  FutureOr<void> onLoad() {
    loadAllAnimation();
    super.onLoad();
  }

  SpriteAnimation loadAnimation(String name, int amount, double stepTime, bool loop);
}