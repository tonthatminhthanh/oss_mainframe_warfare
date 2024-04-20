import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mw_project/actors/placeable_entity.dart';

class DefenderDescription
{
  late ValueNotifier<PlaceableEntity?> _currentlySelected;
  static DefenderDescription? _description;

  DefenderDescription();

  static void initializeDefenderDescription()
  {
    if(_description == null)
    {
      _description = DefenderDescription();
      _description!._currentlySelected = ValueNotifier<PlaceableEntity?>(null);
    }
  }

  static void selectEntity(PlaceableEntity entity)
  {
    initializeDefenderDescription();
    _description!._currentlySelected.value = entity;
  }

  static ValueNotifier<PlaceableEntity?> getEntity()
  {
    initializeDefenderDescription();
    return _description!._currentlySelected;
  }

  static Map<String, String> getDescription()
  {
    Map<String, String> temp = {
      "desc": "",
      "defence": "",
      "attack_strength": "",
      "attack_speed": ""
    };

    initializeDefenderDescription();
    String entityName = (
        _description!._currentlySelected.value != null
            ? _description!._currentlySelected.value!.getName() : ""
    );

    switch(entityName)
    {
      case "power_supply":
        temp["desc"] = "Tháp tạo tài nguyên ion để có thể mua các tháp khác.";
        temp["defence"] = "Bình thường";
        temp["attack_strength"] = "Không thể tấn công";
        temp["attack_speed"] = "Không thể tấn công";
        break;
      case "rifleman":
        temp["desc"] = "Tháp bắn đạn phát một.";
        temp["defence"] = "Bình thường";
        temp["attack_strength"] = "Bình thường";
        temp["attack_speed"] = "Bình thường";
        break;
      case "hunter":
        temp["desc"] = "Tháp bắn 2 viên đạn cùng một lúc";
        temp["defence"] = "Bình thường";
        temp["attack_strength"] = "Mạnh";
        temp["attack_speed"] = "Nhanh";
        break;
      case "claymore":
        temp["desc"] = "Trái mìn, có thể nổ trong khoảng 1x1 khi chạm vào";
        temp["defence"] = "Yếu";
        temp["attack_strength"] = "Mạnh";
        temp["attack_speed"] = "Nhanh";
        break;
      case "dynamite":
        temp["desc"] = "Quả bomb, nổ tung trong vài giây trong khoảng 3x3";
        temp["defence"] = "Yếu";
        temp["attack_strength"] = "Rất mạnh";
        temp["attack_speed"] = "Nhanh";
        break;
      case "test_dummy":
        temp["desc"] = "Tháp phòng thủ, có thể cầm chân kẻ thù";
        temp["defence"] = "Rất mạnh";
        temp["attack_strength"] = "Không thể tấn công";
        temp["attack_speed"] = "Không thể tấn công";
        break;
      case "laser_man":
        temp["desc"] = "Bắn đạn laze nhanh, có thể đi xuyên nhiều kẻ địch, "
            "nhưng bị vô hiệu hóa ở khoảng cách hơn 3 ô";
        temp["defence"] = "Bình thường";
        temp["attack_strength"] = "Bình thường";
        temp["attack_speed"] = "Rất nhanh";
        break;
      case "cannon":
        temp["desc"] = "Tháp đại bác, ấn vào tháp khi sẵn sàng để bắn bomb nổ 3x3";
        temp["defence"] = "Bình thường";
        temp["attack_strength"] = "Mạnh";
        temp["attack_speed"] = "Rất chậm";
        break;
      default:
        break;
    }
    return temp;
  }
}