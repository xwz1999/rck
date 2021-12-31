/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-23  15:51 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/order_preview_model.dart';
import 'package:jingyaoyun/models/shopping_cart_list_model.dart';
import 'shopping_cart_contact.dart';
import 'shopping_cart_model_impl.dart';

class ShoppingCartPresenterImpl extends ShoppingCartPresenterI {
  @override
  addToShoppingCart(int userID, int skuID, String skuName, int quantity) {
    return null;
  }

  @override
  deleteFromShoppingCart(int userID, List<int> cartIDs) async {
    ResultData resultData =
        await getModel().deleteFromShoppingCart(userID, cartIDs);
    if (!resultData.result) {
      getView().failure(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView().failure(model.msg);
      return;
    }
    getView().deleteGoodsSuccess();
  }

  @override
  getShoppingCartList(int userID) async {
    ResultData resultData = await getModel().getShoppingCartList(userID);
    if (!resultData.result) {
      getView().failure(resultData.msg);
      return;
    }
    ShoppingCartListModel model =
        ShoppingCartListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView().failure(resultData.msg);
      return;
    }
    getRefreshView().refreshSuccess(model.data);
  }

  @override
  updateQuantity(int userID, ShoppingCartGoodsModel goods, int quantity) async {
    ResultData resultData =
        await getModel().updateQuantity(userID, goods, quantity);
    if (!resultData.result) {
      getView().failure(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView().updateNumFail(model.msg);
      return;
    }
    getView().updateNumSuccess(goods, quantity);
  }

  @override
  ShoppingCartModelI initModel() {
    return ShoppingCartModelImpl();
  }

  @override
  submitOrder(int userId, List<int> cardIds) async {

    ResultData resultData =
        await getModel().submitOrder(userId, cardIds);
    if (!resultData.result) {
      getView().failure(resultData.msg);
      return;
    }
    OrderPreviewModel model = OrderPreviewModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView().failure(model.msg);
      return;
    }
    getView().submitOrderSuccess(model);
  }
}
