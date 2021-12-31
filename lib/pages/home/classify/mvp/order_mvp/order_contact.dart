/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-19  12:41 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';

abstract class OrderPresenterI
    extends MvpListViewPresenterI<Object, OrderViewI, OrderModelI> {
  getStoreList();
  changeCoinOnOff(int userId, int orderId);
  changeAddress(int userId, int orderId, int addressId);
  changeShippingMethod(
      int userId, int orderId, int shippingMethod, int storeId);
  changeBuyerMessage(int userId, int orderId, String message);
  submitOrder(int orderPreviewId, int userId);
  queryRecookPayFund(int userId);
  createAliPayOrder(int userId, int orderId);
  createWeChatOrder(int userId, int orderId);
  createRecookPayOrder(int userId, int orderId, String password);
  createZeroPayOrder(int userId, int orderId);
  verifyOrderPayStatus(int orderId);
}

abstract class OrderModelI extends MvpModel {
  getStoreList();
  changeCoinOnOff(int userId, int orderId);
  changeAddress(int userId, int orderId, int addressId);
  changeShippingMethod(
      int userId, int orderId, int shippingMethod, int storeId);
  changeBuyerMessage(int userId, int orderId, String message);
  submitOrder(int orderPreviewId, int userId);
  queryRecookPayFund(int userId);
  createAliPayOrder(int userId, int orderId);
  createWeChatOrder(int userId, int orderId);
  createAliPayOrderLifang(int userId, int orderId);
  createWeChatOrderLifang(int userId, int orderId);
  createRecookPayOrder(int userId, int orderId, String password);
  createZeroPayOrder(int userId, int orderId);
  verifyOrderPayStatus(int orderId);
  verifyOrderPayStatusLifang(int orderId);
}

abstract class OrderViewI extends MvpView {}
