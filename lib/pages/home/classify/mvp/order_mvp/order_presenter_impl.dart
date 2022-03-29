/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-14  10:20 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/base/http_result_model.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/PayInfoModel.dart';
import 'package:jingyaoyun/models/alipay_order_model.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/order_prepay_model.dart';
import 'package:jingyaoyun/models/order_preview_model.dart';
import 'package:jingyaoyun/models/pay_result_model.dart';
import 'package:jingyaoyun/models/recook_fund_model.dart';
import 'package:jingyaoyun/models/self_pickup_store_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/order_mvp/order_model_impl.dart';

import 'order_contact.dart';

class OrderPresenterImpl extends OrderPresenterI {
  @override
  OrderModelI initModel() {
    return OrderModelImpl();
  }

  @override
  changeCoinOnOff(int userId, int orderId) async {
    ResultData resultData = await getModel().changeCoinOnOff(userId, orderId );
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    OrderPreviewModel orderModel = OrderPreviewModel.fromJson(resultData.data);
    if (orderModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(orderModel.code, null, orderModel.msg, false);
    }
    return HttpResultModel(orderModel.code, orderModel, orderModel.msg, true);
  }

  @override
  Future<HttpResultModel<OrderPreviewModel>> changeAddress(
      int userId, int orderId, int addressId) async {
    ResultData resultData = await getModel().changeAddress(userId, orderId, addressId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    OrderPreviewModel orderModel = OrderPreviewModel.fromJson(resultData.data);
    if (orderModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(orderModel.code, null, orderModel.msg, false);
    }
    return HttpResultModel(orderModel.code, orderModel, orderModel.msg, true);
  }

  @override
  Future<HttpResultModel<BaseModel>> changeBuyerMessage(
      int userId, int orderId, String message) async {
    ResultData resultData = await getModel().changeBuyerMessage(userId, orderId, message);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  Future<HttpResultModel<OrderPreviewModel>> changeShippingMethod(
      int userId, int orderId, int shippingMethod, int storeId) async {
    ResultData resultData =
        await getModel().changeShippingMethod(userId, orderId, shippingMethod, storeId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    OrderPreviewModel orderModel = OrderPreviewModel.fromJson(resultData.data);
    if (orderModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(orderModel.code, null, orderModel.msg, false);
    }
    return HttpResultModel(orderModel.code, orderModel, orderModel.msg, true);
  }

  @override
  Future<HttpResultModel<SelfPickupStoreListModel>> getStoreList() async {
    ResultData resultData = await getModel().getStoreList();
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    SelfPickupStoreListModel model = SelfPickupStoreListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  Future<HttpResultModel<AlipayOrderModel>> createAliPayOrder(int userId, int orderId) async {
    ResultData resultData = await getModel().createAliPayOrder(userId, orderId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    AlipayOrderModel aliPayModel = AlipayOrderModel.fromJson(resultData.data);
    if (aliPayModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(aliPayModel.code, null, aliPayModel.msg, false);
    }
    return HttpResultModel(aliPayModel.code, aliPayModel, aliPayModel.msg, true);
  }

    @override
  Future<HttpResultModel<AlipayOrderModel>> createAliPayOrderLifang(int userId, int orderId) async {
    ResultData resultData = await getModel().createAliPayOrderLifang(userId, orderId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    AlipayOrderModel aliPayModel = AlipayOrderModel.fromJson(resultData.data);
    if (aliPayModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(aliPayModel.code, null, aliPayModel.msg, false);
    }
    return HttpResultModel(aliPayModel.code, aliPayModel, aliPayModel.msg, true);
  }

  @override
  Future<HttpResultModel<PayInfoModel>> createWeChatOrder(int userId, int orderId) async {
    ResultData resultData = await getModel().createWeChatOrder(userId, orderId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    PayInfoModel wxPayModel = PayInfoModel.fromJson(resultData.data);
    if (wxPayModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(wxPayModel.code, null, wxPayModel.msg, false);
    }
    return HttpResultModel(wxPayModel.code, wxPayModel, wxPayModel.msg, true);
  }


    @override
  Future<HttpResultModel<PayInfoModel>> createWeChatOrderLifang(int userId, int orderId) async {
    ResultData resultData = await getModel().createWeChatOrderLifang(userId, orderId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    PayInfoModel wxPayModel = PayInfoModel.fromJson(resultData.data);
    if (wxPayModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(wxPayModel.code, null, wxPayModel.msg, false);
    }
    return HttpResultModel(wxPayModel.code, wxPayModel, wxPayModel.msg, true);
  }

  @override
  Future<HttpResultModel<OrderPrepayModel>> submitOrder(int orderPreviewId, int userId) async {
    ResultData resultData = await getModel().submitOrder(orderPreviewId, userId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    OrderPrepayModel model = OrderPrepayModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model, model.msg, true);
  }

  @override
  Future<HttpResultModel<PayResult>> verifyOrderPayStatus(int orderId) async {
    ResultData resultData = await getModel().verifyOrderPayStatus(orderId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    PayResultModel resultModel = PayResultModel.fromJson(resultData.data);
    if (resultModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(resultModel.code, null, resultModel.msg, false);
    }
    return HttpResultModel(resultModel.code, resultModel.data, resultModel.msg, true);
  }

    @override
  Future<HttpResultModel<PayResult>> verifyOrderPayStatusLifang(int orderId) async {
    ResultData resultData = await getModel().verifyOrderPayStatusLifang(orderId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    PayResultModel resultModel = PayResultModel.fromJson(resultData.data);
    if (resultModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(resultModel.code, null, resultModel.msg, false);
    }
    return HttpResultModel(resultModel.code, resultModel.data, resultModel.msg, true);
  }

  @override
  Future<HttpResultModel<RecookFundModel>> queryRecookPayFund(int userId) async {
    ResultData resultData = await getModel().queryRecookPayFund(userId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    RecookFundModel resultModel = RecookFundModel.fromJson(resultData.data);
    if (resultModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(resultModel.code, null, resultModel.msg, false);
    }
    return HttpResultModel(resultModel.code, resultModel, resultModel.msg, true);
  }

  @override
  Future<HttpResultModel<BaseModel>> createRecookPayOrder(int userId, int orderId, String password) async {
    ResultData resultData = await getModel().createRecookPayOrder(userId, orderId, password);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel resultModel = BaseModel.fromJson(resultData.data);
    if (resultModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(resultModel.code, null, resultModel.msg, false);
    }
    return HttpResultModel(resultModel.code, resultModel, resultModel.msg, true);
  }

  @override
  Future<HttpResultModel<BaseModel>> createRecookPayOrderDeposit(int userId, int orderId, String password) async {
    ResultData resultData = await getModel().createRecookPayOrderDeposit(userId, orderId, password);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel resultModel = BaseModel.fromJson(resultData.data);
    if (resultModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(resultModel.code, null, resultModel.msg, false);
    }
    return HttpResultModel(resultModel.code, resultModel, resultModel.msg, true);
  }


  @override
  Future<HttpResultModel<BaseModel>> createZeroPayOrder(int userId, int orderId) async {
    ResultData resultData = await getModel().createZeroPayOrder(userId, orderId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel resultModel = BaseModel.fromJson(resultData.data);
    if (resultModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(resultModel.code, null, resultModel.msg, false);
    }
    return HttpResultModel(resultModel.code, resultModel, resultModel.msg, true);
  }

  
}
