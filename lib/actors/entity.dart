import 'package:flame/components.dart';

abstract class Entity extends PositionComponent
{
  void kill();
  void entityMovement();
  void loadAllAnimation();
  void loadAnimation(String name, int amount);
}