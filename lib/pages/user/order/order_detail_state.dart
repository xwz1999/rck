import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:extended_text/extended_text.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/meiqia_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/order_detail_model.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/user/order/order_return_status_page.dart';
import 'package:recook/utils/goods_status/goods_status_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/toast.dart';

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
              "实付款",
              style: TextStyle(color: Color(0xff333333), fontSize: 14),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                    "￥${orderDetail.actualTotalAmount.toStringAsFixed(2)}",
                    style: TextStyle(color: AppColor.redColor, fontSize: 14)),
              ),
            )
          ],
        ));
  }

  _priceInfoWidget() {
    List<Widget> widgetList = [];
    Widget priceItem = _priceItemWidget(
        title: "商品金额",
        info: "￥" + orderDetail.goodsTotalAmount.toStringAsFixed(2));

    Widget expressFee = _priceItemWidget(
        title: "合计运费",
        info: "+￥" + orderDetail.expressTotalFee.toStringAsFixed(2));
    Widget coupon = _priceItemWidget(
        title: "优惠券",
        info: "-￥" +
            (orderDetail.brandCouponTotalAmount +
                    orderDetail.universeCouponTotalAmount)
                .toStringAsFixed(2));
    Widget coin = _priceItemWidget(
        title: "瑞币抵扣",
        info: "-￥" + orderDetail.coinTotalAmount.toStringAsFixed(2));
    // 余额抵扣 暂时不需要
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
                text: _openPriceInfo ? "收起" : "查看更多",
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
        title: "联系客服",
        onPressed: () {
          MQManager.goToChat(
              userId: UserManager.instance.user.info.id.toString(),
              userInfo: <String, String>{
                "name": UserManager.instance.user.info.nickname ?? "",
                "gender":
                    UserManager.instance.user.info.gender == 1 ? "男" : "女",
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
                    text: "销售额 ",
                    style: AppTextStyle.generate(14, color: Color(0xff333333)),
                  ),
                  WidgetSpan(
                      child: GestureDetector(
                    onTap: () {
                      Alert.show(
                          context,
                          NormalTextDialog(
                            type: NormalTextDialogType.delete,
                            title: "销售额",
                            content: "销售额：实付款+瑞币抵扣+余额抵扣",
                            items: [],
                            deleteItem: "我知道了",
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
                "￥" +
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
          _tile("订单编号", orderDetail.id.toString(), needCopy: true),
          _tile("下单时间", orderDetail.createdAt),
          !TextUtils.isEmpty(orderDetail.payTime)
              ? _tile("付款时间", orderDetail.payTime)
              : Container(),
          _tile("买家留言", orderDetail.buyerMessage,
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
                    Toast.showSuccess('$title:' + value + ' -- 已经保存到剪贴板');
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
                      Toast.showSuccess('$title:' + value + ' -- 已经保存到剪贴板');
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
                    Toast.showSuccess('$title:' + value + ' -- 已经保存到剪贴板');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: AppColor.frenchColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '复制',
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
              text: "共$totalQuantity件商品  总计￥",
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
  //             text: "共$totalQuantity件商品  总计￥",
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
      //     title: "申请发票",
      //     color: Colors.grey[600],
      //     fontSize: 12*2.sp,
      //     padding: EdgeInsets.symmetric(
      //         vertical: rSize(2), horizontal: rSize(8)),
      //     borderRadius: BorderRadius.all(Radius.circular(40)),
      //     border: Border.all(color: Colors.grey, width: 0.8*2.w),
      //     onPressed: () {
      //       if (orderDetail.invoiceStatus != 0) {
      //        ReToast.warning(text: "您已经申请过发票了，请勿重复申请");

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
                ReToast.err(text: '商品已下架');
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
                            "￥${goods.unitPrice.toStringAsFixed(2)}",
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
                                  title: "申请售后",
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
                                  title: "申请退款",
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
                                  (goods.rStatus == "待发货" ||
                                      goods.rStatus == "已发货" ||
                                      goods.rStatus == "待自提" ||
                                      goods.rStatus == "自提待确认")
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
                  "退货被拒原因: ${goods.returnRejectReason}",
                  style: AppTextStyle.generate(11 * 2.sp, color: Colors.red),
                ))
      ],
    );
  }

  _goodsStatus(Goods goods) {
    // 只有已付款的才有发货以及退换货状态
    if (orderDetail.status != 1) return "";
    // 0 代表不是退款或退货的商品，则查询快递状态
    if (goods.assType == 0) {
      return GoodsStatusTool.goodsExpressStatusOrderDetailModel(goods);
    }
    // 退换货状态
    return _refundStatus(goods);
  }

  _refundStatus(Goods goods) {
    if (goods.assType == 0) return "";
    if (goods.refundStatus != 0) {
      return goods.refundStatus == 1 ? "退款中" : "退款成功";
    }

    switch (goods.returnStatus) {
      case 1:
        return "等待商家确认退货";
      case 2:
        return "退货被拒绝";
      case 3:
        return "退货成功";
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
                    text: "共$quantity件商品  小计￥",
                    style: AppTextStyle.generate(12 * 2.sp, color: Colors.grey),
                    children: [
                      TextSpan(
                          text:
                              "${brand.brandGoodsTotalAmount.toStringAsFixed(2)}",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Colors.grey)),
                      TextSpan(
                        text:
                            "(含运费￥${brand.brandExpressTotalAmount.toStringAsFixed(2)})",
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
        status = "等待付款";
        subTitle = "支付过期时间: ${orderDetail.expireTime}";
        break;
      case 1:
        expressStatus();
        break;
      case 2:
        status = "订单已取消";
        subTitle = "请重新购买";
        break;
      case 3:
        status = "订单已过期";
        subTitle = "请重新购买";
        break;
      case 4:
        status = "订单已完成";
        subTitle = "期待再次购买";
        break;
      case 5:
        status = "订单已关闭";
        subTitle = "";
        break;
    }
  }

  expressStatus() {
    if (orderDetail.expressStatus == 0) {
      status = "买家已付款";
      subTitle = "等待卖家发货";
      return;
    }
    if (orderDetail.expressStatus == 1) {
      status = "部分商品已发货";
      subTitle = "商品正在赶往您的路上哦";
      return;
    }
    if (orderDetail.expressStatus == 2) {
      status = "全部商品已发货";
      subTitle = "商品正在赶往您的路上哦";
      return;
    }
  }

  @override
  BuildContext get globalContext => super.globalContext;
}
