import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/pages/home/model/aku_video_list_model.dart';

class ShoppingCartFuc {
  //获取可能喜欢列表
  static Future<List<GoodsSimple>> getLikeGoodsList(int user_id) async {
    ResultData result = await HttpManager.post(APIV2.userAPI.getLikeGoodsList, {
      'user_id': user_id, //未登录的时候传 0
    });

    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => GoodsSimple.fromJson(e))
            .toList();
      }
    }
  }

  //找相似
  static Future<List<GoodsSimple>> getSimilarGoodsList(int goods_id) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.getSimilarGoodsList, {
      'goods_id': goods_id,
    });

    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => GoodsSimple.fromJson(e))
            .toList();
      }
    }
  }

  //视频列表
  // static Future<String> addHits(int id) async {
  //   ResultData result = await HttpManager.post(APIV2.userAPI.addHits, {
  //     'id': id,
  //   });

  //   if (result.data != null) {
  //     return result.data['code'];
  //   }
  // }
}
