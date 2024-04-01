class UserScore
{
  int _kills;
  int _maxWave;

  UserScore({required int kills, required int maxWave}) : _kills = kills,
        _maxWave = maxWave;

  factory UserScore.fromJson(Map<String, dynamic> json)
  {
    return UserScore(
      kills: json["kills"],
      maxWave: json["maxWave"]
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      "kills": _kills,
      "maxWave": _maxWave
    };
  }
}