import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/actors/projectiles/bullet.dart';
import 'package:mw_project/components/team.dart';
import 'package:mw_project/constants/default_config.dart';

enum RiflemanState {
  shooting, aiming, reloading
}

class Rifleman extends PlaceableEntity
{
  @protected
  late SpriteAnimation aimingAnimation;
  @protected
  late SpriteAnimation shootingAnimation;
  @protected
  late SpriteAnimation reloadingAnimation;

  late Ray2 _rayDetector;
  bool _canFire = false;
  bool _hasBullet = true;

  double _stepTime = 0.075;

  Rifleman({required Team myTeam, String characterName = "rifleman",
    int hp = DEFAULT_COMPUTER_HP,
    double rechargeTime = FAST_RECHARGE}) : super(characterName: characterName,
    hp: hp, myTeam: myTeam, rechargeTime: rechargeTime)
  {

  }

  @override
  void onLoad()
  {
    setHitbox(RectangleHitbox(position: Vector2(16, 0) ,size: Vector2(32, 64)));
    addHitbox();
    debugMode = true;
    super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    detectEnemy();
    shoot();
  }

  double calculateRayRange()
  {
    if((game.screenWidth - (position.x + 128)) == 0)
    {
      return 128;
    }
    else
      {
        return game.screenWidth - (position.x + 128);
      }
  }

  @override
  void entityMovement(double dt) {
    // TODO: implement entityMovement
  }

  void detectEnemy()
  {
    final ray = Ray2(origin: Vector2(
        position.x + 128, position.y + 64
      ),
      direction: Vector2(1,0)
    );
    final result = game.getRaycastResult(ray, getTeam(), calculateRayRange(),);

    if(result != null)
      {
        _canFire = true;
      }
  }

  void shoot()
  {
    if(_canFire == true && _hasBullet == true)
      {
        current = RiflemanState.shooting;
        _canFire = false;
        _hasBullet = false;
        animationTicker!.onFrame = (currentIndex) {
          if(currentIndex == 0)
            {
              final spawnPos = Vector2(this.position.x + 128,
                  this.position.y + 64);
              game.world.add(Bullet(startingPosition: spawnPos));
            }
        };
        animationTicker!.onComplete = () {
          current = RiflemanState.reloading;
        };
      }
    if(current == RiflemanState.reloading)
      {
        animationTicker!.onComplete = () {
          current = RiflemanState.aiming;
          _hasBullet = true;
        };
      }
  }

  bool getFiringPermission()
  {
    return _canFire;
  }

  void setFiringPermission(bool value)
  {
    _canFire = value;
  }

  @override
  void loadAllAnimation() {
    // TODO: implement loadAllAnimation
    aimingAnimation = loadAnimation("aiming", 1, _stepTime, true);
    shootingAnimation = loadAnimation("shooting", 7, _stepTime, false);
    reloadingAnimation = loadAnimation("reloading", 11, _stepTime, false);

    animations = {
      RiflemanState.shooting: shootingAnimation,
      RiflemanState.aiming: aimingAnimation,
      RiflemanState.reloading: reloadingAnimation
    };

    current = RiflemanState.aiming;
  }
}