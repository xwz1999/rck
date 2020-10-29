import 'package:recook/pages/live/models/goods_window_model.dart';
import 'package:recook/pages/live/models/live_brand_model.dart';

class PickCart {
  static List<GoodsList> picked = [];

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
