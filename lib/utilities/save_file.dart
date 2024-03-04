class SaveFile
{
  int currentWave;
  int defenderMoney;
  List<Map<String, dynamic>> tiles;
  
  SaveFile({required this.currentWave, required this.defenderMoney,
    required this.tiles});

  SaveFile.fromJson(Map<String, dynamic> json) :
        currentWave = json['current_wave'],
        defenderMoney = json['money'],
        tiles = List<Map<String, dynamic>>.from(json["tiles"]);

  Map<String, dynamic> toJson()
  {
    return {
      "current_wave": currentWave,
      "money": defenderMoney,
      "tiles": tiles
    };
  }
}