import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mw_project/actors/computers/claymore.dart';
import 'package:mw_project/actors/computers/dynamite.dart';
import 'package:mw_project/actors/computers/hunter.dart';
import 'package:mw_project/actors/computers/laser_man.dart';
import 'package:mw_project/actors/computers/power_supply.dart';
import 'package:mw_project/actors/computers/rifleman.dart';
import 'package:mw_project/actors/computers/test_dummy.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/objects/audio_manager.dart';

import '../../mainframe_warfare.dart';
import 'loading_screen.dart';

List<PlaceableEntity> registeredEntities = [
  PowerSupply(),
  Rifleman(),
  TestDummy(),
  Claymore(),
  Dynamite(),
  Hunter(),
  LaserMan()
];

class DefenderItem extends StatefulWidget {
  final PlaceableEntity entity;
  bool selected;
  DefenderItem({super.key, required this.entity, this.selected = false});

  @override
  State<DefenderItem> createState() => _DefenderItemState();
}

class _DefenderItemState extends State<DefenderItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Image.asset("assets/images/hud/item_frames/computers/"
              "${widget.entity.getName()}.png", width: 128, height: 128,),
          widget.selected ? Icon(Icons.check, size: 64,) : Container(),
          Positioned(
            bottom: 8,
            left: 64,
            child: Text(widget.entity.getPrice().toString(), style: TextStyle(
                fontFamily: "Silver", fontSize: 24, decoration: TextDecoration.none,
                fontWeight: FontWeight.normal, color: Colors.black),),
          )
        ],
    );
  }
}


class DefenderSelection extends StatefulWidget {
  static String ID = "DefenderSelectionMenu";
  MainframeWarfare gameRef;
  int selectedCount = 0;
  int maxCount = MAX_DEFENDERS_COUNT;
  List<bool> selected = List.filled(registeredEntities.length, false);
  DefenderSelection({super.key, required this.gameRef});

  @override
  State<DefenderSelection> createState() => _DefenderSelectionState();
}

class _DefenderSelectionState extends State<DefenderSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: registeredEntities.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.selected[index] = !widget.selected[index];
                      });
                      if(widget.selected[index])
                        {
                          if(widget.selectedCount == widget.maxCount)
                            {
                              widget.selected[index] = false;
                            }
                          else
                            {
                              widget.gameRef.getDirector().addDefenderToList(registeredEntities[index]);
                              widget.selectedCount++;
                            }
                        }
                      else
                        {
                          widget.gameRef.getDirector().removeDefenderFromList(registeredEntities[index]);
                          widget.selectedCount--;
                        }
                    },
                    child: DefenderItem(
                      entity: registeredEntities[index],
                      selected: widget.selected[index],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        ElevatedButton(
            onPressed: (widget.selectedCount == MAX_DEFENDERS_COUNT) ? () {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('bgm/deepdive.wav', volume: AudioManager.getBgmVolume());
              widget.gameRef.overlays.remove(DefenderSelection.ID);
              widget.gameRef.getDirector().loadDefendersList();
            widget.gameRef.resumeEngine();
              widget.gameRef.getDirector().startMatch();
            } : null,
            child: Text("Start match", style: TextStyle(fontFamily: "Silver"),)
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    widget.gameRef.pauseEngine();
  }
}
