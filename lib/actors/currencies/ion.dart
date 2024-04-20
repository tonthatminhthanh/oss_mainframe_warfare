import 'package:flame/components.dart';
import 'package:mw_project/actors/currencies/currency.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/constants/default_config.dart';

class Ion extends Currency
{
  late Timer timer;

  Ion({required Vector2 position, int value = DEFAULT_COMPUTER_EARNING, bool isFalling = false, double timeOutTime = DEFAULT_TIMEOUT,})
      : super(startingPosition: position, myTeam: Team.defender, name: "ion", value: value, isFalling: isFalling, timeOutTime: timeOutTime);
}