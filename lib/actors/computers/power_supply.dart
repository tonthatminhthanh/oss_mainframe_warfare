import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mw_project/actors/currencies/ion.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/default_config.dart';

import '../../components/team.dart';

enum PowerSupplyState {
  idle,
  production
}

class PowerSupply extends PlaceableEntity with CollisionCallbacks
{
  @override
  // TODO: implement debugMode
  bool get debugMode => super.debugMode;
  final String characterName = "power_supply";
  final int productionInterval = 20;
  double elapsedSecs = 0;
  late Timer interval;
  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _productionAnimation;

  PowerSupply({required Team myTeam, int hp = DEFAULT_COMPUTER_HP, double rechargeTime = FAST_RECHARGE})
  : super(myTeam: myTeam, hp: hp, rechargeTime: rechargeTime)
  {
    interval
    = Timer(1, repeat: true, onTick: () => elapsedSecs += 1,);
  }

  @override
  FutureOr<void> onLoad()
  {
    add(RectangleHitbox(position: Vector2(16, 0) ,size: Vector2(32, 64)));
    loadAllAnimation();
    interval.reset();
    interval.start();
    debugMode = true;
    super.onLoad();
  }

  @override
  void entityMovement() {
    // TODO: implement entityMovement
    ;
  }

  @override
  void kill() {
    // TODO: implement kill
  }

  @override
  void loadAllAnimation() {
    _idleAnimation = loadAnimation("idle", 11, 0.075, true);
    _productionAnimation = loadAnimation("production", 11, 0.075, false);
    // TODO: implement loadAllAnimation

    animations = {
      PowerSupplyState.idle: _idleAnimation,
      PowerSupplyState.production: _productionAnimation
    };

    current = PowerSupplyState.idle;
  }

  @override
  SpriteAnimation loadAnimation(String name, int amount, double stepTime, bool loop) {
    // TODO: implement loadAnimation
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("sprites/computers/$characterName/$characterName" + "_" + "$name.png"),
      SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(64),
        loop: loop
      )
    );
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
                final spawnPos = Vector2(this.position.x + Random().nextInt(5) - 5 + 121,
                    this.position.y + Random().nextInt(5) - 5 + 64);
                game.world.add(Ion(position: spawnPos));
              }
            }
        };
        animationTicker?.onComplete = () {
          current = PowerSupplyState.idle;
        };
      }
  }
}