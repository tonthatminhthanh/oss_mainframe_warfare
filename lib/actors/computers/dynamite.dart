import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/constants/default_config.dart';

import '../../particles/explosion.dart';

class Dynamite extends PlaceableEntity
{
  late SpriteAnimation _idleAnimation;
  late Timer _explodeTimer;

  Dynamite({Team myTeam = Team.defender, double rechargeTime = VERY_SLOW_RECHARGE})
      : super(characterName: "dynamite",
      hp: TEST_DUMMY_HP, myTeam: myTeam, rechargeTime: rechargeTime, cost: 150);

  @override
  PlaceableEntity clone() {
    // TODO: implement clone
    return Dynamite();
  }

  @override
  void onLoad()
  {
    loadAllAnimation();
    _explodeTimer = Timer(1, repeat: false);
    _explodeTimer.start();
    setHitbox(RectangleHitbox(position: Vector2(0,0), size: Vector2.all(64)));
    addHitbox();
    super.onLoad();
  }

  @override
  void update(double dt)
  {
    _explodeTimer.update(dt);
    if(_explodeTimer.finished)
      {
        explode();
      }
    super.update(dt);
  }

  @override
  void entityMovement(double dt) {
    // TODO: implement entityMovement
  }

  @override
  void loadAllAnimation() {
    // TODO: implement loadAllAnimation
    _idleAnimation = loadAnimation("idle", 1, 1, true);

    animations = {
      1: _idleAnimation
    };

    current = 1;
  }

  void explode()
  {
    game.world.add(Explosion(myPosition: Vector2(position.x, position.y)
        , size: ExplosionSize.big, myTeam: getTeam()));
    setHealth(-1);
  }
}