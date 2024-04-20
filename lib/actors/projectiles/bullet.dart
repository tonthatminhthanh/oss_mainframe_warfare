import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/projectile.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/constants/default_config.dart';

class Bullet extends Projectile
{
  Bullet({required Vector2 startingPosition, String name = "bullet",
    int damage = BASIC_BULLET_DAMAGE, Team myTeam = Team.defender})
      : _myTeam = myTeam,
        super(name: name,damage: damage, myTeam: myTeam,
          startingPosition: startingPosition);
  Team _myTeam;
  Vector2 _velocity = Vector2.zero();
  double _moveSpeed = BASIC_BULLET_SPEED as double;

  @override
  void onLoad()
  {
    setHitbox(RectangleHitbox(
        collisionType: CollisionType.passive,
        size: Vector2.all(16)));
    addHitbox();
    super.onLoad();
  }

  @override
  void movement(double dt) {
    // TODO: implement movement
    if(_myTeam == Team.defender)
      {
        _velocity.x = _moveSpeed;
      }
    else
      {
        _velocity.x = -_moveSpeed;
      }
    position = Vector2(position.x + (_velocity.x * dt) , position.y);
  }
}