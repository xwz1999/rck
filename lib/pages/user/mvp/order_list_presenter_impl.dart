/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  11:12 
 * remark    : 
 * ====================================================
 */

import 'package:recook/base/http_result_model.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/invoice_list_model.dart';
import 'package:recook/models/logistic_list_model.dart';
import 'package:recook/models/order_after_sales_list_model.dart';
import 'package:recook/models/order_detail_model.dart';
import 'package:recook/models/order_list_model.dart';
import 'package:recook/models/user_role_upgrade_model.dart';
import 'package:recook/pages/shop/order/shop_order_list_page.dart';
import 'package:recook/pages/user/order/order_list_page.dart';
import 'package:recook/pages/user/mvp/order_list_contact.dart';
import 'package:recook/pages/user/mvp/order_list_model_impl.dart';

class OrderAfterSalesListPresenterImpl extends OrderAfterSalesListPresenterI{
  @override
  OrderAfterSalesListModelI initModel() {
    return OrderAfterSalesListModelImpl();
  }
  @override
  getAfterSalesList(int userId, int page, int type) async {
    ResultData resultData = await getModel().getAfterSalesList(userId, page, type);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    OrderAfterSalesListModel orderListModel = OrderAfterSalesListModel.fromJson(resultData.data);
    if (orderListModel.code != HttpStatus.SUCCESS) {
      getView()?.failure(orderListModel.msg);
      return;
    }

    if (page == 0) {
      getRefreshView()?.refreshSuccess(orderListModel.data);
    } else {
      getRefreshView().loadMoreSuccess(orderListModel.data);
    }
  }

  @override
  getShopAfterSalesList(int userId, int page, OrderPositionType positionType, int type) async {
    ResultData resultData = await getModel().getShopAfterSalesList(userId, page, positionType, type);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    OrderAfterSalesListModel orderListModel = OrderAfterSalesListModel.fromJson(resultData.data);
    if (orderListModel.code != HttpStatus.SUCCESS) {
      getView()?.failure(orderListModel.msg);
      return;
    }

    if (page == 0) {
      getRefreshView()?.refreshSuccess(orderListModel.data);
    } else {
      getRefreshView().loadMoreSuccess(orderListModel.data);
    }
  }
  
}

class OrderListPresenterImpl extends OrderListPresenterI {
  @override
  OrderListModelI initModel() {
    return OrderListModelImpl();
  }

  @override
  getOrderList(int userId, int page, OrderListType type, OrderPositionType positionType) async {
    ResultData resultData = await getModel().getOrderList(userId, page, type, positionType);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    OrderListModel orderListModel = OrderListModel.fromJson(resultData.data);
    if (orderListModel.code != HttpStatus.SUCCESS) {
      getView()?.failure(orderListModel.msg);
      return;
    }

    if (page == 0) {
      getRefreshView()?.refreshSuccess(orderListModel.data);
    } else {
      getRefreshView().loadMoreSuccess(orderListModel.data);
    }
  }

  @override
  getShopOrderList(int userId, int page, ShopOrderListType type, OrderPositionType positionType) async {
    ResultData resultData = await getModel().getShopOrderList(userId, page, type, positionType);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    OrderListModel orderListModel = OrderListModel.fromJson(resultData.data);
    if (orderListModel.code != HttpStatus.SUCCESS) {
      getView()?.failure(orderListModel.msg);
      return;
    }
    if (page == 0) {
      getRefreshView()?.refreshSuccess(orderListModel.data);
    } else {
      getRefreshView().loadMoreSuccess(orderListModel.data);
    }
  }

  @override
  Future<OrderDetailModel> getOrderDetail(int userId, int orderId) async {
    ResultData resultData = await getModel().getOrderDetail(userId, orderId);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return null;
    }
    OrderDetailModel model = OrderDetailModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView()?.failure(model.msg);
      return null;
    }
    getView()?.getOrderDetailSuccess(model);
    return model;
  }

  @override
  getShopOrderDetail(int userId, int orderId) async {
    ResultData resultData = await getModel().getShopOrderDetail(userId, orderId);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return null;
    }
    OrderDetailModel model = OrderDetailModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView()?.failure(model.msg);
      return null;
    }
    getView()?.getOrderDetailSuccess(model);
    return model;
  }

  @override
  applyRefund(int usrId, List<int> goodsIds,{num coin, String reasonContent, String reasonImg}) async {
    ResultData resultData = await getModel().applyRefund(usrId, goodsIds,coin: coin, reasonContent: reasonContent, reasonImg: reasonImg);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView()?.failure(model.msg);
      return;
    }
    getView()?.refundSuccess(model.msg);
  }

  @override
  applySalesReturn() {}

  @override
  cancelOrder(int userId, int orderId, {OrderModel order}) async {
    ResultData resultData = await getModel().cancelOrder(userId, orderId);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView()?.failure(model.msg);
      return;
    }
    getView()?.cancelOrderSuccess(order);
  }

  @override
  deleteOrder(int userId, int orderId,) async {
    ResultData resultData = await getModel().deleteOrder(userId, orderId);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView()?.failure(model.msg);
      return;
    }
    // getView()?.cancelOrderSuccess(order);
    getView()?.deleteOrderSuccess(orderId);
  }

  @override
  Future<HttpResultModel<LogisticListModel>> queryLogistic(int userId, int orderId) async {
    ResultData resultData = await getModel().queryLogistic(userId, orderId);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }

    LogisticListModel model = LogisticListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView()?.failure(model.msg);
      return HttpResultModel(model.code, null, model.msg, false);
    }
    return HttpResultModel(model.code, model ?? [], model.msg, true);
  }

  @override
  Future<HttpResultModel<BaseModel>> addInvoice(
      int userId, int type, String title, String taxNo) async {
    ResultData resultData = await getModel().addInvoice(userId, type, title, taxNo);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    BaseModel resultModel = BaseModel.fromJson(resultData.data);
    if (resultModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(resultModel.code, null, resultModel.msg, false);
    }
    return HttpResultModel(resultModel.code, null, resultModel.msg, true);
  }

  @override
  Future<HttpResultModel<List<Invoice>>> getInvoiceList(int userId) async {
    ResultData resultData = await getModel().getInvoiceList(userId);
    if (!resultData.result) {
      return HttpResultModel(resultData.code, null, resultData.msg, false);
    }
    InvoiceListModel resultModel = InvoiceListModel.fromJson(resultData.data);
    if (resultModel.code != HttpStatus.SUCCESS) {
      return HttpResultModel(resultModel.code, null, resultModel.msg, false);
    }
    return HttpResultModel(resultModel.code, resultModel.data, resultModel.msg, true);
  }

  @override
  applyInvoice(int userId, int orderId, int invoiceId) async {
    ResultData resultData = await getModel().applyInvoice(userId, orderId, invoiceId);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }

    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView()?.failure(model.msg);
      return;
    }

    getView()?.applyInvoiceSuccess();
  }

  @override
  Future<HttpResultModel<BaseModel>> publishEvaluation(Map<String, dynamic> params) async {
    ResultData resultData = await getModel().publishEvaluation(params);
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
  confirmReceipt(int userId, int orderId) async {
    ResultData resultData = await getModel().confirmReceipt(userId, orderId);
    if (!resultData.result) {
      getView()?.failure(resultData.msg);
      return;
    }
    UserRoleUpgradeModel model = UserRoleUpgradeModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      getView()?.failure(model.msg);
      return;
    }
    getView()?.confirmReceiptSuccess(model);
  }

  

  // @override
  // getAfterSalesList(int userId, int page) async {
  //   ResultData resultData = await getModel().getAfterSalesList(userId, page);
  //   if (!resultData.result) {
  //     getView()?.failure(resultData.msg);
  //     return;
  //   }
  //   OrderAfterSalesListModel orderListModel = OrderAfterSalesListModel.fromJson(resultData.data);
  //   if (orderListModel.code != HttpStatus.SUCCESS) {
  //     getView()?.failure(orderListModel.msg);
  //     return;
  //   }

  //   if (page == 0) {
  //     getRefreshView()?.refreshSuccess(orderListModel.data);
  //   } else {
  //     getRefreshView().loadMoreSuccess(orderListModel.data);
  //   }
  // }
}
