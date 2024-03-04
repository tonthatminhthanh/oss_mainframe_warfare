import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/mainframe_warfare.dart';

import '../../constants/team.dart';

class Currency extends SpriteComponent with TapCallbacks, HasGameRef<MainframeWarfare>
{
  String _name;
  late Team _myTeam;
  int _value;
  bool _isFalling;
  Vector2 _startingPosition;
  late Timer _timer;
  double _timeOutTime;

  Currency({required Team myTeam, required String name
    , required Vector2 startingPosition
    , int value = DEFAULT_COMPUTER_EARNING
    , bool isFalling = false
    , required double timeOutTime
  }) : _myTeam = myTeam,
        _timeOutTime = timeOutTime,
        _startingPosition = startingPosition,
        _isFalling = isFalling,
        _value = value,
        _name = name
  {
    _timer = Timer(_timeOutTime, repeat: false);
  }

  @override
  FutureOr<void> onLoad() {
    _loadSprite(_name);
    scale = Vector2(2, 2);
    position = _startingPosition;
    super.onLoad();
  }


  @override
  void update(double dt) {
    _timer.update(dt);
    autoRemove();
    super.update(dt);
  }

  void autoRemove()
  {
    if(_timer.finished)
      {
        removeFromParent();
      }
  }

  Timer getTimer()
  {
    return _timer;
  }

  double getTimeoutTime()
  {
    return _timeOutTime;
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.getDirector().addMoney(this, _value);
    removeFromParent();
    super.onTapDown(event);
  }

  Team getTeam()
  {
    return _myTeam;
  }

  void _loadSprite(String name)
  {
    sprite = Sprite(game.images.fromCache("sprites/currencies/$name.png"));
  }
}