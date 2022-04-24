/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  13:39 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/order_list_model.dart';
import 'package:jingyaoyun/pages/user/order/order_logistics_list_page.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

typedef ItemClickListener = Function(OrderModel order, {VoidCallback callback});

class ShopOrderListItem extends StatefulWidget {
  /*
   status :
    0 : 未支付
    1 : 支付成功
    2 : 订单取消
    3 : 订单过期
    4 : 订单完成

   expressStatus 快递状态
    0: 待发货
    1:全部发货
    2:部分发货
    */
  final OrderModel orderModel;
  final ItemClickListener goToPay;
  final ItemClickListener cancelOrder;
  final ItemClickListener applyRefund;
  final ItemClickListener applySalesReturn;
  final ItemClickListener evaluation;
  final ItemClickListener delete;

  const ShopOrderListItem(
      {Key key,
      this.orderModel,
      this.goToPay,
      this.cancelOrder,
      this.applyRefund,
      this.applySalesReturn,
      this.evaluation,
      this.delete})
      : super(key: key);

  @override
  _ShopOrderListItemState createState() => _ShopOrderListItemState();
}

class _ShopOrderListItemState extends State<ShopOrderListItem> {
  String _status;
  Color _color;

  @override
  Widget build(BuildContext context) {
    return _buildContainer(context);
  }

  _buildContainer(context) {
    _orderStatus();
    return Container(
        margin: EdgeInsets.symmetric(vertical: rSize(6), horizontal: rSize(10)),
        padding: EdgeInsets.all(rSize(8)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(rSize(10))),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _brandList(context),
            _orderTotalPrice(),
            _bottomOperations()
          ],
        ));
  }

  Text _orderStatusText() {
    return Text(
      _status,
      style: AppTextStyle.generate(14 * 2.sp,
          color: _color, fontWeight: FontWeight.w500),
    );
  }

  MediaQuery _brandList(context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: ListView.builder(
          // itemCount: widget.orderModel.goodsList.length,
          itemCount: 1,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: ((context, index) {
            return _buildBrandsItem();
          })),
    );
  }

  _orderTotalPrice() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(top: rSize(5), left: rSize(10)),
      padding: EdgeInsets.only(top: rSize(5)),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.3))),
      child: Row(
        children: <Widget>[
          widget.orderModel.expressStatus != 0
              ? CustomImageButton(
                  title: "查看物流",
                  color: Colors.grey[600],
                  fontSize: 12 * 2.sp,
                  padding: EdgeInsets.symmetric(
                      vertical: rSize(2), horizontal: rSize(8)),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(color: Colors.grey, width: 0.8 * 2.w),
                  onPressed: () {
                    AppRouter.push(context, RouteName.ORDER_LOGISTIC,
                        arguments: OrderLogisticsListPage.setArguments(
                            orderId: widget.orderModel.id));
                  },
                )
              : Container(),
          Spacer(),
          RichText(
              text: TextSpan(
                  text: "共${widget.orderModel.totalGoodsCount}件商品  实付￥",
                  style: AppTextStyle.generate(13 * 2.sp),
                  children: [
                TextSpan(
                    text:
                        "${widget.orderModel.actualTotalAmount.toStringAsFixed(2)}",
                    style: AppTextStyle.generate(16 * 2.sp))
              ])),
        ],
      ),
    );
  }

  _bottomOperations() {
    List<Widget> children = [];
    return Container(
      margin: EdgeInsets.only(top: rSize(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  _deleteButtonWidget() {
    return CustomImageButton(
      title: "删除订单",
      padding: EdgeInsets.symmetric(vertical: rSize(2), horizontal: rSize(10)),
//            backgroundColor: AppColor.themeColor,
      color: AppColor.themeColor,
      fontSize: 14 * 2.sp,
      border: Border.all(color: AppColor.themeColor, width: 0.3),
      borderRadius: BorderRadius.all(Radius.circular(40)),
      onPressed: () {
        if (widget.delete != null) {
          widget.delete(widget.orderModel);
        }
        // if (widget.goToPay == null) return;
        // widget.goToPay(widget.orderModel, callback: () {
        //   setState(() {});
        // });
      },
    );
  }

  _buildBrandsItem() {
    return Column(
      children: <Widget>[_brandName(), _goodsList()],
      // children: <Widget>[_brandName(), _goodsList(), _brandBottomPrice()],
    );
  }

  _brandName() {
    // return Container(
    //   height: 40,
    //   color: Colors.red,
    // );
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
          //   imageUrl: Api.getResizeImgUrl(goods.brandLogoUrl, 30),
          // ),
          icon: Image.asset(
            'assets/order_item_sell.png',
            width: 20,
          ),
          contentSpacing: rSize(8),
          style: AppTextStyle.generate(
            14 * 2.sp,
          ),
          title: widget.orderModel.createdAt,
        ),
        Icon(
          AppIcons.icon_next,
          size: rSize(14),
          color: Colors.grey,
        ),
        Spacer(),
        _orderStatusText()
        // Text(
        //   _expressStatus(),
        //   style: AppTextStyle.generate(12*2.sp, color: Colors.orange),
        // )
      ],
    );
  }

  _orderStatus() {
    switch (widget.orderModel.status) {
      case 0:
        _status = "未付款";
        _color = Color.fromARGB(255, 249, 61, 6);
        break;
      case 1:
        _status = "支付成功";
        _color = Colors.red;
//        _expressStatus(status, color);
        break;
      case 2:
        _status = "订单已取消";
        _color = Colors.grey;
        break;
      case 3:
        _status = "订单已过期";
        _color = Colors.grey;
        break;
      case 4:
        _status = "交易已完成";
        _color = AppColor.priceColor;
        break;
      case 5:
        _status = "";
        _color = Colors.red[300];
        break;
    }
  }

  _goodsList() {
    return ListView.builder(
        itemCount: widget.orderModel.goodsList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return _goodsItem(widget.orderModel.goodsList[index]);
        }));
  }

  _brandBottomPrice() {
    // int quantity = 0;
    // brand.goods.forEach((goods) {
    //   quantity += goods.quantity;
    // });
    return Container(
        alignment: Alignment.centerRight,
        child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
                // text: "运费: ￥${widget.orderModel.expressTotalFee.toStringAsFixed(2)}\n共${widget.orderModel.totalGoodsCount}件商品  小计￥",
                text:
                    "运费: ￥${widget.orderModel.expressTotalFee.toStringAsFixed(2)}",
                style: AppTextStyle.generate(12 * 2.sp, color: Colors.grey),
                children: [
                  TextSpan(
                      // text: "${widget.orderModel.actualTotalAmount.toStringAsFixed(2)}",
                      text: "",
                      style:
                          AppTextStyle.generate(14 * 2.sp, color: Colors.grey)),
                ])));
  }

  _brandBottomButtons() {}

  _goodsItem(OrderGoodsModel goods) {
    return Container(
      height: rSize(110),
      padding: EdgeInsets.symmetric(vertical: rSize(8), horizontal: rSize(3)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: AppColor.frenchColor),
            margin: EdgeInsets.symmetric(horizontal: rSize(4)),
            child: CustomCacheImage(
              width: rSize(90),
              height: rSize(90),
              imageUrl: Api.getImgUrl(goods.mainPhotoUrl),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      goods.goodsName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(
                        14 * 2.sp,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color(0xffeff1f6),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 6),
                          child: Text(
                            goods.skuName,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.generate(11 * 2.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.centerRight,
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
                  Row(
                    children: <Widget>[
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "￥",
                          style: AppTextStyle.generate(10 * 2.sp,
                              color: AppColor.priceColor),
                        ),
                        TextSpan(
                          text: "${(goods.goodsAmount-goods.coinAmount).toStringAsFixed(2)}",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: AppColor.priceColor),
                        ),
                            TextSpan(
                              text:  " (折后价)",
                              style: AppTextStyle.generate(12 * 2.sp,
                                color: Color(0xFF999999)),
                            )
                      ])),
                      Spacer(),
                      Text(
                        goods.rStatus,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: AppColor.priceColor),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
