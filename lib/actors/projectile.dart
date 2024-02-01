import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/entity.dart';
import 'package:mw_project/actors/placeable_entity.dart';

import '../components/team.dart';

abstract class Projectile extends Entity with CollisionCallbacks
{
  final bool _isActive = true;
  late Team _myTeam;
  late int _damage;

  Projectile({required Team myTeam, required int damage})
  {
    _myTeam = myTeam;
    _damage = damage;
  }

  void changeTeam(Team otherTeam)
  {
    _myTeam = otherTeam;
  }

  void attack(PlaceableEntity entity)
  {
    entity.getAttacked(_damage);
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
}