import 'package:flame/components.dart';
import 'package:mw_project/actors/placeable_entity.dart';

abstract class MyTile extends PositionComponent
{
  PlaceableEntity? _occupant;

  MyTile({PlaceableEntity? occupant})
  {
    _occupant = occupant;
  }

  bool canPlaceOn();

  void setStatus(bool value);

  bool getStatus();

  bool isOccupied()
  {
    return _occupant != null;
  }

  void placeOnTile(PlaceableEntity entity)
  {
    if(canPlaceOn())
      {
        _occupant = entity;
        add(_occupant!);
      }
  }

  void removeEntity()
  {
    if(_occupant != null)
      {
        remove(_occupant!);
      }
  }
}