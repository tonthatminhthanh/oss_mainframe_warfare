class UserScore
{
  int _kills;
  int _maxWave;
  List<dynamic> _achivements;

  UserScore({required int kills, required int maxWave, required List<dynamic> achievements}) : _kills = kills,
        _maxWave = maxWave, _achivements = achievements;

  factory UserScore.fromJson(Map<String, dynamic> json)
  {
    return UserScore(
      kills: json["kills"],
      maxWave: json["maxWave"],
      achievements: json["achievements"]
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      "kills": _kills,
      "maxWave": _maxWave,
      "achievements": _achivements
    };
  }

  int get maxWave => _maxWave;
  int get kills => _kills;
  List<dynamic> get achievements => _achivements;
}