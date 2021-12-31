/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  09:25 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:jingyaoyun/models/order_list_model.dart';
import 'package:jingyaoyun/pages/shop/order/shop_item_order_list.dart';
import 'package:jingyaoyun/pages/shop/order/shop_order_detail_page.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_contact.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/order/order_list_controller.dart';
import 'package:jingyaoyun/pages/user/order/order_list_page.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';

enum ShopOrderListType { all, undelivered, delivered, receipt , afterSale ,}

class ShopOrderListPage extends StatefulWidget {
  final ShopOrderListType type;
  final OrderPositionType positionType;
  final OrderListController controller;
  const ShopOrderListPage({Key key, this.type, this.positionType = OrderPositionType.onlineOrder, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShopOrderListPageState();
  }
}

class _ShopOrderListPageState extends BaseStoreState<ShopOrderListPage>
    with MvpListViewDelegate<OrderModel>
    implements OrderListViewI {
  OrderListPresenterImpl _presenter;
  MvpListViewController<OrderModel> _controller;

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  MvpListViewPresenterI<OrderModel, MvpView, MvpModel> getPresenter() {
    return _presenter;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.refresh = (){
      if (mounted && _controller!=null) {
        _controller.requestRefresh();
      }
    };
    _presenter = OrderListPresenterImpl();
    _presenter.attach(this);
    _controller = MvpListViewController();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return MvpListView<OrderModel>(
      delegate: this,
      controller: _controller,
      pageSize: 10,
      itemClickListener: (index) {
        OrderModel orderModel = _controller.getData()[index];
        AppRouter.push(globalContext, RouteName.SHOP_ORDER_DETAIL,
                arguments: ShopOrderDetailPage.setArguments(orderModel.id))
            .then(((result) {
          if (result == null) return;
          DPrint.printf(result);
          setState(() {
            orderModel.status = result;
          });
        }));
      },
      itemBuilder: (context, index) {
        OrderModel orderModel = _controller.getData()[index];
        return ShopOrderListItem(
          orderModel: orderModel,
        );
      },
      refreshCallback: () {
        _presenter.getShopOrderList(UserManager.instance.user.info.id, 0, widget.type, widget.positionType);
      },
      loadMoreCallback: (page) {
        _presenter.getShopOrderList(UserManager.instance.user.info.id, page, widget.type, widget.positionType);
      },
      noDataView: noDataView("没有订单数据哦~"),
    );
  }
 

  @override
  getOrderDetailSuccess(OrderDetailModel detailModel) {
    GSDialog.of(context).dismiss(globalContext);
  }

  @override
  refundSuccess(msg) {}

  @override
  failure(String msg) {
    GSDialog.of(context).showError(globalContext, msg);
  }

  @override
  void onDetach() {}

  @override
  void onAttach() {}

  @override
  applyInvoiceSuccess() {}

  @override
  cancelOrderSuccess(OrderModel order) {
  }

  @override
  deleteOrderSuccess(int orderId) {
  }

  @override
  confirmReceiptSuccess(model) {
  }

  
}
