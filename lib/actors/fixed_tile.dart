import 'package:flame_tiled/flame_tiled.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/actors/tile.dart';

class FixedTile extends MyTile
{
  late bool _isActive = true;
  FixedTile({super.occupant});

  @override
  bool canPlaceOn()
  {
    if(getStatus() && isOccupied())
      {
        return true;
      }
    return false;
  }

  @override
  bool getStatus() {
    return _isActive;
  }

  @override
  void setStatus(bool value) {
    _isActive = value;
  }
}