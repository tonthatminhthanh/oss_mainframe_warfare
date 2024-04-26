import 'package:mw_project/constants/achievements_list.dart';

class UserScore
{
  String _name;
  String _uid;
  int _kills;
  int _maxWave;
  List<dynamic> _achivements;

  UserScore({required String uid, required String name,
    required int kills, required int maxWave, required List<dynamic> achievements}) : _kills = kills,
        _maxWave = maxWave, _uid = uid, _name = name, _achivements = achievements;

  factory UserScore.fromJson(Map<String, dynamic> json)
  {
    return UserScore(
      uid: json["uid"],
      name: json["full_name"],
      kills: json["kills"],
      maxWave: json["maxWave"],
      achievements: json["achievements"]
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      "uid": _uid,
      "kills": _kills,
      "maxWave": _maxWave,
      "full_name": _name,
      "achievements": _achivements
    };
  }

  int get maxWave => _maxWave;
  String get uid => _uid;
  int get kills => _kills;
  String get name => _name;
  List<dynamic> get achievements => _achivements;
}