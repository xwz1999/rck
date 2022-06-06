import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/goods_simple_list_model.dart';

class ShoppingCartFuc {
  //获取可能喜欢列表
  static Future<List<GoodsSimple>?> getLikeGoodsList(int? userId,{bool isSale = false}) async {
    Map<String, dynamic> params = {
      "user_id": userId,
    };

    if (isSale) {
      params.putIfAbsent("is_sale", () => isSale);
    }

    ResultData result = await HttpManager.post(APIV2.userAPI.getLikeGoodsList, params);

    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => GoodsSimple.fromJson(e))
            .toList();
      }
    }
    return null;
  }

  //找相似
  static Future<List<GoodsSimple>?> getSimilarGoodsList(int? goodsId) async {
    ResultData result =
        await HttpManager.post(APIV2.userAPI.getSimilarGoodsList, {
      'goods_id': goodsId,
    });

    if (result.data != null) {
      if (result.data['data'] != null) {
        return (result.data['data'] as List)
            .map((e) => GoodsSimple.fromJson(e))
            .toList();
      }
    }
    return null;
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
