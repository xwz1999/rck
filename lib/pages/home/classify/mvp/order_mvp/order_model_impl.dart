/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-19  12:43 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/home/classify/mvp/order_mvp/order_contact.dart';

class OrderModelImpl extends OrderModelI {
  @override
  Future<ResultData> submitOrder(int? orderPreviewId, int? userId) async {
    ResultData resultData = await HttpManager.post(OrderApi.order_normal_submit,
        {"userId": userId, "previewOrderId": orderPreviewId});
    return resultData;
  }

  @override
  changeCoinOnOff(int userId, int orderId) async {
    ResultData resultData = await HttpManager.post(OrderApi.order_coin_onoff,
        {"userId": userId, "previewOrderId": orderId});
    return resultData;
  }

  @override
  Future<ResultData> changeAddress(
      int? userId, int? orderId, int? addressId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_change_address,
        {"userId": userId, "orderId": orderId, "addressId": addressId});
    return resultData;
  }

  @override
  Future<ResultData> changeShippingMethod(
      int? userId, int? orderId, int shippingMethod, int? storeId) async {
    ResultData resultData =
        await HttpManager.post(OrderApi.order_change_shipping_method, {
      "userId": userId,
      "orderId": orderId,
      "shippingMethod": shippingMethod,
      "storeId": storeId
    });
    return resultData;
  }

  @override
  Future<ResultData> getStoreList() async {
    ResultData resultData =
        await HttpManager.post(OrderApi.order_store_list, {});
    return resultData;
  }

  @override
  Future<ResultData> changeBuyerMessage(
      int? userId, int? orderId, String message) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_change_buyer_message,
        {"userId": userId, "orderId": orderId, "message": message});
    return resultData;
  }

  @override
  Future<ResultData> createAliPayOrder(int? userId, int? orderId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_alipay_order_create,
        {"userId": userId, "orderId": orderId});
    return resultData;
  }

  @override
  Future<ResultData> createWeChatOrder(int? userId, int? orderId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_wechat_order_create,
        {"userId": userId, "orderId": orderId});
    return resultData;
  }

  @override
  Future<ResultData> createAliPayOrderLifang(int? userId, int? orderId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_alipay_order_create_lifang,
        {"userId": userId, "orderId": orderId});
    return resultData;
  }

  @override
  Future<ResultData> createWeChatOrderLifang(int? userId, int? orderId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_wechat_order_create_lifang,
        {"userId": userId, "orderId": orderId});
    return resultData;
  }

  @override
  Future<ResultData> verifyOrderPayStatus(int? orderId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_verify_pay_status, {"orderId": orderId});
    return resultData;
  }

  @override
  Future<ResultData> verifyOrderPayStatusLifang(int orderId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_verify_pay_status_lifang, {"order_id": orderId});
    return resultData;
  }

  @override
  queryRecookPayFund(int? userId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_query_recook_pay_fund, {"userId": userId});
    return resultData;
  }

  @override
  createRecookPayOrder(int? userId, int? orderId, String password) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_recook_pay_order_create,
        {"userId": userId, "orderId": orderId, 'password': password});
    return resultData;
  }



  @override
  createZeroPayOrder(int? userId, int? orderId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_pay_zero, {"userId": userId, "orderId": orderId});
    return resultData;
  }

  @override
  createRecookPayOrderDeposit(int? userId, int? orderId, String password) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.order_recook_pay_order_create_deposit,
        {"userId": userId, "orderId": orderId, 'password': password});
    return resultData;
  }
}
