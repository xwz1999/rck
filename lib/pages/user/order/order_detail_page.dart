/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-08  10:16 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:jingyaoyun/models/order_list_model.dart';
import 'package:jingyaoyun/models/order_prepay_model.dart';
import 'package:jingyaoyun/pages/aftersale/choose_after_sale_type_page.dart';
import 'package:jingyaoyun/pages/home/classify/order_prepay_page.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_contact.dart';
import 'package:jingyaoyun/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:jingyaoyun/pages/user/order/order_detail_state.dart';
import 'package:jingyaoyun/pages/user/order/order_logistics_list_page.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class OrderDetailPage extends StatefulWidget {
  final Map arguments;

  const OrderDetailPage({Key key, this.arguments}) : super(key: key);

  static setArguments(int orderId) {
    return {"orderId": orderId};
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailPageState();
  }
}

class _OrderDetailPageState extends OrderDetailState<OrderDetailPage>
    implements OrderListViewI {
  // OrderPreviewModel _detail;
  OrderListPresenterImpl _presenter;
  GSRefreshController _refreshController = GSRefreshController();
  @override
  void initState() {
    super.initState();
    int orderId = widget.arguments["orderId"];
    print(orderId);
    _presenter = OrderListPresenterImpl();
    _presenter.attach(this);
    _presenter.getOrderDetail(UserManager.instance.user.info.id, orderId);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "????????????",
        themeData: AppThemes.themeDataGrey.appBarTheme,
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
      releaseText: "??????????????????",
      idleText: "??????????????????",
      refreshingText: "??????????????????...",
      onRefresh: () {
        _presenter.getOrderDetail(
            UserManager.instance.user.info.id, widget.arguments["orderId"]);
      },
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        // physics: BouncingScrollPhysics(),
        children: <Widget>[
          orderStatus(),
          buildAddress(),
          brandList(),
          totalPrice(),
          priceInfo(),
          orderInfo(),
          //contactCustomerService(),
        ],
      ),
    );
  }

  // _brandExpressStatus(Brands brand) {
  //   if (_detail.status != 1) return "";
  //   switch (brand.expressStatus) {
  //     case 0:
  //       return "????????????";
  //     case 1:
  //       return "????????????";
  //     case 2:
  //       return "????????????";
  //   }
  //   return "";
  // }
  _bottomBar() {
    return _bottomBarItems() == null
        ? null
        : Container(
            padding:
                EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(10)),
            color: Colors.white,
            child: SafeArea(
              bottom: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _bottomBarItems(),
              ),
            ),
          );
  }

  List<Widget> _bottomBarItems() {
    switch (orderDetail.status) {
      case 0:

        /// ?????????
        return _unpaidItems();
      case 1:

        /// ????????? ???????????????????????????
        return _deliverItems();

      case 4:
        return null;
      // {
      //   if (!TextUtils.isEmpty(orderDetail.evaluatedAt)) return [];
      //   DPrint.printf(TextUtils.isEmpty(orderDetail.evaluatedAt));
      //   return [
      //     CustomImageButton(
      //       title: "??????",
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
      //             orderDetail.evaluatedAt = "?????????";
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
      ..add(CustomImageButton(
        title: "????????????",
        color: Colors.grey,
        fontSize: 13 * 2.sp,
        padding: EdgeInsets.symmetric(vertical: rSize(2), horizontal: rSize(8)),
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(color: Colors.grey, width: 0.8 * 2.w),
        onPressed: () {
          Alert.show(
              context,
              NormalTextDialog(
                content: "????????????????????????????????????????????????",
                items: ["????????????", "??????"],
                listener: (int index) {
                  Alert.dismiss(globalContext);
                  if (index == 0) return;
                  GSDialog.of(context).showLoadingDialog(globalContext, "");
                  _presenter.cancelOrder(
                      UserManager.instance.user.info.id, orderDetail.id);
                },
              ));
        },
      ))
      ..add(Container(
        width: rSize(10),
        height: 1,
      ))
      ..add(CustomImageButton(
        title: "????????????",
        color: AppColor.themeColor,
        fontSize: 13 * 2.sp,
        padding: EdgeInsets.symmetric(vertical: rSize(2), horizontal: rSize(8)),
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(color: AppColor.themeColor, width: 0.8 * 2.w),
        onPressed: () {
          Data data = Data(
              orderDetail.id,
              orderDetail.userId,
              orderDetail.actualTotalAmount,
              orderDetail.status,
              orderDetail.createdAt);
          OrderPrepayModel model = OrderPrepayModel("SUCCESS", data, "");
          AppRouter.push(globalContext, RouteName.ORDER_PREPAY_PAGE,
              arguments: OrderPrepayPage.setArguments(model));
        },
      ));
    return items;
  }

  _deliverItems() {
    List<Widget> items = [];
    bool canRefund = false, canReturn = false, canViewLogistics = false;

    for (Brands brand in orderDetail.brands) {
      for (Goods goods in brand.goods) {
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
    //       title: "????????????",
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
    //       title: "????????????",
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

    if (orderDetail.expressStatus != 0 && orderDetail.shippingMethod != 1) {
      items
        // ..add(SizedBox(
        //   width: rSize(5),
        // ))
        ..add(CustomImageButton(
            width: buttonWidth,
            title: "????????????",
            color: Colors.grey[600],
            fontSize: 12 * 2.sp,
            padding:
                EdgeInsets.symmetric(vertical: rSize(2), horizontal: rSize(8)),
            borderRadius: BorderRadius.all(Radius.circular(40)),
            border: Border.all(color: Colors.grey[600], width: 0.8 * 2.w),
            onPressed: () {
              AppRouter.push(globalContext, RouteName.ORDER_LOGISTIC,
                  arguments: OrderLogisticsListPage.setArguments(
                      orderId: orderDetail.id));
            }))
        ..add(Container(
          width: rSize(10),
          height: 1,
        ));
    }
    // ??????????????????????????????
    // ???????????????????????????????????????????????????????????????????????????
    if (orderDetail.canConfirm &&
        orderDetail.brands.indexWhere((element) =>
                element.goods
                    .indexWhere((element) => element.rStatus == '???????????????') !=
                -1) ==
            -1) {
      items
            ..add(CustomImageButton(
              width: buttonWidth,
              title: "????????????",
              color: AppColor.themeColor,
              fontSize: 13 * 2.sp,
              padding: EdgeInsets.symmetric(
                  vertical: rSize(2), horizontal: rSize(8)),
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
    // ????????????
    Alert.show(
        context,
        NormalTextDialog(
          type: NormalTextDialogType.delete,
          title: "??????",
          content: "????????????????????????????????????????",
          items: ["??????"],
          listener: (index) {
            Alert.dismiss(context);
            GSDialog.of(globalContext).showLoadingDialog(context, "");
            _presenter.applyRefund(
                UserManager.instance.user.info.id, [goods.goodsDetailId]);
          },
          deleteItem: "??????",
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
      if (returnSuccess) {
        DPrint.printf("???????????????");
        _presenter.getOrderDetail(
            UserManager.instance.user.info.id, orderDetail.id);
      }
    });
  }

  _confirmReceiptClick() {
    Alert.show(
        context,
        NormalContentDialog(
          title: "????????????",
          content: Text(
            "???????????????????????????????????????????????????????????????????????????????????????",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          items: ["??????", "????????????"],
          listener: (int index) {
            // Alert.dismiss(context);
            if (index == 0) {
              //
              Alert.dismiss(context);
            } else {
              Alert.dismiss(context);
              GSDialog.of(globalContext).showLoadingDialog(context, "");
              _presenter.confirmReceipt(
                  UserManager.instance.user.info.id, orderDetail.id);
            }
          },
        ));
  }

  _refundGoods() {
    List<Goods> goodsList = [];
    orderDetail.brands.forEach((brands) {
      brands.goods.forEach((goods) {
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
    orderDetail.brands.forEach((brands) {
      brands.goods.forEach((goods) {
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
  cancelOrderSuccess(OrderModel order) {
    GSDialog.of(context).dismiss(globalContext);
    Toast.showInfo("???????????????");
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pop(globalContext, 2);
    });
  }

  @override
  failure(String msg) {
    GSDialog.of(globalContext).showError(globalContext, msg);
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
    GSDialog.of(context).dismiss(globalContext);
    Toast.showInfo(msg);
    _presenter.getOrderDetail(
        UserManager.instance.user.info.id, orderDetail.id);
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}

  @override
  applyInvoiceSuccess() {
    GSDialog.of(globalContext).showSuccess(globalContext, "????????????");
    _presenter.getOrderDetail(
        UserManager.instance.user.info.id, orderDetail.id);
  }

  @override
  deleteOrderSuccess(int orderId) {
    return null;
  }

  @override
  confirmReceiptSuccess(model) {
    GSDialog.of(context).dismiss(globalContext);
    GSDialog.of(globalContext).showSuccess(globalContext, "????????????").then((value) {
      // UserLevelTool.showUpgradeWidget(UserRoleUpgradeModel(data:UpgradeModel(upGrade: 1, roleLevel: 400, userLevel: 30)), globalContext, getStore());
      // UserLevelTool.showUpgradeWidget(model, globalContext, getStore());
    });
    _presenter.getOrderDetail(
        UserManager.instance.user.info.id, orderDetail.id);
  }
}
