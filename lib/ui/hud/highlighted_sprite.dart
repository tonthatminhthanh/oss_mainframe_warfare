import 'dart:async';

import 'package:flame/components.dart';
import 'package:mw_project/mainframe_warfare.dart';

class HighlightedSprite extends SpriteComponent with HasGameRef<MainframeWarfare>
{
  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("hud/highlighted.png"));
    super.onLoad();
  }
}