import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mw_project/actors/computers/claymore.dart';
import 'package:mw_project/actors/computers/dynamite.dart';
import 'package:mw_project/actors/computers/hunter.dart';
import 'package:mw_project/actors/computers/power_supply.dart';
import 'package:mw_project/actors/computers/rifleman.dart';
import 'package:mw_project/actors/computers/test_dummy.dart';
import 'package:mw_project/actors/currencies/currency.dart';
import 'package:mw_project/actors/directors/wave_manager.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/actors/viruses/armored_bot.dart';
import 'package:mw_project/actors/viruses/basic_bot.dart';
import 'package:mw_project/actors/viruses/light_armored_bot.dart';
import 'package:mw_project/actors/viruses/speed_bot.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/utilities/save_file.dart';

import '../../constants/team.dart';
import '../tile.dart';

const String test_save_path = "https://firebasestorage.googleapis.com/v0/b/mainframe-warfare.appspot.com/o/test_save%2Fsave.json?alt=media&token=f61a7eb2-0e42-4bfc-b1e5-19a5f6ee63c0";

class MatchDirector extends Component with HasGameRef<MainframeWarfare>
{
  int _currentMainWave = 0;
  int _currentWave = 0;
  PlaceableEntity? _currentlySelected = PowerSupply();
  late ValueNotifier<int> _defenderMoney;
  late List<MyTile> _tilesRef;
  Timer? _spawnInterval;
  List<PlaceableEntity> _temporaryAttackers = [];
  SaveFile? save;

  MatchDirector({required ValueNotifier<int> defenderMoney})
  {
    _defenderMoney = defenderMoney;
  }

  void addMoney(Currency currency, int money)
  {
    switch(currency.getTeam())
    {
      case Team.defender:
        _defenderMoney.value += money;
        break;
      case Team.attacker:
        // none for now
    }
    print("Defender: ${_defenderMoney.value}");
  }

  void spawnCurrency()
  {

  }

  void gameOver()
  {

  }

  PlaceableEntity? getCurrentlySelected()
  {
    return _currentlySelected;
  }

  void emptySelection()
  {
    _currentlySelected = null;
    _currentlySelected = TestDummy();//
  }

  @override
  void onLoad() async {
    Map<String, dynamic> saveData = await _grabSave();
    save = SaveFile.fromJson(saveData);
    _defenderMoney.value = save!.defenderMoney;
    _currentMainWave = save!.currentWave;
    _tilesRef = game.getLevel().getTilesList();
    _loadSaveToMap();
    callNewWave();
    super.onLoad();
  }

  void callNewWave()
  {
    _currentWave++;
    if(_currentWave < defaultAttackerScores.length)
    {
      print("Current wave: $_currentWave");
      WaveManager waveManager = WaveManager(currentMainWave: _currentMainWave);
      _temporaryAttackers = waveManager.getEntitiesForWave(_currentWave);
      print("Spawn $_temporaryAttackers in wave: $_currentWave");
      if(_currentWave == 1)
        {
          _spawnInterval = Timer(8, repeat: false);
        }
      else
        {
          _spawnInterval = Timer(Random().nextDouble() * 6 + 1, repeat: false);
        }
    }
  }

  @override
  void update(double dt) {
    _spawnInterval!.update(dt);
    if(_spawnInterval!.finished)
    {
      game.getLevel().spawnAttackers(_temporaryAttackers);
      _temporaryAttackers = [];
    }
    super.update(dt);
  }

  Future<Map<String, dynamic>> _grabSave() async
  {
    var url = Uri.parse(test_save_path);
    http.Response response = await http.get(url);

    Map<String, dynamic> data = jsonDecode(response.body);

    return data;
  }

  ValueNotifier<int> getDefenderMoney()
  {
    return _defenderMoney;
  }

  void _loadSaveToMap()
  {
    save!.tiles.forEach((element) {
      late PlaceableEntity entity;

      switch(element["type"])
      {
        case "power_supply":
          entity = PowerSupply();
          break;
        case "rifleman":
          entity = Rifleman();
          break;
        case "claymore":
          entity = Claymore();
          break;
        case "dynamite":
          entity = Dynamite();
          break;
        case "hunter":
          entity = Hunter();
          break;
        case "test_dummy":
          entity = TestDummy();
          break;
        default:
          entity = PowerSupply();
          break;
      }
      
      _tilesRef.firstWhere(
              (e) => (e.x == element["x"] && e.y == element["y"])
      ).setOccupant(entity);
    });
  }
}