import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mw_project/actors/tile.dart';
import 'package:mw_project/firebase/firebase_user_score.dart';

import '../constants/team.dart';
import '../objects/audio_manager.dart';
import 'entity.dart';

abstract class PlaceableEntity extends Entity with CollisionCallbacks, TapCallbacks
{
  RectangleHitbox? _rectHitbox;
  late Team _myTeam;
  late int _hp;
  late double _rechargeTime;
  double _speedModifier = 1.0;
  late String _characterName;
  bool _isFlipped = false;
  bool _canAttack = true;
  int _cost;
  MyTile? _tile;

  PlaceableEntity({required Team myTeam, required String characterName,
    required int hp, required double rechargeTime, double scaleWidth = 2.0, double scaleHeight = 2.0, int cost = 0}) : _cost = cost
  {
    _characterName = characterName;
    scale = Vector2(scaleWidth, scaleHeight);
    _myTeam = myTeam;
    _hp = hp;
    _rechargeTime = rechargeTime;
  }

  //Giữ ngón tay vào entity để xoá chúng
  @override
  void onLongTapDown(TapDownEvent event) {
    if(getTeam() == Team.defender)
      {
        removeFromTile();
      }
    event.continuePropagation = true;
    super.onLongTapDown(event);
  }

  //tiếp tục truyền touch event xuống các tappable khác
  @override
  void onTapDown(TapDownEvent event) {
    event.continuePropagation = true;
    super.onTapDown(event);
  }

  @override
  void update(double dt)
  {
    entityMovement(dt);
    checkHealth();
    selfDestruct();
    super.update(dt);
  }

  //Đặt HP
  void setHealth(int health)
  {
    _hp = health;
  }
  //Kiểm tra HP, nếu <= thì tự huỷ entity
  @override
  void checkHealth()
  {
    if(_hp <= 0)
      {
        removeFromTile();
        if(getTeam() == Team.attacker)
          {
            game.getLevel().reduceAttackersCount();
            UserScoreSnapshot.addKill();
            FlameAudio.play("sfx/death.wav",
                volume: AudioManager.getSfxVolune() * 0.5);
          }
        removeFromParent();
      }
  }

  @override
  void onLoad()
  {
    if(getTeam() == Team.attacker)
      {
        priority = 4;
        game.getLevel().addToAttackersCount();
      }
    else
      {
        priority = 3;
      }
    super.onLoad();
  }

  //Load anim
  @override
  SpriteAnimation loadAnimation(String name, int amount, double stepTime, bool loop)
  {
    String team = "";
    switch(getTeam())
    {
      case Team.defender:
        team = "computers";
        break;
      case Team.attacker:
        team = "viruses";
        break;
    }

    return SpriteAnimation.fromFrameData(
        game.images.fromCache("sprites/$team/$_characterName/$_characterName" + "_" + "$name.png"),
        SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2.all(64),
            loop: loop
        )
    );
  }
  //Đặt hitbox
  void setHitbox(RectangleHitbox rectangleHitbox)
  {
    _rectHitbox = rectangleHitbox;
  }

  //Nhận hitbox
  RectangleHitbox? getHitbox()
  {
    return _rectHitbox;
  }

  //Thêm hitbox
  void addHitbox()
  {
    if(getHitbox() != null)
    {
      add(getHitbox()!);
    }
  }
  //Tạo entity mới cùng loại
  PlaceableEntity clone();

  //Đổi đội của entity
  void swap(Team otherTeam)
  {
    _myTeam = otherTeam;
  }

  //Đặt thời gian recharge
  void setRechargeTime(double rechargeTime)
  {
    _rechargeTime = rechargeTime;
  }

  //Nhận thời gian recharge
  double getRechargeTime()
  {
    return _rechargeTime;
  }

  //Trừ HP khi gọi
  void getAttacked(int damage)
  {
    if(getTeam() == Team.defender)
      {
        AudioManager.playMeleeSound();
      }
    else
      {
        AudioManager.playHitSound(getName());
      }
    _hp -= damage;
  }

  //Nhận HP hiện tại của entity
  int getHp()
  {
    return _hp;
  }

  //Tự huỷ
  Future<void> selfDestruct()
  async {
    if(position.x <= -64)
    {
      if(getTeam() == Team.attacker)
        {
          print("Game over!");
          game.getDirector().gameOver();
        }
      removeFromParent();
    }
  }

  double getSpeedModifier()
  {
    return _speedModifier;
  }

  void setSpeedModifier(double modifier)
  {
    _speedModifier = modifier;
  }

  //Nhận team của entity
  Team getTeam()
  {
    return _myTeam;
  }

  //Nhận tên của entity
  String getName()
  {
    return _characterName;
  }

  //Nhận giá của entity
  int getPrice()
  {
    return _cost;
  }

  void setFlip(bool value)
  {
    _isFlipped = value;
  }

  bool getFlipState()
  {
    return _isFlipped;
  }

  //Gán tile vào biến _tile
  void setTile(MyTile tile)
  {
    _tile = tile;
  }

  //Xoá khỏi tile
  void removeFromTile()
  {
    if(_tile != null)
      {
        _tile!.removeOccupant();
      }
    removeFromParent();
  }
}