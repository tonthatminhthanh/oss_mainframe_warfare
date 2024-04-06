class UserScore
{
  String _uid;
  int _kills;
  int _maxWave;

  UserScore({required String uid, required int kills, required int maxWave}) : _kills = kills,
        _maxWave = maxWave, _uid = uid;

  factory UserScore.fromJson(Map<String, dynamic> json)
  {
    return UserScore(
      uid: json["uid"],
      kills: json["kills"],
      maxWave: json["maxWave"]
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      "uid": _uid,
      "kills": _kills,
      "maxWave": _maxWave
    };
  }

  int get maxWave => _maxWave;
  String get uid => _uid;
  int get kills => _kills;
}