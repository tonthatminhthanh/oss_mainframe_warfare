import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/placeable_entity.dart';

import '../../constants/team.dart';
import '../../constants/default_config.dart';

enum DummyState {
  normal, damaged, nearDeath
}

class Dummy extends PlaceableEntity
{
  late SpriteAnimation _normalAnimation;
  late SpriteAnimation _damagedAnimation;
  late SpriteAnimation _nearDeathAnimation;

  Dummy({Team myTeam = Team.defender, double rechargeTime = SLOW_RECHARGE})
      : super(characterName: "test_dummy",
      hp: TEST_DUMMY_HP, myTeam: myTeam, rechargeTime: rechargeTime, cost: 50);

  @override
  PlaceableEntity clone() {
    // TODO: implement clone
    return Dummy();
  }

  @override
  void entityMovement(double dt) {
    // TODO: implement entityMovement
  }

  @override
  void loadAllAnimation() {
    // TODO: implement loadAllAnimation
    _normalAnimation = loadAnimation("normal", 1, 1, true);
    _damagedAnimation = loadAnimation("damaged", 1, 1, true);
    _nearDeathAnimation = loadAnimation("near_death", 1, 1, true);

    animations = {
      DummyState.normal: _normalAnimation,
      DummyState.damaged: _damagedAnimation,
      DummyState.nearDeath: _nearDeathAnimation
    };

    current = DummyState.normal;
  }

  @override
  void onLoad()
  {
    setHitbox(RectangleHitbox(isSolid: true, position: Vector2(16, 0) ,size: Vector2(32, 64)));
    addHitbox();
    super.onLoad();
  }

  @override
  void update(double dt)
  {
    checkStatus();
    super.update(dt);
  }

  void checkStatus()
  {
    int hp = getHp();
    if(hp >= TEST_DUMMY_HP)
      {
        current = DummyState.normal;
      }
    if(hp <= TEST_DUMMY_HP * 2 / 3)
      {
        current = DummyState.damaged;
      }
    if(hp <= TEST_DUMMY_HP / 3)
      {
        current = DummyState.nearDeath;
      }
  }
}