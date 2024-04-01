import 'dart:math';

import 'package:flame/components.dart';
import 'package:mw_project/actors/viruses/armored_bot.dart';
import 'package:mw_project/actors/viruses/basic_bot.dart';
import 'package:mw_project/actors/viruses/light_armored_bot.dart';
import 'package:mw_project/actors/viruses/speed_bot.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/mainframe_warfare.dart';

import '../placeable_entity.dart';

const List<int> defaultAttackerScores = [1, 1, 1, 2, 2, 3, 3, 3, 4, 10, 5, 5, 5, 6, 6, 7, 7, 7, 8, 20];

class WaveManager
{
  List<int> attackerScores = defaultAttackerScores.toList();
  Map<String, int> attackersList = {
      "basic_bot": 1,
      "light_armored_bot": 3,
      "armored_bot": 4,
      "speed_bot": 4,
    };
  List<double> xCoords = [];

  WaveManager({required int currentMainWave})
  {
    for(int i = 0; i < attackerScores.length;i++)
      {
        attackerScores[i] += currentMainWave * 2;
      }
    print("Main wave $currentMainWave: $attackerScores");
    xCoords = List.filled(Random().nextInt(135) + GENERAL_HEIGHT, SCREEN_WIDTH + 128);
  }

  List<PlaceableEntity> getEntitiesForWave(int currentWave) //
  {
    List<PlaceableEntity> entitiesToSpawn = [];
    int score = attackerScores[currentWave - 1];
    while(score > 0)
      {
        for(int yIndex = Random().nextInt(GENERAL_HEIGHT) + 1; yIndex <= GENERAL_HEIGHT;yIndex++)
          {
            if(score <= 0)
              {
                break;
              }
            late PlaceableEntity placeableEntity;
            var possibleEntries = (attackersList.entries.where(
                    (element) => element.value >= 1 && element.value <= score)).toList();
            var randomElement = possibleEntries[Random().nextInt(possibleEntries.length)];

            switch(randomElement.key)
            {
              case "basic_bot":
                placeableEntity = BasicBot();
                break;
              case "light_armored_bot":
                placeableEntity = LightArmoredBot();
                break;
              case "armored_bot":
                placeableEntity = ArmoredBot();
                break;
              case "speed_bot":
                placeableEntity = SpeedBot();
                break;
            }
            placeableEntity.position = Vector2(xCoords[yIndex - 1], (TILE_SIZE * yIndex));
            score -= randomElement.value;
            entitiesToSpawn.add(placeableEntity);
            xCoords[yIndex - 1] += Random().nextInt(128) + 32;
          }
      }
      return entitiesToSpawn;
  }
}