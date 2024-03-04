import 'package:mw_project/actors/viruses/basic_bot.dart';

import '../../constants/team.dart';
import '../../constants/default_config.dart';

class ArmoredBot extends BasicBot
{
  ArmoredBot() : super(
    myTeam: Team.attacker,
    hp: ARMORED_BOT_HEALTH,
    characterName: "armored_bot",
    hitCooldown: BASIC_BOT_HIT_COOLDOWN,
    moveSpeed: BASIC_BOT_SPEED,
  );
}