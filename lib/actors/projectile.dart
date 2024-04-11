import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/default_config.dart';

import '../constants/team.dart';
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
    priority = 5;
    super.onLoad();
  }

  void changeTeam(Team otherTeam)
  {
    _myTeam = otherTeam;
  }
  //Tấn công entity
  void attack(PlaceableEntity entity)
  {
    entity.getAttacked(_damage);
    removeFromParent();
  }
  //Nếu projectile collide với entity thì tấn công entity đó
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is PlaceableEntity)
      {
        if(other.getTeam() != _myTeam)
          {
            attack(other);
          }
      }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    movement(dt);
    selfDestruct();
    super.update(dt);
  }
  //Di chuyển projectile
  void movement(double dt);
  //Tự huỷ khi vượt quá màn hình chơi
  void selfDestruct()
  {
    if(position.x >= SCREEN_WIDTH + TILE_SIZE)
      {
        removeFromParent();
      }
  }

  //Load anim của projectile
  void loadAnimation()
  {
    sprite = Sprite(game.images.fromCache("sprites/projectiles/$_name.png"));
  }

  //Đặt hitbox
  void setHitbox(RectangleHitbox hitbox)
  {
    _hitbox = hitbox;
  }

  //Thêm hitbo
  void addHitbox()
  {
    if(_hitbox != null)
      {
        add(_hitbox!);
      }
  }
}