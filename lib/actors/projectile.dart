import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/placeable_entity.dart';

import '../components/team.dart';
import '../mainframe_warfare.dart';

abstract class Projectile extends SpriteComponent with CollisionCallbacks, HasGameRef<MainframeWarfare>
{
  Team _myTeam;
  int _damage;
  String _name;
  RectangleHitbox? _hitbox;

  Projectile({required String name, required Vector2 startingPosition,
    required Team myTeam, required int damage})
      : _name = name, _myTeam = myTeam, _damage = damage, super(position: startingPosition);


  @override
  FutureOr<void> onLoad() {
    loadAnimation();
    super.onLoad();
  }

  void changeTeam(Team otherTeam)
  {
    _myTeam = otherTeam;
  }

  void attack(PlaceableEntity entity)
  {
    entity.getAttacked(_damage);
    removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is PlaceableEntity)
      {
        if(other.getTeam() != _myTeam)
          {
            attack(other);
          }
      }
    super.onCollision(intersectionPoints, other);
  }


  @override
  void update(double dt) {
    movement(dt);
    super.update(dt);
  }

  void movement(double dt);

  void loadAnimation()
  {
    sprite = Sprite(game.images.fromCache("sprites/projectiles/$_name.png"));
  }

  void setHitbox(RectangleHitbox hitbox)
  {
    _hitbox = hitbox;
  }

  void addHitbox()
  {
    if(_hitbox != null)
      {
        add(_hitbox!);
      }
  }
}