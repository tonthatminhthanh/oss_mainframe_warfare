import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mw_project/actors/directors/match_director.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/mainframe_warfare.dart';

import '../constants/team.dart';

abstract class MyTile extends PositionComponent with TapCallbacks, HasGameRef<MainframeWarfare>
{
  PlaceableEntity? _occupant;

  MyTile({PlaceableEntity? occupant, required Vector2 size, required Vector2 position})
      : super(size: size, position: position)
  {
    _occupant = occupant;
  }


  @override
  FutureOr<void> onLoad() {
    super.onLoad();
  }

  //Kiểm tra có thể đặt được entity lên tile không
  bool canPlaceOn();

  //Đặt status boolean
  void setStatus(bool value);

  //Nhận status
  bool getStatus();

  //Kiểm tra tile có entity nằm trên hay không
  bool isNotOccupied()
  {
    return _occupant == null;
  }

  //Đặt lại occupant
  void overwriteOccupant(PlaceableEntity entity)
  {
    if(!isNotOccupied())
      {
        _occupant!.removeFromTile();
        _occupant = null;
      }

    if(entity.getTeam() == Team.defender)
    {
      var director = game.getDirector();
      _occupant = entity;
      _occupant!.setTile(this);
      director.emptySelection();
      if(!director.isStartingUp())
      {
        director.decreaseMoney(_occupant!.getPrice());
      }
    }
    entity.priority = 2;
    gameRef.world.add(entity);
    if(entity.getFlipState())
    {
      entity.setPosition(Vector2(position.x + 128, position.y));
    }
    else
    {
      entity.setPosition(Vector2(position.x, position.y));
    }
  }

  void setOccupant(PlaceableEntity entity)
  {
    if(canPlaceOn())
      {
        if(entity.getTeam() == Team.defender)
          {
            var director = game.getDirector();
            _occupant = entity;
            _occupant!.setTile(this);
            director.emptySelection();
            if(!director.isStartingUp())
              {
                director.decreaseMoney(_occupant!.getPrice());
              }
          }
        entity.priority = 2;
        gameRef.world.add(entity);
        if(entity.getFlipState())
          {
            entity.setPosition(Vector2(position.x + 128, position.y));
          }
        else
          {
            entity.setPosition(Vector2(position.x, position.y));
          }
      }
  }

  //Lấy occupant
  PlaceableEntity? getOccupant()
  {
    return _occupant;
  }

  //Đặt entity lên tile khi tap down
  @override
  void onTapDown(TapDownEvent event) {
    MatchDirector director = gameRef.getDirector();
    PlaceableEntity? entity = director.getCurrentlySelected();
    if(entity != null)
      {
        setOccupant(entity);
      }
    event.continuePropagation = false;
    super.onTapDown(event);
  }

  //Xoá occupant khỏi tile
  void removeOccupant()
  {
    if(_occupant != null)
      {
        _occupant = null;
      }
  }
}