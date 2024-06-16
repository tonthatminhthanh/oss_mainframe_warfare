import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mw_project/actors/computers/cannon.dart';
import 'package:mw_project/actors/computers/claymore.dart';
import 'package:mw_project/actors/computers/dynamite.dart';
import 'package:mw_project/actors/computers/hunter.dart';
import 'package:mw_project/actors/computers/laser_man.dart';
import 'package:mw_project/actors/computers/power_supply.dart';
import 'package:mw_project/actors/computers/rifleman.dart';
import 'package:mw_project/actors/computers/dummy.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/constants/defender_descriptions.dart';
import 'package:mw_project/objects/audio_manager.dart';
import 'package:mw_project/ui/widget_overlay/pause_menu.dart';
import 'package:mw_project/ui/widget_overlay/wave_display.dart';

import '../../mainframe_warfare.dart';
import '../../pages/main_menu.dart';

List<PlaceableEntity> registeredEntities = [
  PowerSupply(),
  Rifleman(),
  Dummy(),
  Claymore(),
  Dynamite(),
  Hunter(),
  LaserMan(),
  Cannon()
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
                fit: StackFit.expand,
                children: [
                    Image.asset("assets/images/hud/item_frames/computers/"
                        "${widget.entity.getName()}.png",),
                  widget.selected ? Icon(Icons.check, size: 128, color: Colors.red,) : Container(),
                ],
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: () {
                setState(() {
                  DefenderDescription.selectEntity(widget.entity);
                });
              }, icon: Icon(Icons.info, size: 36, color: Colors.blue.withOpacity(0.75),)),
              Container(
                width: 64, height: 20,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(Colors.black.value),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    color: Colors.white
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(widget.entity.getPrice().toString(), style: TextStyle(
                    fontFamily: "Silver", fontSize: 24, decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal, color: Colors.black,),),
                ),
              ),
            ],
          )

        ],
    );
  }
}


class DefenderSelection extends StatefulWidget {
  static String ID = "DefenderSelectionMenu";
  MainframeWarfare gameRef;
  DefenderItem? selectedForInfo;
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
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0
                  ),
                  color: Colors.white
                ),
                child: ValueListenableBuilder(
                  valueListenable: DefenderDescription.getEntity(),
                  builder: (context, value, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DefenderDescription.getEntity().value != null
                          ? Image.asset("assets/images/hud/item_frames/computers/"
                          "${value!.getName()}.png",
                        width: 128, height: 128,)
                          : Image.asset("assets/images/hud/item_frames/empty.png",
                        width: 128, height: 128,),
                      Text(
                        "Mô tả: " + DefenderDescription.getDescription()["desc"]!, style: TextStyle(
                         fontSize: 24, decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal, color: Colors.black,),),
                      Text(
                        "Sức kháng cự: " + DefenderDescription.getDescription()["defence"]!, style: TextStyle(
                         fontSize: 24, decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal, color: Colors.black,),),
                      Text(
                        "Sức tấn công: " + DefenderDescription.getDescription()["attack_strength"]!, style: TextStyle(
                         fontSize: 24, decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal, color: Colors.black,),),
                      Text(
                        "Tốc độ tấn công: " + DefenderDescription.getDescription()["attack_speed"]!, style: TextStyle(
                        fontSize: 24, decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal, color: Colors.black,),),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: registeredEntities.length,
                  itemBuilder: (context, index) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          ElevatedButton(
    onPressed: (widget.selectedCount == MAX_DEFENDERS_COUNT) ? () {
    FlameAudio.bgm.stop();
    //FlameAudio.bgm.play('bgm/deepdive.wav', volume: AudioManager.getBgmVolume().value);
    widget.gameRef.overlays.remove(DefenderSelection.ID);
    widget.gameRef.getDirector().loadDefendersList();
    widget.gameRef.resumeEngine();
    widget.gameRef.getDirector().startMatch();
    widget.gameRef.overlays.add(WaveDisplay.ID);
    } : null,
    child: Text("Start match", style: TextStyle(fontFamily: "Silver"),)),
            SizedBox(width: 10,),
            ElevatedButton(
                onPressed: () {
                  widget.gameRef.overlays.remove(PauseMenu.ID);
                  widget.gameRef.overlays.remove(WaveDisplay.ID);
                  FlameAudio.bgm.dispose();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainMenuPage(),)
                  );
                },
                child: Text(
                    "Return to main menu", style: TextStyle(fontFamily: "Silver")
                )
            ),
          ],
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
