import 'dart:math';

import 'package:flame/components.dart';
import 'package:mw_project/actors/computers/claymore.dart';
import 'package:mw_project/actors/computers/dynamite.dart';
import 'package:mw_project/actors/viruses/basic_bot.dart';
import 'package:mw_project/constants/basic_virus_enum.dart';
import 'package:mw_project/constants/default_config.dart';

import '../../constants/team.dart';
import '../placeable_entity.dart';

class TrojanHorse extends BasicBot
{
  late SpriteAnimation _movingAnimation;
  TrojanHorse() : super(
      characterName: "trojan_horse",
      scaleHeight: 2.0, scaleWidth: 2.0, moveSpeed: BASIC_BOT_SPEED, hp: ARMORED_BOT_HEALTH);

  @override
  PlaceableEntity clone() {
    return TrojanHorse();
  }

  @override
  void onLoad()
  {
    super.onLoad();
    getHitbox()!.position = Vector2(43, 25);
    getHitbox()!.size = Vector2(45, 36);
    setFlip(true);
    if(getFlipState())
    {
      flipHorizontallyAroundCenter();
    }
  }

  @override
  void attack(PlaceableEntity victim)
  {
    if(!(victim is Claymore || victim is Dynamite))
      {
        victim.getAttacked(EXPLOSION_DAMAGE);
      }
  }

  @override
  void checkHealth()
  {
    if(getHp() >= 10 && getHp() <= 50)
      {
        for(int i = 1; i <= 6;i++)
          {
            BasicBot bot = BasicBot();
            bot.position = Vector2((position.x + 256) + i * (Random().nextInt(20) + 10), position.y);
            gameRef.getLevel().add(bot);
          }
        gameRef.getLevel().reduceAttackersCount();
        removeFromParent();
      }
    super.checkHealth();
  }

  @override
  SpriteAnimation loadAnimation(String name, int amount, double stepTime, bool loop) {
    String team = "";
    switch (getTeam()) {
      case Team.defender:
        team = "computers";
        break;
      case Team.attacker:
        team = "viruses";
        break;
    }

    return SpriteAnimation.fromFrameData(
        game.images.fromCache("sprites/$team/${getName()}/${getName()}" + "_" + "$name.png"),
        SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2(128, 64),
            loop: loop
        )
    );
  }

  @override
  void loadAllAnimation() {
    // TODO: implement loadAllAnimation
    _movingAnimation = loadAnimation("moving", 1, 1, true);

    animations = {
      VirusState.running: _movingAnimation,
    };

    current = VirusState.running;
  }
}