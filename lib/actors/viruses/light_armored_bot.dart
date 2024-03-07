import 'package:mw_project/actors/viruses/basic_bot.dart';

import '../../constants/team.dart';
import '../../constants/default_config.dart';
import '../placeable_entity.dart';

class LightArmoredBot extends BasicBot
{
  LightArmoredBot() : super(
    myTeam: Team.attacker,
    hp: LIGHT_ARMORED_BOT_HEALTH,
    characterName: "light_armored_bot",
    hitCooldown: BASIC_BOT_HIT_COOLDOWN,
    moveSpeed: BASIC_BOT_SPEED,
  );

  @override
  PlaceableEntity clone() {
    // TODO: implement clone
    return LightArmoredBot();
  }
}