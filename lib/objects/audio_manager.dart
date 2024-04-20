import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManager
{
  static AudioManager? _manager;

  late ValueNotifier<double> _sfxVolume;
  late ValueNotifier<double> _bgmVolume;

  bool volumeAdjusted = false;

  AudioPool? _rifleSfx;
  AudioPool? _shotgunSfx;
  AudioPool? _meleeSfx;
  AudioPool? _normalHitSfx, _lightArmorHitSfx, _heavyArmorHitSfx;

  AudioManager({required double sfxVolume, required double bgmVolume})
  {
    _sfxVolume = ValueNotifier(sfxVolume);
    _bgmVolume = ValueNotifier(bgmVolume);
  }
  
  static void createManager({required double sfxVolume, required double bgmVolume})
  {
    _manager = AudioManager(sfxVolume: sfxVolume, bgmVolume: bgmVolume);
    _manager!.volumeAdjusted = false;
  }

  static void setSfxVolume(double volume) async
  {
    _manager!._sfxVolume.value = volume;
    final _preferences = await SharedPreferences.getInstance();
    _preferences.setDouble("sfx", _manager!._sfxVolume.value);
  }

  static Future<void> setBgmVolume(double volume)
  async {
    _manager!._bgmVolume.value = volume;
    _manager!.volumeAdjusted = true;
    final _preferences = await SharedPreferences.getInstance();
    _preferences.setDouble("bgm", _manager!._bgmVolume.value);
  }

  static bool bgmAudioAdjusted()
  {
    return _manager!.volumeAdjusted;
  }

  static ValueNotifier<double> getSfxVolume()
  {
    return _manager!._sfxVolume;
  }

  static ValueNotifier<double> getBgmVolume()
  {
    return _manager!._bgmVolume;
  }

  static void playRifleSfx() async
  {
    //await _manager!._rifleSfx!.start(volume: _manager!._sfxVolume.value).catchError((e) {print("Audio Pool error: " + e.toString());});
  }

  static void loadSfxPool() async
  {
    /*_manager!._rifleSfx = await FlameAudio.createPool("sfx/shoot_rifle.wav",
        minPlayers: 5,
        maxPlayers: 10);
    _manager!._shotgunSfx = await FlameAudio.createPool("sfx/shoot_shotgun.wav",
        minPlayers: 5,
        maxPlayers: 10);
    _manager!._meleeSfx = await FlameAudio.createPool("sfx/melee_${Random().nextInt(3) + 1}.ogg",
        minPlayers: 5,
        maxPlayers: 10);
    _manager!._lightArmorHitSfx = await FlameAudio.createPool("sfx/hit_light_armor.wav",
        minPlayers: 5,
        maxPlayers: 10);
    _manager!._heavyArmorHitSfx = await FlameAudio.createPool("sfx/hit_heavy_armor.wav",
        minPlayers: 5,
        maxPlayers: 10);
    _manager!._normalHitSfx = await FlameAudio.createPool("sfx/hit_normal.wav",
        minPlayers: 5,
        maxPlayers: 10);*/
  }

  static void playShotgunSfx() async
  {
    //await _manager!._shotgunSfx!.start(volume: _manager!._sfxVolume.value);
  }

  static void playMeleeSound() async
  {
    //await _manager!._meleeSfx!.start(volume: _manager!._sfxVolume.value);
  }

  static void playHitSound(String botName) async
  {
    /*switch(botName)
    {
      case "light_armored_bot":
        await _manager!._lightArmorHitSfx!.start(volume: _manager!._sfxVolume.value);
        break;
      case "armored_bot":
        await _manager!._heavyArmorHitSfx!.start(volume: _manager!._sfxVolume.value);
        break;
      default:
        await _manager!._normalHitSfx!.start(volume: _manager!._sfxVolume.value);
        break;
    }*/
  }

  static void stopAllSfx()
  {
    /*if(_manager!._meleeSfx != null)
      {
        _manager!._meleeSfx!.dispose();
      }
    if(_manager!._shotgunSfx != null)
    {
      _manager!._shotgunSfx!.dispose();
    }
    if(_manager!._rifleSfx != null)
    {
      _manager!._rifleSfx!.dispose();
    }
    if(_manager!._normalHitSfx != null)
    {
      _manager!._normalHitSfx!.dispose();
    }
    if(_manager!._lightArmorHitSfx != null)
    {
      _manager!._lightArmorHitSfx!.dispose();
    }
    if(_manager!._heavyArmorHitSfx != null)
    {
      _manager!._heavyArmorHitSfx!.dispose();
    }*/
  }
}