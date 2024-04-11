import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/actors/projectile.dart';
import 'package:mw_project/constants/default_config.dart';
<<<<<<< Updated upstream
import 'package:mw_project/particles/explosion.dart';
=======

import '../particles/explosion.dart';
>>>>>>> Stashed changes

class CannonBall extends Projectile
{
  Vector2 _velocity = Vector2.zero();
  double _moveSpeed = BASIC_BULLET_SPEED as double;

  CannonBall({super.name = "cannon_ball", required super.startingPosition, super.myTeam = Team.defender
    , super.damage = BASIC_LASER_DAMAGE});

  @override
  void onLoad()
  {
    setHitbox(RectangleHitbox(size: Vector2.all(64)));
    addHitbox();
    super.onLoad();
  }

  @override
  void movement(double dt) {
    _velocity.x = _moveSpeed;
    position = Vector2(position.x + (_velocity.x * dt) , position.y);
  }

  @override
  void attack(PlaceableEntity entity)
  {
    game.world.add(Explosion(myPosition: Vector2(position.x, position.y - 32)
        , size: ExplosionSize.big, myTeam: Team.defender));
    removeFromParent();
  }
}