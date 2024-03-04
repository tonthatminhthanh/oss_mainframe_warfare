import 'package:mw_project/actors/viruses/basic_bot.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/constants/default_config.dart';

import '../placeable_entity.dart';

class SpeedBot extends BasicBot
{
  SpeedBot() : super(
    myTeam: Team.attacker,
    hp: SPEED_BOT_HEALTH,
    characterName: "speed_bot",
    hitCooldown: SPEED_BOT_HIT_COOLDOWN,
    moveSpeed: SPEED_BOT_SPEED,
  );

  @override
  void attack(PlaceableEntity victim)
  {

  }
}
