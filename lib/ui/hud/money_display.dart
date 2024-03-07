import 'dart:async';
import 'package:flame/text.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:mw_project/mainframe_warfare.dart';

class MoneyDisplay extends Component with HasGameRef<MainframeWarfare>
{
  MoneyDisplay({super.children, super.priority});
  late TextComponent _moneyTextComponent;

  @override
  FutureOr<void> onLoad() {
    final silverFont = TextStyle(
        fontFamily: "Silver",
        fontSize: 80,
        color: BasicPalette.white.color
    );

    final textPaint = TextPaint(style: silverFont);

     _moneyTextComponent = TextComponent(
      text: game.getDirector().getDefenderMoney().value.toString(),
      textRenderer: textPaint,
      anchor: Anchor.topRight,
      position: Vector2(120,100)
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