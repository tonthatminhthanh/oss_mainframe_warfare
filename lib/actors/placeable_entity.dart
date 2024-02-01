import '../components/team.dart';
import 'entity.dart';

abstract class PlaceableEntity extends Entity
{
  late Team _myTeam;
  late int _hp;
  late int _rechargeTime;

  PlaceableEntity({required Team myTeam, required int hp, required rechargeTime})
  {
    _myTeam = myTeam;
    _hp = hp;
    _rechargeTime = rechargeTime;
  }

  void swap(Team otherTeam)
  {
    _myTeam = otherTeam;
  }

  void setRechargeTime(int rechargeTime)
  {
    _rechargeTime = rechargeTime;
  }

  int getRechargeTime()
  {
    return _rechargeTime;
  }

  void getAttacked(int damage)
  {
    _hp -= damage;
  }

  Team getTeam()
  {
    return _myTeam;
  }
}