import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/actors/projectiles/cannon_ball.dart';
import 'package:mw_project/constants/team.dart';

import '../../constants/default_config.dart';
import '../placeable_entity.dart';

enum CannonState {
  shooting, cooldown, reloading, aiming
}

class Cannon extends PlaceableEntity
{
  double _stepTime = 0.05;
  bool _canFire = true;
  Timer _reloadTimer = Timer(50, autoStart: false, repeat: false);

  @protected
  late SpriteAnimation aimingAnimation;
  @protected
  late SpriteAnimation cooldownAnimation;
  @protected
  late SpriteAnimation shootingAnimation;
  @protected
  late SpriteAnimation reloadingAnimation;

  Cannon({Team myTeam = Team.defender, String characterName = "cannon",
    int hp = DEFAULT_COMPUTER_HP,
    double rechargeTime = VERY_SLOW_RECHARGE, int cost = 500}) : super(characterName: characterName,
      hp: hp, myTeam: myTeam, rechargeTime: rechargeTime, cost: cost)
  {

  }

  @override
  PlaceableEntity clone() {
    return Cannon();
  }

  @override
  void entityMovement(double dt) {
    // TODO: implement entityMovement
  }

  @override
  void loadAllAnimation() {
    aimingAnimation = loadAnimation("aiming", 1, _stepTime, false);
    cooldownAnimation = loadAnimation("cooldown", 4, _stepTime, false);
    shootingAnimation = loadAnimation("shooting", 9, _stepTime, false);
    reloadingAnimation = loadAnimation("reloading", 5, _stepTime, false);

    animations = {
      CannonState.aiming: aimingAnimation,
      CannonState.shooting: shootingAnimation,
      CannonState.cooldown: cooldownAnimation,
      CannonState.reloading: reloadingAnimation
    };

    current = CannonState.aiming;
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
    if(_reloadTimer.isRunning())
      {
        _reloadTimer.update(dt);
        checkCooldown();
      }
    super.update(dt);
  }

  void checkCooldown()
  {
    if(_reloadTimer.finished && _canFire == false)
    {
      current = CannonState.reloading;
      animationTicker!.onComplete = () {
        _canFire = true;
        current = CannonState.aiming;
      };
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if(_canFire)
      {
        current = CannonState.shooting;
        animationTicker!.onComplete = () {
          current = CannonState.cooldown;
          animationTicker!.onComplete = () {
            _reloadTimer.start();
          };
        };
        final spawnPos = Vector2(this.position.x + 128,
            this.position.y + 32);
        game.world.add(CannonBall(startingPosition: spawnPos));
        _canFire = false;
      }
    event.continuePropagation = true;
    super.onTapDown(event);
  }
}