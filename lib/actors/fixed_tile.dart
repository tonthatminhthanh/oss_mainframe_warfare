import 'dart:async';

import 'package:flame/components.dart';
import 'package:mw_project/actors/tile.dart';

class FixedTile extends MyTile
{
  late bool _isActive = true;
  FixedTile({super.occupant, required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
  }

  @override
  bool canPlaceOn()
  {
    if(getStatus() && isNotOccupied())
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