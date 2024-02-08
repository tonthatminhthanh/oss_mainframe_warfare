import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:mw_project/actors/computers/power_supply.dart';
import 'package:mw_project/actors/currencies/currency.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/mainframe_warfare.dart';

import '../../components/team.dart';

class MatchDirector extends Component with HasGameRef<MainframeWarfare>
{
  PlaceableEntity? _currentlySelected = PowerSupply(myTeam: Team.defender);
  late ValueNotifier<int> _defenderMoney;

  MatchDirector({required ValueNotifier<int> defenderMoney})
  {
    _defenderMoney = defenderMoney;
  }

  void addMoney(Currency currency, int money)
  {
    switch(currency.getTeam())
    {
      case Team.defender:
        _defenderMoney.value += money;
        break;
      case Team.attacker:
        // none for now
    }
    print("Defender: ${_defenderMoney.value}");
  }

  void spawnCurrency()
  {

  }

  void gameOver()
  {

  }

  PlaceableEntity? getCurrentlySelected()
  {
    return _currentlySelected;
  }

  void emptySelection()
  {
    _currentlySelected = null;
    _currentlySelected = PowerSupply(myTeam: Team.defender);
  }
}