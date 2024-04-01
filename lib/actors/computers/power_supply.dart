import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mw_project/actors/currencies/ion.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/objects/audio_manager.dart';

import '../../constants/team.dart';

enum PowerSupplyState {
  idle,
  production
}

class PowerSupply extends PlaceableEntity
{
  @override
  // TODO: implement debugMode
  bool get debugMode => super.debugMode;
  late int productionInterval = 15;
  double elapsedSecs = 0;
  late Timer interval;
  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _productionAnimation;
  double stepTime = 0.075;

  PowerSupply({ String characterName = "power_supply",
     Team myTeam = Team.defender, int hp = DEFAULT_COMPUTER_HP, double rechargeTime = FAST_RECHARGE, })
  : super(myTeam: myTeam, hp: hp, rechargeTime: rechargeTime, characterName: characterName
      , cost: 50)
  {
    interval
    = Timer(1, repeat: true, onTick: () => elapsedSecs += 1,);
  }

  @override
  PlaceableEntity clone() {
    // TODO: implement clone
    return PowerSupply();
  }

  @override
  FutureOr<void> onLoad()
  {
    productionInterval = Random().nextInt(productionInterval) + 15;
    setHitbox(RectangleHitbox(position: Vector2(16, 0) ,size: Vector2(32, 64)));
    addHitbox();
    interval.reset();
    interval.start();
    super.onLoad();
  }

  @override
  void entityMovement(double dt) {
    // TODO: implement entityMovement
    ;
  }

  @override
  void loadAllAnimation() {
    _idleAnimation = loadAnimation("idle", 11, stepTime, true);
    _productionAnimation = loadAnimation("production", 11, stepTime, false);
    // TODO: implement loadAllAnimation

    animations = {
      PowerSupplyState.idle: _idleAnimation,
      PowerSupplyState.production: _productionAnimation
    };

    current = PowerSupplyState.idle;
  }

  @override
  void update(double dt)
  {
    interval.update(dt);
    elapsedSecs *= getSpeedModifier();
    changeState();
    super.update(dt);
  }

  void changeState()
  {
    if(elapsedSecs >= productionInterval)
      {
        current = PowerSupplyState.production;
        elapsedSecs = 0;
        animationTicker?.onFrame = (int frame) {
          if(frame >= 6)
            {
              if(animationTicker!.currentIndex == 6)
              {
                FlameAudio.play("sfx/powerup.wav", volume: AudioManager.getSfxVolune());
                final spawnPos = Vector2(this.position.x + Random().nextInt(5) - 5 + 121,
                    this.position.y + Random().nextInt(5) - 5 + 64);
                var ion = Ion(position: spawnPos);
                ion.priority = 5;
                game.world.add(ion);
              }
            }
        };
        animationTicker?.onComplete = () {
          current = PowerSupplyState.idle;
        };
      }
  }
}