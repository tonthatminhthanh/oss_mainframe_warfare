import 'dart:async';

import 'package:flame/components.dart';
import 'package:mw_project/mainframe_warfare.dart';

class Hud extends Component with HasGameRef<MainframeWarfare>
{
  Hud({super.children, super.priority});
  late TextComponent _moneyTextComponent;

  @override
  FutureOr<void> onLoad() {
     _moneyTextComponent = TextComponent(
      text: game.getDirector().getDefenderMoney().value.toString(),
      anchor: Anchor.topRight,
      position: Vector2(75,100)
    );
    add(_moneyTextComponent);
    
    final ionSprite = SpriteComponent.fromImage(
        game.images.fromCache("hud/ion.png"),
      position: Vector2.all(32)
    );
    add(ionSprite);
  }

  @override
  void update(double dt) {
    _moneyTextComponent.text = game.getDirector().getDefenderMoney().value.toString();
    super.update(dt);
  }
}