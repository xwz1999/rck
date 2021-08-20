/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-23  15:51 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'shopping_cart_contact.dart';

class ShoppingCartModelImpl extends ShoppingCartModelI {
  //购物车接口
  @override
  Future<ResultData> getShoppingCartList(int userID) async {
    ResultData resultData =
        await HttpManager.post(GoodsApi.shopping_cart_list, {"userID": userID});
    print(resultData);
    return resultData;
  }

  @override
  Future<ResultData> addToShoppingCart(
      int userID, int skuID, String skuName, int quantity) async {
    ResultData resultData = await HttpManager.post(
        GoodsApi.goods_add_shopping_cart, {
      "userID": userID,
      "skuID": skuID,
      "skuName": skuName,
      "quantity": quantity
    });
    return resultData;
  }

  @override
  Future<ResultData> deleteFromShoppingCart(
      int userID, List<int> cartIDs) async {
    ResultData resultData = await HttpManager.post(
        GoodsApi.shopping_cart_delete,
        {"trolleyGoodsIDs": cartIDs, "userID": userID});
    return resultData;
  }

  @override
  Future<ResultData> updateQuantity(int userID, goods, int quantity) async {
    ResultData resultData =
        await HttpManager.post(GoodsApi.shopping_cart_update_quantity, {
      "userId": userID,
      "shoppingTrolleyId": goods.shoppingTrolleyId,
      "quantity": quantity
    });
    return resultData;
  }

  @override
  Future<ResultData> submitOrder(int userId, List<int> cardIds) async {
    ResultData resultData = await HttpManager.post(
        GoodsApi.shopping_cart_submit_order,
        {"userId": userId, "ids": cardIds});
    return resultData;
  }
}
