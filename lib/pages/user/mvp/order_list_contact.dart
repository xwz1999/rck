/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  11:09 
 * remark    : 
 * ====================================================
 */

import 'package:recook/models/order_after_sales_list_model.dart';
import 'package:recook/models/order_detail_model.dart';
import 'package:recook/models/order_list_model.dart';
import 'package:recook/models/user_role_upgrade_model.dart';
import 'package:recook/pages/shop/order/shop_order_list_page.dart';
import 'package:recook/pages/user/order/order_list_page.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/utils/mvp.dart';

abstract class OrderListPresenterI
    extends MvpListViewPresenterI<OrderModel, OrderListViewI, OrderListModelI> {
  getOrderList(int userId, int page,  OrderListType type, OrderPositionType positionType);
  cancelOrder(int userId, int orderId,{OrderModel order});
  deleteOrder(int userId, int orderId);
  applyRefund(int usrId, List<int> goodsIds,{num coin, String reasonContent, String reasonImg});
  confirmReceipt(int userId, int orderId);
  applySalesReturn();
  getOrderDetail(int userId, int orderId);
  queryLogistic(int userId, int orderBrandId);
  getInvoiceList(int userId);
  addInvoice(int userId, int type, String title, String taxNo);
  applyInvoice(int userId, int orderId, int invoiceId);
  publishEvaluation(Map<String, dynamic> params);
  // getAfterSalesList(int userId, int page);
  getShopOrderList(int userId, int page, ShopOrderListType type, OrderPositionType positionType);
  getShopOrderDetail(int userId, int orderId);
}



abstract class OrderListModelI extends MvpModel {
  getOrderList(int userId, int page, OrderListType type, OrderPositionType positionType);
  cancelOrder(int userId, int orderId);
  deleteOrder(int userId, int orderId);
  applyRefund(int usrId, List<int> goodsIds,{num coin, String reasonContent, String reasonImg});
  confirmReceipt(int userId, int orderId);
  applySalesReturn();
  getOrderDetail(int userId, int orderId);
  queryLogistic(int userId, int orderBrandId);
  getInvoiceList(int userId);
  addInvoice(int userId, int type, String title, String taxNo);
  applyInvoice(int userId, int orderId, int invoiceId);
  publishEvaluation(Map<String, dynamic> params);
  // getAfterSalesList(int userId, int page);

  getShopOrderList(int userId, int page, ShopOrderListType type, OrderPositionType positionType);
  getShopOrderDetail(int userId, int orderId);
}

abstract class OrderListViewI extends MvpView {
  deleteOrderSuccess(int orderId);
  cancelOrderSuccess(OrderModel order);
  getOrderDetailSuccess(OrderDetailModel detail);
  refundSuccess(String msg);
  confirmReceiptSuccess(UserRoleUpgradeModel model);
  applyInvoiceSuccess();
  failure(String msg);
}





abstract class OrderAfterSalesListPresenterI
    extends MvpListViewPresenterI<OrderAfterSalesModel, OrderListViewI, OrderAfterSalesListModelI> {
  // getOrderList(int userId, int page,  OrderListType type);
  // cancelOrder(int userId, int orderId,{OrderModel order});
  // deleteOrder(int userId, int orderId);
  // applyRefund(int usrId, List<int> goodsIds);
  // applySalesReturn();
  // getOrderDetail(int userId, int orderId);
  // queryLogistic(int userId, int orderBrandId);
  // getInvoiceList(int userId);
  // addInvoice(int userId, int type, String title, String taxNo);
  // applyInvoice(int userId, int orderId, int invoiceId);
  // publishEvaluation(Map<String, dynamic> params);
  getAfterSalesList(int userId, int page, int type);
  getShopAfterSalesList(int userId, int page, OrderPositionType positionType, int type);
}

abstract class OrderAfterSalesListModelI extends MvpModel {
  // getOrderList(int userId, int page, OrderListType type);
  // cancelOrder(int userId, int orderId);
  // deleteOrder(int userId, int orderId);
  // applyRefund(int usrId, List<int> goodsIds);
  // applySalesReturn();
  // getOrderDetail(int userId, int orderId);
  // queryLogistic(int userId, int orderBrandId);
  // getInvoiceList(int userId);
  // addInvoice(int userId, int type, String title, String taxNo);
  // applyInvoice(int userId, int orderId, int invoiceId);
  // publishEvaluation(Map<String, dynamic> params);
  getAfterSalesList(int userId, int page, int type);
  getShopAfterSalesList(int userId, int page, OrderPositionType positionType, int type);
}
