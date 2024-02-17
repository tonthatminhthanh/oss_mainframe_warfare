import 'package:flame/components.dart';
import 'package:mw_project/actors/computers/rifleman.dart';

import '../projectiles/bullet.dart';

class Hunter extends Rifleman
{
  Hunter({required super.myTeam, String name = "hunter"}) : super(characterName: name);

  static const int DEFAULT_BULLET_COUNT = 2;
  int _bullets = DEFAULT_BULLET_COUNT;

  @override
  void shoot()
  {
    if(getFiringPermission() == true && _bullets > 0)
    {
      current = RiflemanState.shooting;
      animationTicker!.onFrame = (currentIndex) {
        if(currentIndex == 0)
        {
          final spawnPos = Vector2(this.position.x + 128,
              this.position.y + 64);
          game.world.add(Bullet(startingPosition: spawnPos));
          _bullets -= 1;
        }
        else if(currentIndex == 1)
          {
            if(_bullets > 0)
            {
              currentIndex = 0;
            }
          }
      };
      animationTicker!.onComplete = () {
        current = RiflemanState.aiming;
      };
    }
    else if(_bullets == 0)
      {
        setFiringPermission(false);
        current = RiflemanState.reloading;
      }
    if(current == RiflemanState.reloading)
    {
      animationTicker!.onComplete = () {
        current = RiflemanState.aiming;
        _bullets = DEFAULT_BULLET_COUNT;
      };
    }
  }
}