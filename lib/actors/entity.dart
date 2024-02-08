import 'package:flame/components.dart';
import 'package:mw_project/mainframe_warfare.dart';

abstract class Entity extends SpriteAnimationGroupComponent with HasGameRef<MainframeWarfare>
{
  void kill();
  void entityMovement();
  void loadAllAnimation();

  void setPosition(Vector2 myPos)
  {
    position = Vector2(myPos.x, myPos.y);
  }

  SpriteAnimation loadAnimation(String name, int amount, double stepTime, bool loop);
}