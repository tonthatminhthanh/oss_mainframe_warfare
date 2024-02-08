import 'package:flame/components.dart';

import '../components/team.dart';
import 'entity.dart';

abstract class PlaceableEntity extends Entity
{
  late Team _myTeam;
  late int _hp;
  late double _rechargeTime;
  double _speedModifier = 1.0;

  PlaceableEntity({required Team myTeam, required int hp, required double rechargeTime})
  {
    scale = Vector2(2, 2);
    _myTeam = myTeam;
    _hp = hp;
    _rechargeTime = rechargeTime;
  }

  void swap(Team otherTeam)
  {
    _myTeam = otherTeam;
  }

  void setRechargeTime(double rechargeTime)
  {
    _rechargeTime = rechargeTime;
  }

  double getRechargeTime()
  {
    return _rechargeTime;
  }

  void getAttacked(int damage)
  {
    _hp -= damage;
  }

  double getSpeedModifier()
  {
    return _speedModifier;
  }

  void setSpeedModifier(double modifier)
  {
    _speedModifier = modifier;
  }

  Team getTeam()
  {
    return _myTeam;
  }
}