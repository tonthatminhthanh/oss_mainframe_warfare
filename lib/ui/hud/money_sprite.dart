import 'dart:async';

import 'package:flame/components.dart';
import 'package:mw_project/mainframe_warfare.dart';

class MoneySprite extends SpriteComponent with HasGameRef<MainframeWarfare>
{
  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("hud/transparent_layer.png"));
    super.onLoad();
  }
}