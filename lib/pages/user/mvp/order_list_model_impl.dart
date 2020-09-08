/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  11:13 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/shop/order/shop_order_list_page.dart';
import 'package:recook/pages/user/order/order_list_page.dart';

import 'package:recook/pages/user/mvp/order_list_contact.dart';

class OrderAfterSalesListModelImpl extends OrderAfterSalesListModelI{
  // type  int    1：代表售后中     2：代表已完成
  @override
  getAfterSalesList(int userId, int page, int type) async {
    ResultData resultData = await HttpManager.post(OrderApi.order_after_sales_goods_list, {"userId": userId, "page": page, "type": type});
    return resultData;
  }

  @override
  getShopAfterSalesList(int userId, int page, OrderPositionType positionType, int type) async {
    String position = '0'; // OrderPositionType.onlineOrder = 0
    if (positionType == OrderPositionType.storeOrder) {
      position = '1';
    }
    ResultData resultData = await HttpManager.post(ShopApi.order_list_aftersale, {"userId": userId, "page": page, "orderType": position, "type": type});
    return resultData;
  }
}

class OrderListModelImpl extends OrderListModelI {
  @override
  Future<ResultData> getOrderList(int userId, int page, OrderListType type, OrderPositionType positionType) async {
    String url;
    switch (type) {
      case OrderListType.all:
        url = OrderApi.order_list_all;
        break;
      case OrderListType.unpaid:
        url = OrderApi.order_list_unpaid;
        break;
      case OrderListType.undelivered:
        url = OrderApi.order_list_undelivered;
        break;
      case OrderListType.receipt:
        url = OrderApi.order_list_receipt;
        break;
      case OrderListType.afterSale:
        url = OrderApi.order_list_aftersale;
        break;
    }
    String position = '0'; // OrderPositionType.onlineOrder = 0
    if (positionType == OrderPositionType.storeOrder) {
      position = '1';
    }
    ResultData resultData = await HttpManager.post(url, {"userId": userId, "page": page, "orderType": position});
    return resultData;
  }

  @override
  getShopOrderList(int userId, int page, ShopOrderListType type, OrderPositionType positionType) async {
    String url;
    switch (type) {
      case ShopOrderListType.all:
        url = ShopApi.order_list_all;
        break;
      case ShopOrderListType.undelivered:
        url = ShopApi.order_list_undelivered;
        break;
      case ShopOrderListType.delivered:
        url = ShopApi.order_list_delivered;
        break;
      case ShopOrderListType.receipt:
        url = ShopApi.order_list_receipt;
        break;
      case ShopOrderListType.afterSale:
        url = ShopApi.order_list_aftersale;
        break;
    }
    String position = "0"; // OrderPositionType.onlineOrder = 0
    if (positionType == OrderPositionType.storeOrder) {
      position = "1";
    }
    ResultData resultData = await HttpManager.post(url, {"userId": userId, "page": page, "orderType": position});
    return resultData;
  }

  

  @override
  applyRefund(int userId, List<int> goodsIds, {num coin, String reasonContent, String reasonImg}) async {
    ResultData resultData = await HttpManager.post(
      OrderApi.order_refund, 
      {
        "userId": userId, 
        "orderGoodsIDs": goodsIds,
        "coin": coin,
        "reasonContent": reasonContent,
        "reasonImg": reasonImg
      }
    );
    return resultData;
  }

  @override
  applySalesReturn() {}

  @override
  cancelOrder(int userId, int orderId) async {
    ResultData resultData =
        await HttpManager.post(OrderApi.order_cancel, {"userId": userId, "orderId": orderId});
    return resultData;
  }
  @override
  deleteOrder(int userId, int orderId) async {
    ResultData resultData =
        await HttpManager.post(OrderApi.order_delete, {"userId": userId, "orderId": orderId});
    return resultData;
  }

  @override
  getOrderDetail(int userId, int orderId) async {
    ResultData resultData =
        await HttpManager.post(OrderApi.order_detail, {"userId": userId, "orderId": orderId});
    return resultData;
  }

  @override
  getShopOrderDetail(int userId, int orderId) async {
    ResultData resultData =
        await HttpManager.post(ShopApi.order_detail, {"userId": userId, "orderId": orderId});
    return resultData;
  }

  @override
  queryLogistic(int userId, int orderBrandId) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.express_logistic, {"userId": userId, "orderId": orderBrandId});
    return resultData;
  }

  @override
  Future<ResultData> addInvoice(int userId, int type, String title, String taxNo) async {
    ResultData resultData = await HttpManager.post(
        OrderApi.invoice_add, {"userId": userId, "type": type, "title": title, "taxNo": taxNo});
    return resultData;
  }

  @override
  Future<ResultData> getInvoiceList(int userId) async {
    ResultData resultData = await HttpManager.post(OrderApi.invoice_list, {"userId": userId});
    return resultData;
  }

  @override
  applyInvoice(int userId, int orderId, int invoiceId) async {
    ResultData resultData = await HttpManager.post(OrderApi.invoice_apply, {
      "userId": userId,
      "orderId": orderId,
      "invoiceId": invoiceId,
    });
    return resultData;
  }

  @override
  publishEvaluation(Map<String, dynamic> params) async {
    ResultData resultData = await HttpManager.post(OrderApi.evaluation_add, params);
    return resultData;
  }

  @override
  confirmReceipt(int userId, int orderId) async {
    ResultData resultData =
        await HttpManager.post(OrderApi.order_confirm_receipt, {"userId": userId, "orderId": orderId});
    return resultData;
  }

  

  
}
