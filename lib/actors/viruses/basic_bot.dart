import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/src/sprite_animation.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/basic_virus_enum.dart';

class BasicBot extends PlaceableEntity
{
  late int _damage;
  late double _moveSpeed;
  Vector2 _velocity = Vector2.zero();
  late double _stepTime;
  late double _hitCooldown;
  late SpriteAnimation _runningAnimation;
  late SpriteAnimation _attackingAnimation;

  BasicBot({ int damage = 50, double stepTime = 0.075,
    double hitCooldown = 0.05, double moveSpeed = 95,
    required super.myTeam, String characterName = "basic_bot",
    required super.hp, required super.rechargeTime}) : super(characterName: characterName)
  {
    _damage = damage;
    _moveSpeed = moveSpeed;
    _hitCooldown = hitCooldown;
    _stepTime = stepTime;
  }

  @override
  void onLoad()
  {
    debugMode = true;
    setHitbox(RectangleHitbox(position: Vector2(16, 10) ,size: Vector2(32, 32)));
    addHitbox();
    setFlip(true);
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
    if(getFlipState())
      {
        flipHorizontallyAroundCenter();
      }

    _runningAnimation = loadAnimation("run", 11, _stepTime, true);
    _attackingAnimation = loadAnimation("attack", 9, _hitCooldown, true);

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
            print(victim);
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
}