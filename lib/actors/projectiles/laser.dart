import 'package:flame/components.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/actors/projectile.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/constants/team.dart';

class Laser extends Projectile
{
  Vector2 _startingPos;
  Vector2 _velocity = Vector2.zero();
  double _moveSpeed = BASIC_BULLET_SPEED as double;
  int _damage;

  Laser({super.name = "laser", required super.startingPosition, super.myTeam = Team.defender
    , super.damage = BASIC_BULLET_DAMAGE})
  : _startingPos = startingPosition, _damage = damage;

  @override
  void movement(double dt) {
    if(position.x <= _startingPos.x + (TILE_SIZE * 3))
      {
        _velocity.x = _moveSpeed;
        position = Vector2(position.x + (_velocity.x * dt) , position.y);
      }
    else
      {
        removeFromParent();
      }
  }

  @override
  void attack(PlaceableEntity entity)
  {
    entity.getAttacked(_damage);
  }
}