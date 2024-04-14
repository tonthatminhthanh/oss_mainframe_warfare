import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/src/sprite_animation.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/constants/basic_virus_enum.dart';
import 'package:mw_project/constants/default_config.dart';

class BasicBot extends PlaceableEntity
{
  late int _damage;
  late double _moveSpeed;
  Vector2 _velocity = Vector2.zero();
  late double _stepTime;
  late double _hitCooldown;
  late SpriteAnimation _runningAnimation;
  late SpriteAnimation _attackingAnimation;

  BasicBot({ int damage = BASIC_VIRUS_DAMAGE, double stepTime = 0.075,
    double hitCooldown = BASIC_BOT_HIT_COOLDOWN, double moveSpeed = BASIC_BOT_SPEED,
    double scaleWidth = 2.0, double scaleHeight = 2.0,
    super.myTeam = Team.attacker, String characterName = "basic_bot",
     super.hp = BASIC_BOT_HEALTH, super.rechargeTime = 0
  }) : super(characterName: characterName, scaleWidth: scaleWidth, scaleHeight: scaleHeight)
  {
    _damage = damage;
    _moveSpeed = moveSpeed;
    _hitCooldown = hitCooldown;
    _stepTime = stepTime;
  }

  @override
  void onLoad()
  {
    setHitbox(RectangleHitbox(position: Vector2(16, 10) ,size: Vector2(32, 32)));
    addHitbox();
    setFlip(true);
    if(getFlipState())
    {
      flipHorizontallyAroundCenter();
    }
    super.onLoad();
  }

  @override
  void entityMovement(double dt) {
    // TODO: implement entityMovement
    _velocity.x = -_moveSpeed;
    if(current == VirusState.running)
      {
        position = Vector2(position.x + (_velocity.x * dt), position.y);
      }
  }

  @override
  void loadAllAnimation() {
    // TODO: implement loadAllAnimation
    _runningAnimation = loadAnimation("running", 11, _stepTime, true);
    _attackingAnimation = loadAnimation("attacking", 9, _hitCooldown, true);

    animations = {
      VirusState.running: _runningAnimation,
      VirusState.attacking: _attackingAnimation
    };

    current = VirusState.running;
  }

  void attack(PlaceableEntity victim)
  {
    int victimHp = victim.getHp();
    current = VirusState.attacking;
    animationTicker!.onFrame = (currentIndex) {
      if(currentIndex == 4)
        {
          victim.getAttacked(_damage);
        }
      else if (currentIndex == 8)
        {
          if(victimHp - _damage <= 0)
          {
            current = VirusState.running;
          }
        }
    };
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is PlaceableEntity)
    {
      if(other.getTeam() != getTeam())
      {
        attack(other);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  PlaceableEntity clone() {
    return BasicBot();
  }
}