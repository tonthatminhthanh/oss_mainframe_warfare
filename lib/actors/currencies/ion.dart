import 'package:flame/components.dart';
import 'package:flame/src/sprite_animation.dart';
import 'package:mw_project/actors/currencies/currency.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/components/team.dart';
import 'package:mw_project/constants/default_config.dart';

class Ion extends Currency
{
  late Timer timer;

  Ion({required Vector2 position, bool isFalling = false, double timeOutTime = DEFAULT_TIMEOUT,})
      : super(startingPosition: position, myTeam: Team.defender, name: "ion", isFalling: isFalling, timeOutTime: timeOutTime);
}