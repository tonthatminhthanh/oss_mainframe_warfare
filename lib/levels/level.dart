import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mw_project/actors/fixed_tile.dart';
import 'package:mw_project/actors/tile.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/ui/hud/money_display.dart';

import '../actors/placeable_entity.dart';

class Level extends World with HasGameRef<MainframeWarfare>
{
  late final String _levelName;
  late TiledComponent _level;
  List<MyTile> _tiles = [];
  int _attackersCountInCurrentWave = 0;
  int _attackersCount = 0;

  Level({required String levelName})
  {
    _levelName = levelName;
  }

  @override
  FutureOr<void> onLoad() async {
    _level = await TiledComponent.load("$_levelName.tmx", Vector2.all(64));
    add(_level);
    add(MoneyDisplay());
    _spawnObject();
    return super.onLoad();
  }


  @override
  void update(double dt) {
    super.update(dt);
  }

  void addToAttackersCount()
  {
    _attackersCount++;
    _attackersCountInCurrentWave = _attackersCount;
  }

  void reduceAttackersCount()
  {
    _attackersCount--;
    if(canCallNewWave())
      {
        print("calling new wave!!");
        game.getDirector().callNewWave();
        _attackersCountInCurrentWave = 0;
      }
  }

  bool canCallNewWave()
  {
    return _attackersCount <= _attackersCountInCurrentWave / 2;
  }

  void spawnAttackers(List<PlaceableEntity> attackers)
  {
    for(final attacker in attackers)
      {
        add(attacker);
      }
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
                fixedTile.priority = 1;
                add(fixedTile);
                _tiles.add(fixedTile);
                break;
            }
          }
      }
  }

  List<MyTile> getTilesList()
  {
    return _tiles;
  }
}