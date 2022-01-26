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
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:jingyaoyun/models/order_list_model.dart';
import 'package:jingyaoyun/models/order_prepay_model.dart';
import 'package:jingyaoyun/models/user_role_upgrade_model.dart';
import 'package:jingyaoyun/pages/home/classify/order_prepay_page.dart';
import 'package:jingyaoyun/pages/user/items/item_order_list.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_contact.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/order/order_detail_page.dart';
import 'package:jingyaoyun/pages/user/order/order_list_controller.dart';
import 'package:jingyaoyun/pages/user/order/publish_evaluation_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_order_item.dart';
import 'package:jingyaoyun/utils/mvp.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:jingyaoyun/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

enum WholesaleOrderListType {
  all,
  unpaid,
  undelivered,
  receipt,
  afterSale,
}

class WholesaleOrderListPage extends StatefulWidget {
  final WholesaleOrderListType type;

  final OrderListController controller;

  const WholesaleOrderListPage(
      {Key key,
      this.type,

      this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleOrderListPageState();
  }
}

class _WholesaleOrderListPageState extends State<WholesaleOrderListPage>{

  GSRefreshController _refreshController;
  List<OrderModel> orderList = [];

  @override
  void initState() {
    super.initState();
     _refreshController =
    GSRefreshController(initialRefresh: true);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      body: Container(

        child: _bodyWidget(),
      ),
    );
  }

  Future<List<OrderModel>> getOrderList() async {
    ResultData result =
    await HttpManager.post(OrderApi.order_list_all, {"userId": UserManager.instance.user.info.id,
      "page": 0, "orderType": ''});
    if (result.data != null) {
      if (result.data['data'] != null) {
        orderList =
            (result.data['data'] as List)
                .map((e) => OrderModel.fromJson(e))
                .toList();
      }
      else
        orderList= [];
    }
    else
      orderList= [];
  }


  _bodyWidget() {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async{
        await getOrderList();

        setState(() {

        });
        _refreshController.refreshCompleted();
      },
      onLoadMore: () {

      },
      body: ListView.builder(
        itemBuilder: (context, index) {

          return orderList.isNotEmpty? WholesaleOrderItem(
            itemClick: () {
              OrderModel orderModel = orderList[index];

              AppRouter.push(context, RouteName.ORDER_DETAIL,
                  arguments: OrderDetailPage.setArguments(orderModel.id))
                  .then(((result) {
                getOrderList();
                if (result == null) return;
                DPrint.printf(result);
                setState(() {
                  orderModel.status = result;
                });
              }));
//        GSDialog.of(context).showLoadingDialog(context, "");
//        _presenter.getOrderDetail(UserManager.instance.user.info.id, _controller.getData()[index].id);
            },
            orderModel: orderList[index],
            cancelOrder: (OrderModel order, {callback}) {
              //_cancelCallback = callback;
              _cancelOrder(order);
            },
            goToPay: (OrderModel order, {callback}) {
              _goToPay(order);
            },
            delete: (OrderModel order, {callback}) {
              _deleteOrder(order);
            },
            confirm: (OrderModel order, {callback}) {
              _confirmReceiptClick(order);
            },
            applyRefund: (OrderModel order, {callback}) {},
            evaluation: (OrderModel order, {callback}) {
              List<EvaluationGoodsModel> goodsList = [];
              order.goodsList.forEach((goods) {
                if (goods.assType == 0) {
                  goodsList.add(EvaluationGoodsModel(
                      id: goods.goodsId,
                      mainPhotoUrl: goods.mainPhotoUrl,
                      goodsName: goods.goodsName));
                }
              });
              // order.brands.forEach((brand) {
              //   brand.goods.forEach((goods) {
              //     goodsList.add(EvaluationGoodsModel(
              //         id: goods.goodsId, mainPhotoUrl: goods.mainPhotoUrl, goodsName: goods.goodsName));
              //   });
              // });

              AppRouter.push(context,RouteName.ORDER_EVALUATION,
                  arguments: PublishEvaluationPage.setArguments(
                      orderId: order.id, goodsList: goodsList));
            },
          ):SizedBox();
        },
        itemCount: orderList.length,
      ),
    );
  }

  _deleteOrder(OrderModel order) {
    Alert.show(
        context,
        NormalTextDialog(
          content: "确定删除订单吗？删除后将不能撤销",
          items: ["我再想想", "确认"],
          listener: (int index) {
            Alert.dismiss(context);
            if (index == 0) return;
            GSDialog.of(context).showLoadingDialog(context, "");
            //_presenter.deleteOrder(UserManager.instance.user.info.id, order.id);
          },
        ));
  }

  _cancelOrder(OrderModel order) {
    Alert.show(
        context,
        NormalTextDialog(
          content: "确定取消订单吗？取消后将不能撤销",
          items: ["我再想想", "确认"],
          listener: (int index) {
            Alert.dismiss(context);
            if (index == 0) return;
            GSDialog.of(context).showLoadingDialog(context, "");
            //_presenter.cancelOrder(UserManager.instance.user.info.id, order.id,
            //    order: order);
          },
        ));
  }

  _goToPay(OrderModel order) async {
    Data data = Data(order.id, order.userId, order.actualTotalAmount,
        order.status, order.createdAt);
    OrderPrepayModel model = OrderPrepayModel("SUCCESS", data, "");

    AppRouter.push(context, RouteName.ORDER_PREPAY_PAGE,
        arguments: OrderPrepayPage.setArguments(model));
//    Future.delayed(Duration(seconds: 1), ()
//    {
//    AppRouter.push(globalContext, RouteName.ORDER_PREPAY_PAGE, arguments: OrderPrepayPage.setArguments(order));
//    });
  }

  _confirmReceiptClick(OrderModel orderModel) {
    //_confirmModel = null;
    Alert.show(
        context,
        NormalContentDialog(
          title: "确认收货",
          content: Text(
            "确认收货后无法发起售后申请，请确认您的商品无误。继续确认？",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          items: ["取消", "确认收货"],
          listener: (int index) {
            // Alert.dismiss(context);
            if (index == 0) {
              //
              Alert.dismiss(context);
            } else {
              Alert.dismiss(context);
              GSDialog.of(context).showLoadingDialog(context, "");
              // _presenter.confirmReceipt(
              //     UserManager.instance.user.info.id, orderModel.id);
              // _confirmModel = orderModel;
            }
          },
        ));
  }

}
