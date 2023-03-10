import 'package:jingyaoyun/pages/live/models/goods_window_model.dart';
import 'package:jingyaoyun/pages/live/models/live_brand_model.dart';

class PickCart {
  static List<GoodsList> picked = [];

  static List<GoodsList> carPicked = [];
  static List<GoodsList> goodsPicked = [];
  
  static int type = 0;
  static bool carManager = false;
  static bool goodsManager = false;

  static LiveBrandModel brandModel;

  static List<String> history = [];

  static addHistory(String text) {
    if (history.length < 8) {
      history.insert(0, text);
    } else {
      history.removeLast();
      history.insert(0, text);
    }
  }
}
