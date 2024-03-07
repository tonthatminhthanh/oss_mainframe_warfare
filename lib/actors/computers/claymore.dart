import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/particles/explosion.dart';

class Claymore extends PlaceableEntity
{
  late SpriteAnimation _sprite;

  Claymore({
    super.myTeam = Team.defender,
    super.characterName = "claymore",
    super.hp = DEFAULT_COMPUTER_HP,
    super.rechargeTime = SLOW_RECHARGE,
    super.cost = 50
      });

  @override
  PlaceableEntity clone() {
    // TODO: implement clone
    return Claymore();
  }

  @override
  void onLoad()
  {
    loadAllAnimation();
    debugMode = true;
    setPosition(Vector2(position.x + 64, position.y + 64));
    print(position);
    setHitbox(RectangleHitbox(position: Vector2(0,0), size: Vector2.all(64)));
    addHitbox();
    super.onLoad();
  }

  @override
  void entityMovement(double dt) {
    // TODO: implement entityMovement
  }

  @override
  void loadAllAnimation() {
    // TODO: implement loadAllAnimation
    _sprite = loadAnimation("idle", 1, 1, false);

    animations = {
      1: _sprite
    };

    current = 1;
  }

  void attack(PlaceableEntity enemy)
  {
    game.world.add(Explosion(myPosition: Vector2(position.x, position.y)
        , size: ExplosionSize.small, myTeam: getTeam()));
    setHealth(-1);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is PlaceableEntity)
    {
      if(other.getTeam() != getTeam())
      {
        attack(other);
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}