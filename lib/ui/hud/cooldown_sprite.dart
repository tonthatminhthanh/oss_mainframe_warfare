import 'dart:async';

import 'package:flame/components.dart';
import 'package:mw_project/mainframe_warfare.dart';

class CooldownSprite extends SpriteAnimationComponent with HasGameRef<MainframeWarfare>
{
  double rechargeTime;


  CooldownSprite({required this.rechargeTime});

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache("hud/clock.png"),
        SpriteAnimationData.sequenced(
            amount: 8,
            stepTime: rechargeTime / 8,
            textureSize: Vector2.all(128),
            loop: true
        )
    );
    super.onLoad();
  }
}