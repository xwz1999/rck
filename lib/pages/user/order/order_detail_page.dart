/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-08  10:16 
 * remark    : 
 * ====================================================
 */

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/order_detail_model.dart';
import 'package:recook/models/order_list_model.dart';
import 'package:recook/models/order_prepay_model.dart';
import 'package:recook/pages/aftersale/choose_after_sale_type_page.dart';
import 'package:recook/pages/home/classify/order_prepay_page.dart';
import 'package:recook/pages/user/mvp/order_list_contact.dart';
import 'package:recook/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:recook/pages/user/order/order_detail_state.dart';
import 'package:recook/pages/user/order/order_logistics_list_page.dart';
import 'package:recook/pages/wholesale/func/wholesale_func.dart';
import 'package:recook/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:recook/pages/wholesale/wholesale_customer_page.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_floating_action_button_location.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/toast.dart';

class OrderDetailPage extends StatefulWidget {
  final Map? arguments;

  const OrderDetailPage({Key? key, this.arguments}) : super(key: key);

  static setArguments(int? orderId,bool isPifa) {
    return {"orderId": orderId,'isPifa':isPifa};
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailPageState();
  }
}

class _OrderDetailPageState extends OrderDetailState<OrderDetailPage>
    implements OrderListViewI {
  // OrderPreviewModel _detail;
  bool isPifa = false;
  late OrderListPresenterImpl _presenter;
  GSRefreshController _refreshController = GSRefreshController();
  @override
  void initState() {
    super.initState();
    int? orderId = widget.arguments!["orderId"];

    if(widget.arguments!["isPifa"]!=null){
      isPifa = UserManager.instance!.isWholesale||widget.arguments!["isPifa"];
    }

    print(orderId);
    _presenter = OrderListPresenterImpl();
    _presenter.attach(this);
    _presenter.getOrderDetail(UserManager.instance!.user.info!.id, orderId);
  }



  _customer(){
    return GestureDetector(
      onTap: () async{
        // WholesaleCustomerModel? model = await
        // WholesaleFunc.getCustomerInfo();
        //
        // Get.to(()=>WholesaleCustomerPage(model: model,));
        if (UserManager.instance!.user.info!.id == 0) {
          AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
          Toast.showError('请先登录...');
          return;
        }
        BytedeskKefu.startWorkGroupChat(context, AppConfig.WORK_GROUP_WID, "客服");

      },
      child: Container(
        width: 46.rw,
        height: 46.rw,
        decoration: BoxDecoration(
          color: Color(0xFF000000).withOpacity(0.7),
          borderRadius: BorderRadius.all(Radius.circular(23.rw)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(R.ASSETS_WHOLESALE_WHOLESALE_CUSTOMER_PNG,width: 20.rw,height: 20.rw,),
            5.hb,
            Text('客服',style: TextStyle(color: Colors.white,fontSize: 10.rw),)
          ],
        ),
      ),
    );
  }
  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      floatingActionButton: isPifa? _customer():SizedBox(),
      floatingActionButtonLocation:CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endDocked, 0, -120.rw),
      appBar: CustomAppBar(
      title: orderDetail==null?'':getTitle(),
      themeData: AppThemes.themeDataGrey.appBarTheme,
      elevation: 0,
      background: AppColor.frenchColor,
      appBackground: AppColor.frenchColor,
    ),
      body: orderDetail == null ? loadingView() : _buildBody(),
      backgroundColor: AppColor.frenchColor,
      bottomNavigationBar: orderDetail == null ? null : _bottomBar(),
    );
  }

  _buildBody() {
    return RefreshWidget(
      headerTriggerDistance: rSize(80),
      color: Colors.black,
      controller: _refreshController,
      releaseText: "松开更新数据",
      idleText: "下拉更新数据",
      refreshingText: "正在更新数据...",
      onRefresh: () {
        _presenter.getOrderDetail(
            UserManager.instance!.user.info!.id, widget.arguments!["orderId"]);
      },
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        // physics: BouncingScrollPhysics(),
        children: <Widget>[
          !orderDetail!.canPay!&&isPifa && orderDetail!.status==0? waitDeal():SizedBox(),

          !isPifa&& orderDetail!.status==0? payTimeView():SizedBox(),
          buildAddress(),
          isPifa?wholesaleBrandList(): brandList(),
          isPifa?SizedBox():totalPrice(),
          isPifa? SizedBox():priceInfo(),
          isPifa? wholesaleOrderInfo(): orderInfo(),
          isPifa&&orderDetail!.makeUpAmount!=null&&orderDetail!.makeUpText!=''?wholesaleCompensate():SizedBox(),
          //contactCustomerService(),
        ],
      ),
    );
  }

  getTitle() {
    switch (orderDetail!.status) {
      case 0:
        if(!orderDetail!.canPay!&&isPifa)
        return "待处理";
        else{
          return "待付款";
        }
      case 1:
        String status =
        getStatus();
        return status;

      case 2:
        return "已取消";

      case 3:
        return "已过期";

      case 4:
        return "已完成";

      case 5:
        return "已关闭";

    }
  }

  getStatus() {
    if (orderDetail!.expressStatus == 0) {
      return "已付款";

    }
    if (orderDetail!.expressStatus == 1) {

      return  "部分商品已发货";
    }
    if (orderDetail!.expressStatus == 2) {

      return "已发货";
    }
  }


  // _brandExpressStatus(Brands brand) {
  //   if (_detail.status != 1) return "";
  //   switch (brand.expressStatus) {
  //     case 0:
  //       return "等待发货";
  //     case 1:
  //       return "部分发货";
  //     case 2:
  //       return "全部发货";
  //   }
  //   return "";
  // }
  _bottomBar() {
    return _bottomBarItems() == null
        ? null
        : Container(
            padding:
                EdgeInsets.symmetric(vertical: rSize(10), horizontal: rSize(10)),
            color: Colors.white,
            child: SafeArea(
              bottom: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _bottomBarItems()!,
              ),
            ),
          );
  }

  List<Widget>? _bottomBarItems() {
    switch (orderDetail!.status) {
      case 0:
        /// 未支付
        if(!orderDetail!.canPay!&&isPifa){
          return null;
        }else{
          return _unpaidItems();
        }
      case 1:

        /// 已支付 包括未发货和已发货
        return _deliverItems();

      case 4:
        return null;
      // {
      //   if (!TextUtils.isEmpty(orderDetail.evaluatedAt)) return [];
      //   DPrint.printf(TextUtils.isEmpty(orderDetail.evaluatedAt));
      //   return [
      //     CustomImageButton(
      //       title: "评价",
      //       color: AppColor.themeColor,
      //       fontSize: 13 * 2.sp,
      //       padding: EdgeInsets.symmetric(
      //           vertical: rSize(2), horizontal: rSize(20)),
      //       borderRadius: BorderRadius.all(Radius.circular(40)),
      //       border: Border.all(color: AppColor.themeColor, width: 0.8 * 2.w),
      //       onPressed: () {
      //         List<EvaluationGoodsModel> goodsList = [];
      //         orderDetail.brands.forEach((brand) {
      //           brand.goods.forEach((goods) {
      //             if (goods.assType == 0) {
      //               goodsList.add(EvaluationGoodsModel(
      //                   id: goods.goodsId,
      //                   mainPhotoUrl: goods.mainPhotoUrl,
      //                   goodsName: goods.goodsName));
      //             }
      //           });
      //         });

      //         push(RouteName.ORDER_EVALUATION,
      //                 arguments: PublishEvaluationPage.setArguments(
      //                     orderId: orderDetail.id, goodsList: goodsList))
      //             .then((isSuccess) {
      //           if (isSuccess) {
      //             orderDetail.evaluatedAt = "已评价";
      //           }
      //         });
      //       },
      //     )
      //   ];
      // }
    }
    return null;
  }

  _unpaidItems() {
    List<Widget> items = [];
    items
      ..add(
        orderDetail!.canPay!&&isPifa?SizedBox():

          CustomImageButton(
        title: "取消订单",
        color: Colors.grey,
        fontSize: 13 * 2.sp,
        padding: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(15)),
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(color: Colors.grey, width: 0.8 * 2.w),
        onPressed: () {
          Alert.show(
              context,
              NormalTextDialog(
                content: "确定取消订单吗？取消后将不能撤销",
                items: ["我再想想", "确认"],
                listener: (int index) {
                  Alert.dismiss(globalContext!);
                  if (index == 0) return;
                  GSDialog.of(context).showLoadingDialog(globalContext!, "");
                  _presenter.cancelOrder(
                      UserManager.instance!.user.info!.id, orderDetail!.id);
                },
              ));
        },
      ))
      ..add(Container(
        width: rSize(10),
        height: 1,
      ))
      ..add(

          CustomImageButton(
        title:  orderDetail!.canPay!&&isPifa?'去支付': "继续支付",
        color: AppColor.themeColor,
        fontSize: 13 * 2.sp,
        padding: EdgeInsets.symmetric(vertical: 8.rw, horizontal: 18.rw),
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(color: AppColor.themeColor, width: 0.8 * 2.w),
        onPressed: () {
          Data data = Data(
              orderDetail!.id,
              orderDetail!.userId,
              orderDetail!.actualTotalAmount,
              orderDetail!.status,
              orderDetail!.createdAt);
          OrderPrepayModel model = OrderPrepayModel("SUCCESS", data, "");
          AppRouter.push(globalContext!, RouteName.ORDER_PREPAY_PAGE,
              arguments: OrderPrepayPage.setArguments(model,isPifa: true, goToOrder: true,fromTo: orderDetail!.canPay!&&isPifa?'1':''));
        },
      ));
    return items;
  }

  _deliverItems() {
    List<Widget> items = [];
    bool canRefund = false, canReturn = false, canViewLogistics = false;

    for (Brands brand in orderDetail!.brands!) {
      for (Goods goods in brand.goods!) {
        if (goods.assType != 0) continue;
        if (goods.expressStatus == 0) {
          canRefund = true;
        } else if (goods.expressStatus == 1) {
          canReturn = true;
        }
      }
    }
    // canReturn = true;
    double buttonWidth = (MediaQuery.of(context).size.width - 50) / 4;
    // if (canRefund) {
    //   items
    //     ..add(CustomImageButton(
    //       width: buttonWidth,
    //       title: "申请退款",
    //       color: Colors.grey[600],
    //       fontSize: 13*2.sp,
    //       padding: EdgeInsets.symmetric(
    //           vertical: rSize(2), horizontal: rSize(8)),
    //       borderRadius: BorderRadius.all(Radius.circular(40)),
    //       border: Border.all(color: Colors.grey[600], width: 0.8*2.w),
    //       onPressed: () {
    //         _refundClick();
    //       },
    //     ))
    //     // ..add(Expanded(
    //     //   child: Container(height: 1,),
    //     // ))
    //     ..add(Container(
    //       width: rSize(10),
    //       height: 1,
    //     ))
    //     ;
    // }

    // if (canReturn) {
    //   items
    //     ..add(CustomImageButton(
    //       width: buttonWidth,
    //       title: "申请退货",
    //       color: Colors.grey[600],
    //       fontSize: 13*2.sp,
    //       padding: EdgeInsets.symmetric(
    //           vertical: rSize(2), horizontal: rSize(8)),
    //       borderRadius: BorderRadius.all(Radius.circular(40)),
    //       border: Border.all(color: Colors.grey[600], width: 0.8*2.w),
    //       onPressed: () {
    //         _returnGoodsClick();
    //       },
    //     ))
    //     // ..add(Expanded(
    //     //   child: Container(height: 1,),
    //     // ))
    //     ..add(Container(
    //       width: rSize(10),
    //       height: 1,
    //     ));
    // }
    // items
    //   ..add(Expanded(
    //       child: Container(height: 1,),
    //     ));

    if (orderDetail!.expressStatus != 0 && orderDetail!.shippingMethod != 1) {
      items
        // ..add(SizedBox(
        //   width: rSize(5),
        // ))
        ..add(
            isPifa?SizedBox():
            CustomImageButton(
            width: buttonWidth,
            title: "查看物流",
            color: Colors.grey[600],
            fontSize: 12 * 2.sp,
            padding:
            EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(15)),
            borderRadius: BorderRadius.all(Radius.circular(40)),
            border: Border.all(color: Colors.grey[600]!, width: 0.8 * 2.w),
            onPressed: () {
              AppRouter.push(globalContext!, RouteName.ORDER_LOGISTIC,
                  arguments: OrderLogisticsListPage.setArguments(
                      orderId: orderDetail!.id));
            }))
        ..add(Container(
          width: rSize(10),
          height: 1,
        ));
    }
    // 确认收货按钮显示控制
    // 当订单中包含‘退款审核中’的状态时，不显示确认收货
    if (orderDetail!.canConfirm! &&
        orderDetail!.brands!.indexWhere((element) =>
                element.goods!
                    .indexWhere((element) => element.rStatus == '退款审核中') !=
                -1) ==
            -1) {
      items
            ..add(CustomImageButton(
              width: buttonWidth,
              title: "确认收货",
              color: AppColor.themeColor,
              fontSize: 12 * 2.sp,
              padding: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(15)),
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border: Border.all(color: AppColor.themeColor, width: 0.8 * 2.w),
              onPressed: () {
                _confirmReceiptClick();
              },
            ))
          // ..add(Container(
          //   width: rSize(10),
          //   height: 1,
          // ))
          ;
    }

    return items;
  }

  @override
  refundClick(goods) {
    // 申请退款
    Alert.show(
        context,
        NormalTextDialog(
          type: NormalTextDialogType.delete,
          title: "提示",
          content: "是否要对该商品进行退款操作?",
          items: ["确认"],
          listener: (index) {
            Alert.dismiss(context);
            GSDialog.of(globalContext).showLoadingDialog(context, "");
            _presenter.applyRefund(
                UserManager.instance!.user.info!.id, [goods.goodsDetailId]);
          },
          deleteItem: "取消",
          deleteListener: () {
            Alert.dismiss(context);
          },
        ));
  }

  @override
  returnClick(goods) {
    AppRouter.push(context, RouteName.CHOOSE_AFTER_SALE_TYPE_PAGE,
            arguments: ChooseAfterSaleTypePage.setArguments(goods))
        .then((returnSuccess) {
      if (returnSuccess == null) return;
      if (returnSuccess as bool) {
        DPrint.printf("退货成功了");
        _presenter.getOrderDetail(
            UserManager.instance!.user.info!.id, orderDetail!.id);
      }
    });
  }

  _confirmReceiptClick() {
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
              GSDialog.of(globalContext).showLoadingDialog(context, "");
              _presenter.confirmReceipt(
                  UserManager.instance!.user.info!.id, orderDetail!.id);
            }
          },
        ));
  }

  _refundGoods() {
    List<Goods> goodsList = [];
    orderDetail!.brands!.forEach((brands) {
      brands.goods!.forEach((goods) {
        goods.selected = false;
        if (goods.expressStatus == 0 && goods.assType == 0) {
          goodsList.add(goods);
        }
      });
    });
    return goodsList;
  }

  _returnGoods() {
    List<Goods> goodsList = [];
    orderDetail!.brands!.forEach((brands) {
      brands.goods!.forEach((goods) {
        goods.selected = false;
        if (goods.expressStatus == 1 &&
            goods.assType == 0 &&
            goods.isClosed != 1) {
          goodsList.add(goods);
        }
      });
    });
    return goodsList;
  }

  @override
  cancelOrderSuccess(OrderModel? order) {
    GSDialog.of(context).dismiss(globalContext!);
    Toast.showInfo("已取消订单");
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pop(globalContext!, 2);
    });
  }

  @override
  failure(String? msg) {
    GSDialog.of(globalContext).showError(globalContext!, msg);
  }

  @override
  getOrderDetailSuccess(OrderDetailModel detail) {
    _refreshController.refreshCompleted();
    setState(() {
      orderDetail = detail.data;
    });
  }

  @override
  refundSuccess(msg) {
    GSDialog.of(context).dismiss(globalContext!);
    Toast.showInfo(msg);
    _presenter.getOrderDetail(
        UserManager.instance!.user.info!.id, orderDetail!.id);
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}

  @override
  applyInvoiceSuccess() {
    GSDialog.of(globalContext).showSuccess(globalContext!, "申请成功");
    _presenter.getOrderDetail(
        UserManager.instance!.user.info!.id, orderDetail!.id);
  }

  @override
  deleteOrderSuccess(int? orderId) {
    return null;
  }

  @override
  confirmReceiptSuccess(model) {
    GSDialog.of(context).dismiss(globalContext!);
    GSDialog.of(globalContext).showSuccess(globalContext!, "确认成功").then((value) {
      // UserLevelTool.showUpgradeWidget(UserRoleUpgradeModel(data:UpgradeModel(upGrade: 1, roleLevel: 400, userLevel: 30)), globalContext, getStore());
      // UserLevelTool.showUpgradeWidget(model, globalContext, getStore());
    });
    _presenter.getOrderDetail(
        UserManager.instance!.user.info!.id, orderDetail!.id);
  }
}
