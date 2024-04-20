class UserScore
{
  String _name;
  String _uid;
  int _kills;
  int _maxWave;

  UserScore({required String uid, required String name, required int kills, required int maxWave}) : _kills = kills,
        _maxWave = maxWave, _uid = uid, _name = name;

  factory UserScore.fromJson(Map<String, dynamic> json)
  {
    return UserScore(
      uid: json["uid"],
      name: json["full_name"],
      kills: json["kills"],
      maxWave: json["maxWave"]
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      "uid": _uid,
      "kills": _kills,
      "maxWave": _maxWave,
      "full_name": _name
    };
  }

  int get maxWave => _maxWave;
  String get uid => _uid;
  int get kills => _kills;
  String get name => _name;
}