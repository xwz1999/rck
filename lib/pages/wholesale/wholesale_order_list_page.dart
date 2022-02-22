

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/guide_order_item_model.dart';
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
import 'package:jingyaoyun/pages/user/order/order_list_page.dart';
import 'package:jingyaoyun/pages/user/order/publish_evaluation_page.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_guide_order_item.dart';
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
  final OrderPositionType positionType;
  final OrderListController controller;

  const WholesaleOrderListPage(
      {Key key,
      this.type,

      this.controller, this.positionType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleOrderListPageState();
  }
}

class _WholesaleOrderListPageState extends State<WholesaleOrderListPage>{

  GSRefreshController _refreshController;
  List<OrderModel> orderList = [];
  List<GuideOrderItemModel> guideOrderList = [];
  int _page = 0;
  bool isNodata = false;

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



  _bodyWidget() {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async{
        _page = 0;
        if(widget.positionType==OrderPositionType.onlineOrder){
          WholesaleFunc.getOrderList(widget.type,_page,widget.positionType).then((value) {

            orderList = value;

            // if (value.isEmpty)
            //   _refreshController.isNoData;
            // else
            if(orderList.isEmpty){
              isNodata = true;
            }else{
              isNodata = false;
            }
            if (mounted) {
              setState(() {});
            }
            _refreshController.refreshCompleted();
          });
        }else{
          WholesaleFunc.getSonOrder(widget.type,_page,).then((value) {

            guideOrderList = value;

            // if (value.isEmpty)
            //   _refreshController.isNoData;
            // else
            if(guideOrderList.isEmpty){
              isNodata = true;
            }else{
              isNodata = false;
            }
            if (mounted) {
              setState(() {});
            }
            _refreshController.refreshCompleted();
          });
        }

      },
      onLoadMore: () async{
        _page++;
        if(widget.positionType==OrderPositionType.onlineOrder) {
          WholesaleFunc.getOrderList(widget.type, _page, widget.positionType)
              .then((value) {
            setState(() {
              orderList.addAll(value);
            });
            if (value.isEmpty)
              _refreshController.loadNoData();
            else
              _refreshController.loadComplete();
          });
        }else{
          WholesaleFunc.getSonOrder(widget.type,_page,)
              .then((value) {
            setState(() {
              guideOrderList.addAll(value);
            });
            if (value.isEmpty)
              _refreshController.loadNoData();
            else
              _refreshController.loadComplete();
          });
        }
      },
      body: isNodata? noDataView('没有订单数据哦~'): ListView.builder(
        itemBuilder: (context, index) {
          if(widget.positionType==OrderPositionType.onlineOrder){
            return orderList.isNotEmpty? WholesaleOrderItem(
              itemClick: () {
                OrderModel orderModel = orderList[index];

                AppRouter.push(context, RouteName.ORDER_DETAIL,
                    arguments: OrderDetailPage.setArguments(orderModel.id,true))
                    .then(((result) {
                  _refreshController.requestRefresh();
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
          }else{
            return   guideOrderList.isNotEmpty? WholesaleGuideOrderItem(
              itemClick: () {
                GuideOrderItemModel orderModel = guideOrderList[index];

                AppRouter.push(context, RouteName.ORDER_DETAIL,
                    arguments: OrderDetailPage.setArguments(orderModel.orderId,true))
                    .then(((result) {
                  _refreshController.requestRefresh();
                  if (result == null) return;
                  DPrint.printf(result);
                  setState(() {
                    orderModel.status = result;
                  });
                }));
//        GSDialog.of(context).showLoadingDialog(context, "");
//        _presenter.getOrderDetail(UserManager.instance.user.info.id, _controller.getData()[index].id);
              },
              orderModel: guideOrderList[index],
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
          }



        },
        itemCount: widget.positionType==OrderPositionType.onlineOrder? orderList.length:guideOrderList.length,
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
        arguments: OrderPrepayPage.setArguments(model,isPifa: true));
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

  noDataView(String text, {Widget icon}) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon ??
              Image.asset(
                R.ASSETS_NODATA_PNG,
                width: rSize(80),
                height: rSize(80),
              ),
//          Icon(AppIcons.icon_no_data_search,size: rSize(80),color: Colors.grey),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey),
          ),
          SizedBox(
            height: rSize(30),
          )
        ],
      ),
    );
  }
}
