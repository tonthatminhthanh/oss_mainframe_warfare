import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mw_project/constants/team.dart';
import 'package:mw_project/mainframe_warfare.dart';
import 'package:mw_project/actors/placeable_entity.dart';
import 'package:mw_project/constants/default_config.dart';
import 'package:mw_project/objects/audio_manager.dart';

//Kích cỡ nỗ
enum ExplosionSize {
  small, big
}

class Explosion extends SpriteAnimationComponent with HasGameRef<MainframeWarfare>, CollisionCallbacks
{
  static const double _smallSize = 128;
  static const double _bigExplosionSize = 384;
  static const double _bigSize = 150;

  CircleHitbox? _hitbox;
  ExplosionSize _size;
  double _imageSize = _smallSize;
  String _sizeName = "small";
  Team _myTeam;
  double _radius = 0;

  Explosion({required Vector2 myPosition, required Team myTeam, required ExplosionSize size})
      : _size = size, _myTeam = myTeam, super(position: myPosition);

  @override
  void onLoad() {
    switch(_size)
    {
      case ExplosionSize.small:
        _sizeName = "small";
        _imageSize = _smallSize;
        break;
      case ExplosionSize.big:
        _sizeName = "big";
        _imageSize = _bigSize;
        break;
    }

    SpriteAnimation anim = SpriteAnimation.fromFrameData(
        game.images.fromCache("particles/explosion_${_sizeName}.png"),
        SpriteAnimationData.sequenced(
            amount: 12,
            stepTime: 0.05,
            textureSize: Vector2.all(_imageSize),
            loop: false
        )
    );

    animation = anim;
    _hitbox = CircleHitbox(position: Vector2.all(64), radius: _radius, anchor: Anchor.center);

    add(_hitbox!);
    FlameAudio.play("sfx/explosion_${Random().nextInt(2) + 1}.wav", volume: AudioManager.getSfxVolune());
    animationTicker!.onComplete = () {
      removeFromParent();
    };

    super.onLoad();
  }


  @override
  void update(double dt) {
    explode(dt);
    super.update(dt);
  }

  //Nỗ theo diện tích hình tròn tăng dần
  void explode(double dt)
  {
    double explosionSize = (_size == ExplosionSize.big) ? _bigExplosionSize : _imageSize;
    if(_radius <= explosionSize / 2)
      {
        _radius += (2000 * dt).clamp(0, _imageSize / 2);
        _hitbox!.radius = _radius;
      }
  }

  //Tấn công các entity bị trúng nổ
  void attack()
  {
    print("exploding...");
    activeCollisions.toList().forEach((element) {
      if(element is PlaceableEntity && element.getTeam() != _myTeam)
        {
          element.getAttacked(EXPLOSION_DAMAGE);
        }
    });
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is PlaceableEntity)
    {
      print("Attacking $other");
      if(other.getTeam() != _myTeam)
      {
        attack();
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}