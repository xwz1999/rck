/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-26  15:13 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/http_manager.dart';

import 'my_favorite_contact.dart';

class MyFavoriteModelImpl extends MyFavoriteModelI {
  @override
  favoriteAdd(int userID, int goodsID) async {
    ResultData res =
        await HttpManager.post(GoodsApi.goods_favorite_add, {"userID": userID, "goodsID": goodsID});
    return res;
  }

  @override
  favoriteCancel(int userID, int goodsID) async {
    ResultData res = await HttpManager.post(
        GoodsApi.goods_favorite_cancel, {"userId": userID, "goodsId": goodsID});
    return res;
  }

  @override
  getFavoritesList(int userId) async {
    ResultData res = await HttpManager.post(GoodsApi.goods_favorite_list, {
      "userId": userId,
    });
    return res;
  }
}
