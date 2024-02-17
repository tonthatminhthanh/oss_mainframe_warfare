import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mw_project/actors/computers/power_supply.dart';
import 'package:mw_project/actors/fixed_tile.dart';
import 'package:mw_project/components/team.dart';

class Level extends World
{
  late final String _levelName;
  late TiledComponent _level;
  List<FixedTile> _tiles = [];

  Level({required String levelName})
  {
    _levelName = levelName;
  }

  @override
  FutureOr<void> onLoad() async {
    _level = await TiledComponent.load("$_levelName.tmx", Vector2.all(64));
    add(_level);
    _spawnObject();
    return super.onLoad();
  }

  void _spawnObject()
  {
    final tilesLayer = _level.tileMap.getLayer<ObjectGroup>("Tiles");

    if(tilesLayer != null)
      {
        for(final obj in tilesLayer.objects)
          {
            switch(obj.class_)
            {
              case "Tile":
                final fixedTile = FixedTile(
                  size: Vector2(obj.width,obj.height),
                  position: Vector2(obj.x, obj.y),
                );
                add(fixedTile);
                break;
            }
          }
      }
  }
}