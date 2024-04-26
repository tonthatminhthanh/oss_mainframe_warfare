import 'dart:async';
import 'package:flame/text.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:mw_project/mainframe_warfare.dart';

import '../../constants/achievements_list.dart';

class AchievementDisplay extends Component with HasGameRef<MainframeWarfare>
{
  String id;
  AchievementDisplay({super.children, super.priority, required this.id});
  late TextComponent _achievementTextComponent;
  Timer timer = Timer(5, autoStart: true);

  @override
  FutureOr<void> onLoad() {
    final silverFont = TextStyle(
        fontFamily: "Silver",
        fontSize: 48,
        color: BasicPalette.white.color
    );

    final textPaint = TextPaint(style: silverFont);

    _achievementTextComponent = TextComponent(
        text: "Achievement gained: " + achievements.where((element) => element.id == id).first.name,
        textRenderer: textPaint,
        anchor: Anchor.topRight,
        position: Vector2(1024,700)
    );
    add(_achievementTextComponent);
  }

  void changePosition(double value)
  {
    _achievementTextComponent.position = Vector2(
        _achievementTextComponent.position.x, _achievementTextComponent.position.y + value
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
    if(timer.finished)
      {
        removeAchievementDisplay();
      }
  }

  void removeAchievementDisplay()
  {
    _achievementTextComponent.removeFromParent();
    removeFromParent();
  }
}