import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flame/components.dart';
import 'package:flame/timer.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:mw_project/actors/computers/claymore.dart';
import 'package:mw_project/actors/computers/dynamite.dart';
import 'package:mw_project/actors/computers/hunter.dart';
import 'package:mw_project/actors/computers/laser_man.dart';
import 'package:mw_project/actors/computers/power_supply.dart';
import 'package:mw_project/actors/computers/rifleman.dart';
import 'package:mw_project/actors/computers/test_dummy.dart';
import 'package:mw_project/actors/currencies/currency.dart';
import 'package:mw_project/actors/directors/wave_manager.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/computers_items.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/firebase/firebase_user_score.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/ui/widget_overlay/defenders_selection.dart';
import 'package:mw_project/objects/save_file.dart';
import 'package:mw_project/ui/widget_overlay/game_over.dart';
import 'package:mw_project/ui/widget_overlay/loading_screen.dart';

import '../../constants/team.dart';
import '../../objects/audio_manager.dart';
import '../../ui/hud/defenders_list.dart';
import '../tile.dart';

class MatchDirector extends Component with HasGameRef<MainframeWarfare>
{
  bool _isStartingUp = true;
  int _currentMainWave = 0;
  int _currentWave = 0;
  PlaceableEntity? _currentlySelected;
  Timer _selfProductionTimer = Timer(Random().nextInt(8) + 5, repeat: false);
  late ValueNotifier<int> _defenderMoney;
  late List<MyTile> _tilesRef;
  Timer? _spawnInterval;
  List<PlaceableEntity> _temporaryAttackers = [];
  List<PlaceableEntity> _selectedDefenders = [];
  List<DefenderGameItem> _selectedDefenderItems = [];
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
  }

  void gameOver() {
    game.overlays.add(GameOverMenu.ID);
  }

  bool isStartingUp()
  {
    return _isStartingUp;
  }

  void startMatch()
  {
    _isStartingUp = false;
  }

  void decreaseMoney(int money)
  {
    _defenderMoney.value -= money;
  }

  PlaceableEntity? getCurrentlySelected()
  {
    return _currentlySelected;
  }

  void selectEntity(PlaceableEntity entity)
  {
    _currentlySelected = entity;
  }

  void deselectAllBut(PlaceableEntity entity)
  {
    for(DefenderGameItem item in _selectedDefenderItems)
    {
      if(item.entity != entity)
      {
        item.deselect();
      }
    }
  }

  void emptySelection()
  {
    if(!_selectedDefenderItems.isEmpty && _currentlySelected != null)
      {
        DefenderGameItem item = _selectedDefenderItems.firstWhere((element) => element.entity.runtimeType == _currentlySelected.runtimeType);
        item.deselect();
        item.setRechargeTimer();
        item.cloneNewEntityForItem();
      }
    _currentlySelected = null;
  }

  @override
  void onLoad() async {
    loadMatch();
    super.onLoad();
  }

  void resetMatch()
  {
    print("Resetting match");
    _currentMainWave = 0;
    _currentWave = 0;
  }

  void loadMatch() async
  {
    if(!gameRef.overlays.isActive(LoadingScreen.ID));
    {
      gameRef.overlays.add(LoadingScreen.ID);
    }
    Map<String, dynamic>? saveData = await _grabSave();
    if(saveData != null)
      {
        save = SaveFile.fromJson(saveData);
        _defenderMoney.value = save!.defenderMoney;
        _currentMainWave = save!.currentWave;
        _tilesRef = game.getLevel().getTilesList();
        _loadSaveToMap();
      }
    callNewWave();
    gameRef.overlays.remove(LoadingScreen.ID);
    gameRef.overlays.add(DefenderSelection.ID);
  }

  void loadDefendersList()
  {
    for(PlaceableEntity entity in _selectedDefenders)
    {
      _selectedDefenderItems.add(DefenderGameItem(entity: entity));
    }
    int i = 1;
    for(DefenderGameItem item in _selectedDefenderItems)
      {
        item.position = Vector2(i * 128, 0);
        i++;
        item.priority = ITEM_PRIORITY;
        gameRef.world.add(item);
      }
  }

  void callNewWave()
  {
    _currentWave++;
    if(_currentWave < defaultAttackerScores.length)
    {
      print("Current wave: $_currentWave, main wave: $_currentMainWave");
      WaveManager waveManager = WaveManager(currentMainWave: _currentMainWave);
      _temporaryAttackers = waveManager.getEntitiesForWave(_currentWave);
      if(_currentWave == 1 && _currentMainWave == 0)
        {
          _spawnInterval = Timer(8, repeat: false);
        }
      else
        {
          _spawnInterval = Timer(Random().nextDouble() * 4 + 1, repeat: false);
        }
    }
    else
      {
        AudioManager.stopAllSfx();
        _currentWave = 0;
        print("Increased wave!");
        _currentMainWave += 2;
        _isStartingUp = true;
        gameRef.pauseEngine();
        UserScoreSnapshot.updateWave(_currentMainWave);
        var json = jsonEncode(_createSave().toJson());
        _uploadSaveToFirebase(json);
      }
  }

  @override
  void update(double dt) {
    if(_spawnInterval != null)
      {
        _spawnInterval!.update(dt);
        if(_spawnInterval!.finished)
        {
          game.getLevel().spawnAttackers(_temporaryAttackers);
          _temporaryAttackers = [];
        }
      }
    _selfProductionTimer.update(dt);
    if(_selfProductionTimer.finished)
      {
        _defenderMoney.value += DEFAULT_COMPUTER_EARNING;
        _selfProductionTimer = Timer(Random().nextInt(15) + 10, repeat: false);
      }
    super.update(dt);
  }

  Future<Map<String, dynamic>?> _grabSave() async
  {
    final storageRef = FirebaseStorage.instance.ref();

    String currentId = FirebaseAuth.instance.currentUser!.uid;
    final pathRef = storageRef.child("saves/${currentId}.json");
    var dataFromStorage = await pathRef.getData().catchError((e) {
      print("Save data does not exist!");
      resetMatch();
      emptySelection();
    });
    Map<String, dynamic>? data;
    if(dataFromStorage != null)
      {
        data = jsonDecode(String.fromCharCodes(dataFromStorage));
      }
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
        case "laser_man":
          entity = LaserMan();
          break;
        default:
          entity = PowerSupply();
          break;
      }
      
      _tilesRef.firstWhere(
              (e) => (e.x == element["x"] && e.y == element["y"])
      ).overwriteOccupant(entity);
    });
  }

  SaveFile _createSave()
  {
    var tilesWithEntity = game.getLevel().getTilesList().where(
            (element) => element.getOccupant() != null).toList();
    List<Map<String,dynamic>> tiles = [];
    tilesWithEntity.forEach((element) {
      tiles.add(
        {
          "type": element.getOccupant()!.getName(),
          "x": element.getOccupant()!.x,
          "y": element.getOccupant()!.y
        }
      );
    });

    return SaveFile(
        currentWave: _currentMainWave,
        defenderMoney: _defenderMoney.value,
        tiles: tiles
    );
  }

  void _uploadSaveToFirebase(String jsonString)
  {
    game.overlays.add(LoadingScreen.ID);
    FirebaseStorage storage = FirebaseStorage.instance;

    String currentId = FirebaseAuth.instance.currentUser!.uid;
    Reference storageReference = storage.ref().child("saves/${currentId}.json");

    UploadTask uploadTask = storageReference.putData(utf8.encode(jsonString));

    uploadTask.then((p0) {
      _selectedDefenders.clear();
      _selectedDefenderItems.clear();
      loadMatch();
    }).whenComplete(() {

    }).catchError((e) {
      print("Error: " + e.toString());
      if(game.overlays.isActive(LoadingScreen.ID))
      {
        game.overlays.remove(LoadingScreen.ID);
      }
    });
  }

  void addDefenderToList(PlaceableEntity entity)
  {
    if(!_selectedDefenders.contains(entity))
      {
        _selectedDefenders.add(entity);
      }
  }

  void removeDefenderFromList(PlaceableEntity entity)
  {
    if(_selectedDefenders.contains(entity))
    {
      _selectedDefenders.remove(entity);
    }
  }
}