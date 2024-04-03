import 'package:flame/components.dart';
import 'package:mw_project/actors/computers/rifleman.dart';
import 'package:mw_project/actors/projectiles/laser.dart';

import '../../constants/default_config.dart';
import '../placeable_entity.dart';

class LaserMan extends Rifleman
{
  bool _hasBullet = true;
  Timer _reloadTimer = Timer(0.75);

  LaserMan({super.myTeam, String name = "laser_man"})
      : super(characterName: name, hp: 200, cost: 150);

  @override
  PlaceableEntity clone() {
    return LaserMan();
  }
  
  @override
  void update(double dt)
  {
    if(_reloadTimer.isRunning())
      {
        _reloadTimer.update(dt);
        reload();
      }
    super.update(dt);
  }
  
  @override
  double calculateRayRange()
  {
    return TILE_SIZE * 3;
  }
  
  void reload()
  {
    if(_hasBullet == false && _reloadTimer.finished)
      {
        current = RiflemanState.aiming;
        _hasBullet = true;
      }
  }
  
  @override
  void shoot()
  {
    if(getFiringPermission() && _hasBullet == true)
    {
      current = RiflemanState.shooting;
      _hasBullet = false;
      animationTicker!.onFrame = (currentIndex) {
        if(currentIndex == 0)
        {
          final spawnPos = Vector2(this.position.x + 128,
              this.position.y + 64);
          game.world.add(Laser(startingPosition: spawnPos));
        }
      };
      animationTicker!.onComplete = () {
        current = RiflemanState.reloading;
      };
    }
    if(current == RiflemanState.reloading)
    {
      setFiringPermission(false);
      animationTicker!.onComplete = () {
        _reloadTimer.start();
      };
    }
  }

  @override
  void loadAllAnimation() {
    // TODO: implement loadAllAnimation
    aimingAnimation = loadAnimation("aiming", 1, 0.1, false);
    shootingAnimation = loadAnimation("shooting", 1, 0.1, false);
    reloadingAnimation = loadAnimation("reloading", 1, 0.1, false);

    animations = {
      RiflemanState.shooting: shootingAnimation,
      RiflemanState.aiming: aimingAnimation,
      RiflemanState.reloading: reloadingAnimation
    };

    current = RiflemanState.aiming;
  }
}