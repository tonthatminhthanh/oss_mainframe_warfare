import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:mw_project/actors/directors/match_director.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/computers_items.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/ui/hud/highlighted_sprite.dart';
import 'package:mw_project/ui/hud/money_sprite.dart';

import 'cooldown_sprite.dart';

class DefenderGameItem extends SpriteComponent with TapCallbacks, HasGameRef<MainframeWarfare>
{
  PlaceableEntity entity;
  late MatchDirector _director;
  Timer? rechargeTimer;
  bool _isSelected = false;
  HighlightedSprite _highlightedSprite = HighlightedSprite();
  late CooldownSprite _cooldownSprite;
  MoneySprite _moneySprite = MoneySprite();
  late TextComponent _priceTextComponent;

  DefenderGameItem({required this.entity, super.position});

  @override
  FutureOr<void> onLoad() {
    _cooldownSprite = CooldownSprite(rechargeTime: entity.getRechargeTime());

    final silverFont = TextStyle(
      fontFamily: "Silver",
      fontSize: 80,
      color: BasicPalette.black.color
    );

    final textPaint = TextPaint(style: silverFont);

    sprite = Sprite(game.images.fromCache("hud/item_frames/computers/${entity.getName()}.png"));
    _director = gameRef.getDirector();
    _priceTextComponent = TextComponent(
        text: entity.getPrice().toString(),
        textRenderer: textPaint,
        anchor: Anchor.topRight,
        position: Vector2(120,75)
    );
    add(_priceTextComponent);
    super.onLoad();
  }

  @override
  void update(double dt) {
    if(rechargeTimer != null)
      {
        rechargeTimer!.update(dt);
      }
    updateItem();
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _isSelected = !_isSelected;
    if(rechargeTimer != null)
      {
        if(!rechargeTimer!.finished)
          {
            _isSelected = false;
          }
      }
    if(entity.getPrice() > _director.getDefenderMoney().value)
      {
        _isSelected = false;
      }
    if(_isSelected)
      {
        _director.deselectAllBut(entity);
        _director.selectEntity(entity);
      }
    super.onTapDown(event);
  }

  void deselect()
  {
    _isSelected = false;
  }

  void cloneNewEntityForItem()
  {
    entity = entity.clone();
  }

  void setRechargeTimer()
  {
    rechargeTimer = Timer(entity.getRechargeTime(), repeat: false);
  }

  void updateItem()
  {
    if(_isSelected)
      {
        _highlightedSprite.priority = HIGHLIGHTED_PRIORITY;
        add(_highlightedSprite);
      }
    else
      {
        _highlightedSprite.removeFromParent();
      }
    if(entity.getPrice() > _director.getDefenderMoney().value)
      {
        _moneySprite.priority = COOLDOWN_PRIORITY;
        add(_moneySprite);
      }
    else
      {
        _moneySprite.removeFromParent();
      }
    if(rechargeTimer != null)
      {
        if(!rechargeTimer!.finished)
          {
            _cooldownSprite.priority = CLOCK_PRIORITY;
            add(_cooldownSprite);
          }
        else
          {
            _cooldownSprite.removeFromParent();
          }
      }
  }
}