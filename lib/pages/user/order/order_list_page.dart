/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  09:25 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/order_detail_model.dart';
import 'package:recook/models/order_list_model.dart';
import 'package:recook/models/order_prepay_model.dart';
import 'package:recook/models/user_role_upgrade_model.dart';
import 'package:recook/pages/home/classify/order_prepay_page.dart';
import 'package:recook/pages/user/items/item_order_list.dart';
import 'package:recook/pages/user/mvp/order_list_contact.dart';
import 'package:recook/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:recook/pages/user/order/order_detail_page.dart';
import 'package:recook/pages/user/order/order_list_controller.dart';
import 'package:recook/pages/user/order/publish_evaluation_page.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

enum OrderPositionType {
  onlineOrder,  // 线上订单
  storeOrder,   // 门店订单
  }
enum OrderListType { all, unpaid, undelivered, receipt , afterSale ,}

class OrderListPage extends StatefulWidget {
  final OrderListType type;
  final OrderPositionType positionType;
  final OrderListController controller;

  const OrderListPage({Key key, this.type, this.positionType=OrderPositionType.onlineOrder, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OrderListPageState();
  }
}

class _OrderListPageState extends BaseStoreState<OrderListPage>
    with MvpListViewDelegate<OrderModel>
    implements OrderListViewI {
  OrderListPresenterImpl _presenter;
  MvpListViewController<OrderModel> _controller;
  OrderModel _confirmModel;
  VoidCallback _cancelCallback;

  @override
  bool get wantKeepAlive {
    return false;
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
        AppRouter.push(globalContext, RouteName.ORDER_DETAIL,
                arguments: OrderDetailPage.setArguments(orderModel.id))
            .then(((result) {
              _controller.requestRefresh();
          if (result == null) return;
          DPrint.printf(result);
          setState(() {
            orderModel.status = result;
          });
        }));
//        GSDialog.of(context).showLoadingDialog(context, "");
//        _presenter.getOrderDetail(UserManager.instance.user.info.id, _controller.getData()[index].id);
      },
      itemBuilder: (context, index) {
        return OrderListItem(
          orderModel: _controller.getData()[index],
          cancelOrder: (OrderModel order, {callback}) {
            _cancelCallback = callback;
            _cancelOrder(order);
          },
          goToPay: (OrderModel order, {callback}) {
            _goToPay(order);
          },
          delete: (OrderModel order, {callback}){
            _deleteOrder(order);
          },
          confirm: (OrderModel order, {callback}){
            _confirmReceiptClick(order);
          },
          applyRefund: (OrderModel order, {callback}) {},
          evaluation: (OrderModel order, {callback}) {
            List<EvaluationGoodsModel> goodsList = [];
            order.goodsList.forEach((goods){
              if (goods.assType == 0) {
                goodsList.add(EvaluationGoodsModel(id: goods.goodsId, mainPhotoUrl: goods.mainPhotoUrl, goodsName: goods.goodsName));
              }
            });
            // order.brands.forEach((brand) {
            //   brand.goods.forEach((goods) {
            //     goodsList.add(EvaluationGoodsModel(
            //         id: goods.goodsId, mainPhotoUrl: goods.mainPhotoUrl, goodsName: goods.goodsName));
            //   });
            // });
            
            push(RouteName.ORDER_EVALUATION,
                arguments:
                    PublishEvaluationPage.setArguments(orderId: order.id, goodsList: goodsList));
          },
        );
      },
      refreshCallback: () {
        _presenter.getOrderList(UserManager.instance.user.info.id, 0, widget.type, widget.positionType);
      },
      loadMoreCallback: (page) {
        _presenter.getOrderList(UserManager.instance.user.info.id, page, widget.type, widget.positionType);
      },
      noDataView: noDataView("没有订单数据哦~"),
    );
  }

  _deleteOrder(OrderModel order){
    Alert.show(
        globalContext,
        NormalTextDialog(
          content: "确定删除订单吗？删除后将不能撤销",
          items: ["我再想想", "确认"],
          listener: (int index) {
            Alert.dismiss(globalContext);
            if (index == 0) return;
            GSDialog.of(context).showLoadingDialog(globalContext, "");
            _presenter.deleteOrder(UserManager.instance.user.info.id, order.id);
          },
        ));
  }
  _cancelOrder(OrderModel order) {
    Alert.show(
        globalContext,
        NormalTextDialog(
          content: "确定取消订单吗？取消后将不能撤销",
          items: ["我再想想", "确认"],
          listener: (int index) {
            Alert.dismiss(globalContext);
            if (index == 0) return;
            GSDialog.of(context).showLoadingDialog(globalContext, "");
            _presenter.cancelOrder(UserManager.instance.user.info.id, order.id, order: order);
          },
        ));
  }

  _goToPay(OrderModel order) async {
    Data data = Data(order.id, order.userId, order.actualTotalAmount, order.status, order.createdAt);
    OrderPrepayModel model = OrderPrepayModel("SUCCESS", data, "");
    AppRouter.push(globalContext, RouteName.ORDER_PREPAY_PAGE,
        arguments: OrderPrepayPage.setArguments(model));
//    Future.delayed(Duration(seconds: 1), ()
//    {
//    AppRouter.push(globalContext, RouteName.ORDER_PREPAY_PAGE, arguments: OrderPrepayPage.setArguments(order));
//    });
  }

  _confirmReceiptClick(OrderModel orderModel){
    _confirmModel = null;
    Alert.show(
        context,
        NormalContentDialog(
          title: "确认收货",
          content: Text("确认收货后无法发起售后申请，请确认您的商品无误。继续确认？", style: TextStyle(color: Colors.black,),),
          items: ["取消", "确认收货"],
          listener: (int index){// Alert.dismiss(context);
            if (index == 0) {// 
              Alert.dismiss(context);
            }else{
              Alert.dismiss(context);
              GSDialog.of(globalContext).showLoadingDialog(context, "");
              _presenter.confirmReceipt(UserManager.instance.user.info.id, orderModel.id);
              _confirmModel = orderModel;
            }
          },
        )
      );
  }

  @override
  getOrderDetailSuccess(OrderDetailModel detailModel) {
    GSDialog.of(context).dismiss(globalContext);
//    AppRouter.push(globalContext, RouteName.ORDER_DETAIL,arguments: OrderDetailPage.setArguments(detailModel.data));
  }

  @override
  cancelOrderSuccess(OrderModel order) {
    GSDialog.of(context).dismiss(globalContext);
    order.status = 2;
    _cancelCallback();
  }

  @override
  deleteOrderSuccess(int orderId) {
    GSDialog.of(context).dismiss(globalContext);
    OrderModel deleteOrderModel;
    for (OrderModel model in _controller.getData()) {
      if (model.id == orderId && model.id != null) {
        deleteOrderModel = model;
        break;
      } 
    }
    _controller.getData().remove(deleteOrderModel);
    setState(() {});
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
  confirmReceiptSuccess(UserRoleUpgradeModel model){
    GSDialog.of(context).dismiss(globalContext);
    GSDialog.of(globalContext).showSuccess(globalContext, "确认成功").then((value) {
      UserLevelTool.showUpgradeWidget(model, globalContext, getStore());
    });
    _presenter.getOrderList(UserManager.instance.user.info.id, 0, widget.type, widget.positionType);
  }
  
}
