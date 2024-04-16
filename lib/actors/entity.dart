import 'dart:async';

import 'package:flame/components.dart';
import 'package:mw_project/mainframe_warfare.dart';

abstract class Entity extends SpriteAnimationGroupComponent
    with HasGameRef<MainframeWarfare>
{
  //Kiểm tra HP của entity
  void checkHealth();
  //Di chuyển entity
  void entityMovement(double dt);
  //Load các animations
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
  //load anim cá nhân
  SpriteAnimation loadAnimation(String name, int amount, double stepTime, bool loop);
}