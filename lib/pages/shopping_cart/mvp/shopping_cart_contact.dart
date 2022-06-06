/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-23  15:19 
 * remark    : 
 * ====================================================
 */

import 'package:recook/models/order_preview_model.dart';
import 'package:recook/models/shopping_cart_list_model.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class ShoppingCartPresenterI
    extends MvpListViewPresenterI<ShoppingCartBrandModel, ShoppingCartViewI, ShoppingCartModelI> {
  getShoppingCartList(int userID);
  addToShoppingCart(int userID, int skuID, String skuName, int quantity);
  deleteFromShoppingCart(int userID, List<int> cartIDs);
  updateQuantity(int userID, ShoppingCartGoodsModel goods, int quantity);
  submitOrder(int userId, List<int> cardIds);
}

abstract class ShoppingCartModelI extends MvpModel {
  getShoppingCartList(int? userID);
  addToShoppingCart(int userID, int skuID, String skuName, int quantity);
  deleteFromShoppingCart(int? userID, List<int?> cartIDs);
  updateQuantity(int? userID, ShoppingCartGoodsModel goods, int quantity);
  submitOrder(int? userId, List<int?> cardIds);
}

abstract class ShoppingCartViewI extends MvpView {
  void updateNumSuccess(ShoppingCartGoodsModel goods, int num);
  void updateNumFail(String? msg);
  void deleteGoodsSuccess();
  void submitOrderSuccess(OrderPreviewModel model);
  void failure(String? msg);
}
