import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/meiqia_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/order_detail_model.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/user/order/order_return_status_page.dart';
import 'package:jingyaoyun/utils/goods_status/goods_status_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/toast.dart';

abstract class OrderDetailState<T extends StatefulWidget>
    extends BaseStoreState<T> {
  OrderDetail orderDetail;
  String status;
  String subTitle;
  bool _openPriceInfo = false;
  bool isUserOrder = true;
  priceInfo() {
    return Container(
      margin: EdgeInsets.only(top: rSize(10)),
      padding: EdgeInsets.symmetric(horizontal: rSize(8)),
      color: Colors.white,
      child: Column(
        children: <Widget>[_priceInfoWidget(), _openPriceInfoButton()],
      ),
    );
  }

  _priceItemWidget({title = "", info = ""}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Color(0xff666666), fontSize: 12),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                info,
                style: TextStyle(color: Color(0xff666666), fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _actualTotalAmountWidget() {
    return Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: Colors.grey[300], width: 0.3),
        )),
        child: Row(
          children: <Widget>[
            Text(
              "?????????",
              style: TextStyle(color: Color(0xff333333), fontSize: 14),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                    "???${orderDetail.actualTotalAmount.toStringAsFixed(2)}",
                    style: TextStyle(color: AppColor.redColor, fontSize: 14)),
              ),
            )
          ],
        ));
  }

  _priceInfoWidget() {
    List<Widget> widgetList = [];
    Widget priceItem = _priceItemWidget(
        title: "????????????",
        info: "???" + orderDetail.goodsTotalAmount.toStringAsFixed(2));

    Widget expressFee = _priceItemWidget(
        title: "????????????",
        info: "+???" + orderDetail.expressTotalFee.toStringAsFixed(2));
    Widget coupon = _priceItemWidget(
        title: "?????????",
        info: "-???" +
            (orderDetail.brandCouponTotalAmount +
                    orderDetail.universeCouponTotalAmount)
                .toStringAsFixed(2));
    Widget coin = _priceItemWidget(
        title: "????????????",
        info: "-???" + orderDetail.coinTotalAmount.toStringAsFixed(2));
    // ???????????? ???????????????
    widgetList.add(priceItem);
    if (_openPriceInfo) {
      widgetList.add(expressFee);
      widgetList.add(coupon);
      widgetList.add(coin);
    }
    widgetList.add(_actualTotalAmountWidget());
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: rSize(8),
      ),
      child: Column(children: widgetList),
    );
  }

  _openPriceInfoButton() {
    return GestureDetector(
      onTap: () {
        _openPriceInfo = !_openPriceInfo;
        setState(() {});
      },
      child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          width: double.infinity,
          height: 40,
          child: ExtendedText.rich(TextSpan(children: [
            TextSpan(
                text: _openPriceInfo ? "??????" : "????????????",
                style: TextStyle(fontSize: 14, color: Color(0xff666666))),
            WidgetSpan(
                child: Container(
              margin: EdgeInsets.only(left: 2),
              child: Icon(
                _openPriceInfo
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 17,
                color: Color(0xff666666),
              ),
            ))
          ]))),
    );
  }

  contactCustomerService() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.grey[300], width: 0.3),
              bottom: BorderSide(color: Colors.grey[300], width: 0.3))),
      height: 50,
      child: CustomImageButton(
        contentSpacing: 10,
        style: TextStyle(fontSize: 14, color: Colors.black),
        direction: Direction.horizontal,
        icon: Image.asset(
          AppImageName.customer_service_icon,
          width: 17,
          height: 17,
        ),
        title: "????????????",
        onPressed: () {
          MQManager.goToChat(
              userId: UserManager.instance.user.info.id.toString(),
              userInfo: <String, String>{
                "name": UserManager.instance.user.info.nickname ?? "",
                "gender":
                    UserManager.instance.user.info.gender == 1 ? "???" : "???",
                "mobile": UserManager.instance.user.info.mobile ?? ""
              });
        },
      ),
    );
  }

  _saleAmountInfo() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(
        left: rSize(8),
      ),
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: Colors.grey[300], width: 0.3),
      )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(minWidth: rSize(70)),
              child: ExtendedText.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "????????? ",
                    style: AppTextStyle.generate(14, color: Color(0xff333333)),
                  ),
                  WidgetSpan(
                      child: GestureDetector(
                    onTap: () {
                      Alert.show(
                          context,
                          NormalTextDialog(
                            type: NormalTextDialogType.delete,
                            title: "?????????",
                            content: "?????????????????????+????????????+????????????",
                            items: [],
                            deleteItem: "????????????",
                            listener: (index) {
                              Alert.dismiss(context);
                            },
                            deleteListener: () {
                              Alert.dismiss(context);
                            },
                          ));
                    },
                    child: Icon(
                      Icons.help_outline,
                      color: Colors.grey[400],
                      size: 17,
                    ),
                  )),
                ]),
                textAlign: TextAlign.start,
              )),
          Expanded(
            child: Container(
              child: Text(
                "???" +
                    (orderDetail.actualTotalAmount +
                            orderDetail.coinTotalAmount +
                            orderDetail.brandCouponTotalAmount +
                            orderDetail.universeCouponTotalAmount)
                        .toStringAsFixed(2),
                style: AppTextStyle.generate(14, color: Color(0xff333333)),
              ),
            ),
          )
        ],
      ),
    );
  }

  orderInfo() {
    if (orderDetail == null) return Container();
    return Container(
      margin: EdgeInsets.only(top: rSize(10)),
      padding: EdgeInsets.symmetric(horizontal: rSize(8)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _tile("????????????", orderDetail.id.toString(), needCopy: true),
          _tile("????????????", orderDetail.createdAt),
          !TextUtils.isEmpty(orderDetail.payTime)
              ? _tile("????????????", orderDetail.payTime)
              : Container(),
          _tile("????????????", orderDetail.buyerMessage,
              crossAxisAlignment: CrossAxisAlignment.start),
          _saleAmountInfo(),
        ],
      ),
    );
  }

  _tile(
    String title,
    String value, {
    bool needCopy = false,
    CrossAxisAlignment crossAxisAlignment: CrossAxisAlignment.center,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: 10, bottom: 10,
        left: rSize(8),
        // top: rSize(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(minWidth: rSize(70)),
              child: Text(
                "$title:",
                style:
                    AppTextStyle.generate(14 * 2.sp, color: Color(0xff333333)),
              )),
          needCopy
              ? GestureDetector(
                  onTap: () {
                    if (!needCopy) {
                      return;
                    }
                    ClipboardData data = new ClipboardData(text: value);
                    Clipboard.setData(data);
                    Toast.showSuccess('$title:' + value + ' -- ????????????????????????');
                  },
                  child: Text(
                    "$value",
                    style: AppTextStyle.generate(12 * 2.sp,
                        color: Color(0xff333333)),
                  ),
                )
              : Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!needCopy) {
                        return;
                      }
                      ClipboardData data = new ClipboardData(text: value);
                      Clipboard.setData(data);
                      Toast.showSuccess('$title:' + value + ' -- ????????????????????????');
                    },
                    child: Text(
                      "$value",
                      style: AppTextStyle.generate(12 * 2.sp,
                          color: Color(0xff333333)),
                    ),
                  ),
                ),
          needCopy
              ? GestureDetector(
                  onTap: () {
                    if (!needCopy) {
                      return;
                    }
                    ClipboardData data = new ClipboardData(text: value);
                    Clipboard.setData(data);
                    Toast.showSuccess('$title:' + value + ' -- ????????????????????????');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: AppColor.frenchColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '??????',
                      style:
                          AppTextStyle.generate(11 * 2.sp, color: Colors.grey),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  totalPrice() {
    int totalQuantity = 0;
    orderDetail.brands.forEach((brand) {
      brand.goods.forEach((goods) {
        totalQuantity += goods.quantity;
      });
    });

    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.all(rSize(8)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.3))),
      child: RichText(
          text: TextSpan(
              text: "???$totalQuantity?????????  ?????????",
              style: AppTextStyle.generate(13 * 2.sp),
              children: [
            TextSpan(
                text: "${orderDetail.goodsTotalAmount.toStringAsFixed(2)}",
                style: AppTextStyle.generate(16 * 2.sp))
          ])),
    );
  }

  // _totalPrice() {
  //   int totalQuantity = 0;
  //   orderDetail.brands.forEach((brand) {
  //     brand.goods.forEach((goods) {
  //       totalQuantity += goods.quantity;
  //     });
  //   });

  //   return Container(
  //     width: double.infinity,
  //     alignment: Alignment.centerRight,
  //     padding: EdgeInsets.all(rSize(8)),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         border: Border(top: BorderSide(color: Colors.grey[300], width: 0.3))),
  //     child: RichText(
  //         text: TextSpan(
  //             text: "???$totalQuantity?????????  ?????????",
  //             style: AppTextStyle.generate(13*2.sp),
  //             children: [
  //           TextSpan(
  //               text: "${orderDetail.actualTotalAmount.toStringAsFixed(2)}",
  //               style: AppTextStyle.generate(16*2.sp))
  //         ])),
  //   );
  // }

  brandList() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: rSize(8)),
      padding: EdgeInsets.all(rSize(5)),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: orderDetail.brands.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return _buildBrandsItem(
                orderDetail.brands[index], orderDetail.statusList);
          }),
    );
  }

  _buildBrandsItem(Brands brand, List<StatusList> status) {
    return Container(
      padding: EdgeInsets.only(bottom: rSize(8)),
      child: Column(
        children: <Widget>[
          _brandName(brand),
          _goodsList(brand, status),
          // _brandBottomPrice(brand),
          _brandOperationView(brand),
        ],
      ),
    );
  }

  _brandOperationView(Brands brand) {
    List<Widget> items = [];

    if (orderDetail.status == 4) {
      // items
      //   ..add(CustomImageButton(
      //     title: "????????????",
      //     color: Colors.grey[600],
      //     fontSize: 12*2.sp,
      //     padding: EdgeInsets.symmetric(
      //         vertical: rSize(2), horizontal: rSize(8)),
      //     borderRadius: BorderRadius.all(Radius.circular(40)),
      //     border: Border.all(color: Colors.grey, width: 0.8*2.w),
      //     onPressed: () {
      //       if (orderDetail.invoiceStatus != 0) {
      //        ReToast.warning(text: "????????????????????????????????????????????????");

      //         return;
      //       }
      //       AppRouter.push(globalContext, RouteName.ORDER_INVOICE_LIST).then((invoiceId) {
      //         if (invoiceId == null) return;
      //         ReToast.loading();
      //         OrderListPresenterI.applyInvoice(UserManager.instance.user.info.id, orderDetail.id, invoiceId);
      //       });
      //     },
      //   ));
    }

    return Container(
      margin: EdgeInsets.only(top: rSize(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: items,
      ),
    );
  }

  _goodsList(Brands brand, List<StatusList> status) {
    return ListView.builder(
        itemCount: brand.goods.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return FlatButton(
            onPressed: () {
              bool canPush = true;
              Goods goods = brand.goods[index];
              status.forEach((element) {
                if (element.goodsId == goods.goodsId && element.status == 0) {
                  canPush = false;
                }
              });
              if (canPush) {
                AppRouter.push(context, RouteName.COMMODITY_PAGE,
                    arguments: CommodityDetailPage.setArguments(
                        brand.goods[index].goodsId));
              } else {
                ReToast.err(text: '???????????????');
              }
            },
            child: _goodsItem(brand.goods[index]),
          );
        }));
  }

  refundClick(Goods goods) {
    // AppRouter.push(context, RouteName.CHOOSE_AFTER_SALE_TYPE_PAGE, arguments: ChooseAfterSaleTypePage.setArguments(goods));
  }
  returnClick(Goods goods) {
    // AppRouter.push(context, RouteName.CHOOSE_AFTER_SALE_TYPE_PAGE, arguments: ChooseAfterSaleTypePage.setArguments(goods));
  }
  _goodsItem(Goods goods) {
    // double buttonWidth = (MediaQuery.of(context).size.width-50)/4;
    bool canRefund = false;
    bool canReturn = false;
    if (goods.assType == 0 && isUserOrder) {
      if (goods.expressStatus == 0) {
        canRefund = true;
        if (orderDetail.status == 0) canRefund = false;
      } else if (goods.expressStatus == 1) {
        canReturn = true;
      }
    }
    if (goods.refundStatus != 0) canRefund = false;
    if (orderDetail.status != 1) canRefund = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          height: rSize(130),
          padding:
              EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(3)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: AppColor.frenchColor,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                margin: EdgeInsets.symmetric(horizontal: rSize(4)),
                child: CustomCacheImage(
                  width: rSize(90),
                  height: rSize(90),
                  imageUrl: Api.getImgUrl(goods.mainPhotoUrl),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          goods.goodsName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(14 * 2.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(maxWidth: 150.rw),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Color(0xffeff1f6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 6),
                              child: Text(
                                goods.skuName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.generate(11 * 2.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            Spacer(),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                "x${goods.quantity}",
                                style: AppTextStyle.generate(13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          Text(
                            "???${goods.unitPrice.toStringAsFixed(2)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.generate(14 * 2.sp,
                                color: AppColor.redColor),
                          ),
                          Spacer(),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          canReturn
                              ? CustomImageButton(
                                  title: "????????????",
                                  color: Colors.grey[600],
                                  fontSize: 12 * 2.sp,
                                  padding: EdgeInsets.symmetric(
                                      vertical: rSize(1), horizontal: rSize(4)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  border: Border.all(
                                      color: Colors.grey[600],
                                      width: 0.8 * 2.w),
                                  onPressed: () {
                                    returnClick(goods);
                                  },
                                )
                              : Container(),
                          SizedBox(
                            width: rSize(5),
                          ),
                          canRefund
                              ? CustomImageButton(
                                  title: "????????????",
                                  color: Colors.grey[600],
                                  fontSize: 12 * 2.sp,
                                  padding: EdgeInsets.symmetric(
                                      vertical: rSize(1), horizontal: rSize(4)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  border: Border.all(
                                      color: Colors.grey[600],
                                      width: 0.8 * 2.w),
                                  onPressed: () {
                                    refundClick(goods);
                                  },
                                )
                              : Container(),
                          SizedBox(
                            width: rSize(5),
                          ),
                          !TextUtils.isEmpty(goods.rStatus) &&
                                  (goods.rStatus == "?????????" ||
                                      goods.rStatus == "?????????" ||
                                      goods.rStatus == "?????????" ||
                                      goods.rStatus == "???????????????")
                              ? Text(
                                  // _goodsStatus(goods),
                                  goods.rStatus,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.generate(12 * 2.sp,
                                      color: AppColor.priceColor),
                                )
                              : TextUtils.isEmpty(goods.rStatus)
                                  ? Container(
                                      height: 15,
                                    )
                                  : GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: ScreenAdapterUtils.setWidth(
                                                10)),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.5,
                                                color: AppColor.priceColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(11))),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 1),
                                        alignment: Alignment.center,
                                        // width: rSize(40),
                                        // height: 22,
                                        child: Text(
                                          goods.rStatus,
                                          style: TextStyle(
                                              fontSize: 12 * 2.sp,
                                              fontWeight: FontWeight.w300,
                                              color: AppColor.priceColor),
                                        ),
                                      ),
                                      onTap: () {
                                        AppRouter.push(context,
                                            RouteName.ORDER_RETURN_DETAIL,
                                            arguments: OrderReturnStatusPage
                                                .setArguments(
                                                    goods.goodsDetailId,
                                                    goods.asId));
                                      },
                                    ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        goods.returnStatus != 2
            ? Container()
            : Container(
                padding: EdgeInsets.only(
                  right: rSize(15),
                  bottom: rSize(5),
                  left: rSize(90),
                ),
                child: Text(
                  "??????????????????: ${goods.returnRejectReason}",
                  style: AppTextStyle.generate(11 * 2.sp, color: Colors.red),
                ))
      ],
    );
  }

  _goodsStatus(Goods goods) {
    // ???????????????????????????????????????????????????
    if (orderDetail.status != 1) return "";
    // 0 ????????????????????????????????????????????????????????????
    if (goods.assType == 0) {
      return GoodsStatusTool.goodsExpressStatusOrderDetailModel(goods);
    }
    // ???????????????
    return _refundStatus(goods);
  }

  _refundStatus(Goods goods) {
    if (goods.assType == 0) return "";
    if (goods.refundStatus != 0) {
      return goods.refundStatus == 1 ? "?????????" : "????????????";
    }

    switch (goods.returnStatus) {
      case 1:
        return "????????????????????????";
      case 2:
        return "???????????????";
      case 3:
        return "????????????";
    }
    return "";
  }

  _brandBottomPrice(Brands brand) {
    int quantity = 0;
    brand.goods.forEach((goods) {
      quantity += goods.quantity;
    });
    return Column(
      children: <Widget>[
        Container(
            alignment: Alignment.centerRight,
            child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                    text: "???$quantity?????????  ?????????",
                    style: AppTextStyle.generate(12 * 2.sp, color: Colors.grey),
                    children: [
                      TextSpan(
                          text:
                              "${brand.brandGoodsTotalAmount.toStringAsFixed(2)}",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Colors.grey)),
                      TextSpan(
                        text:
                            "(????????????${brand.brandExpressTotalAmount.toStringAsFixed(2)})",
                      ),
                    ]))),
      ],
    );
  }

  _brandName(Brands brand) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomImageButton(
          padding: EdgeInsets.only(
              right: rSize(12),
              top: rSize(3),
              bottom: rSize(3),
              left: rSize(3)),
          height: rSize(30),
          direction: Direction.horizontal,
          pureDisplay: true,
          // icon: CustomCacheImage(
          //   imageUrl: Api.getResizeImgUrl(brand.brandLogoUrl, 150),
          // ),
          contentSpacing: rSize(8),
          style: AppTextStyle.generate(
            14 * 2.sp,
          ),
          title: brand.brandName,
        ),
        Icon(
          AppIcons.icon_next,
          size: rSize(14),
          color: Colors.grey,
        ),
//        Spacer(),
//        Text(
//          _brandExpressStatus(brand),
//          style: AppTextStyle.generate(13*2.sp, color: AppColor.priceColor),
//        )
      ],
    );
  }

  buildAddress() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 5, right: 10),
              child: Image.asset(
                AppImageName.address_icon,
                width: 40,
                height: 40,
              )
              // child: Icon(
              //   AppIcons.icon_address,
              //   size: 20*2.sp,
              // ),
              ),
          Expanded(child: addressView()),
        ],
      ),
    );
  }

  addressView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextUtils.isEmpty(
                "${orderDetail.addr.receiverName}${orderDetail.addr.mobile}")
            ? Container()
            : RichText(
                text: TextSpan(
                    text: "${orderDetail.addr.receiverName}",
                    style: AppTextStyle.generate(15 * 2.sp),
                    children: [
                    TextSpan(
                        text: "   ${orderDetail.addr.mobile}",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: Colors.grey))
                  ])),
        Container(
          margin: EdgeInsets.only(top: 8 * 2.sp),
          child: Text(
            "${orderDetail.addr.province + orderDetail.addr.city + orderDetail.addr.district + orderDetail.addr.address}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                AppTextStyle.generate(14 * 2.sp, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }

  Container orderStatus() {
    orderStatusMsg();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rSize(30), vertical: rSize(15)),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              colors: [AppColor.themeColor, Colors.red[400]])),
      child: RichText(
          text: TextSpan(
              text: "$status",
              style: AppTextStyle.generate(17 * 2.sp, color: Colors.white),
              children: [
            TextSpan(
                text: "\n$subTitle",
                style: AppTextStyle.generate(14 * 2.sp,
                    fontWeight: FontWeight.w300, color: Colors.white))
          ])),
    );
  }

  orderStatusMsg() {
    switch (orderDetail.status) {
      case 0:
        status = "????????????";
        subTitle = "??????????????????: ${orderDetail.expireTime}";
        break;
      case 1:
        expressStatus();
        break;
      case 2:
        status = "???????????????";
        subTitle = "???????????????";
        break;
      case 3:
        status = "???????????????";
        subTitle = "???????????????";
        break;
      case 4:
        status = "???????????????";
        subTitle = "??????????????????";
        break;
      case 5:
        status = "???????????????";
        subTitle = "";
        break;
    }
  }

  expressStatus() {
    if (orderDetail.expressStatus == 0) {
      status = "???????????????";
      subTitle = "??????????????????";
      return;
    }
    if (orderDetail.expressStatus == 1) {
      status = "?????????????????????";
      subTitle = "?????????????????????????????????";
      return;
    }
    if (orderDetail.expressStatus == 2) {
      status = "?????????????????????";
      subTitle = "?????????????????????????????????";
      return;
    }
  }

  @override
  BuildContext get globalContext => super.globalContext;
}
