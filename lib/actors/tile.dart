import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mw_project/actors/directors/match_director.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/mainframe_warfare.dart';

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

  bool canPlaceOn();

  void setStatus(bool value);

  bool getStatus();

  bool isNotOccupied()
  {
    return _occupant == null;
  }

  void setOccupant(PlaceableEntity entity)
  {
    print("Status: ${getStatus()}, is not occupied: ${isNotOccupied()}");
    if(canPlaceOn())
      {
        _occupant = entity;
        gameRef.world.add(entity);
        entity.setPosition(Vector2(position.x, position.y));
        print(entity.position);
      }
  }

  @override
  void onTapDown(TapDownEvent event) {
    MatchDirector director = gameRef.getDirector();
    PlaceableEntity? entity = director.getCurrentlySelected();
    if(entity != null)
      {
        setOccupant(entity);
        director.emptySelection();
      }
    super.onTapDown(event);
  }

  void removeEntity()
  {
    if(_occupant != null)
      {
        remove(_occupant!);
      }
  }
}