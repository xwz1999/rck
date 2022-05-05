import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/guide_order_item_model.dart';
import 'package:jingyaoyun/models/order_list_model.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';

typedef ItemClickListener = Function(OrderModel order, {VoidCallback callback});

class WholesaleGuideOrderItem extends StatefulWidget {
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
  final GuideOrderItemModel orderModel;
  final VoidCallback itemClick;
  final ItemClickListener goToPay;
  final ItemClickListener cancelOrder;
  final ItemClickListener applyRefund;
  final ItemClickListener applySalesReturn;
  final ItemClickListener evaluation;
  final ItemClickListener delete;
  final ItemClickListener confirm;

  const WholesaleGuideOrderItem(
      {Key key,
      this.orderModel,
      this.goToPay,
      this.cancelOrder,
      this.applyRefund,
      this.applySalesReturn,
      this.evaluation,
      this.delete,
      this.confirm, this.itemClick})
      : super(key: key);

  @override
  _WholesaleGuideOrderItemState createState() => _WholesaleGuideOrderItemState();
}

class _WholesaleGuideOrderItemState extends State<WholesaleGuideOrderItem> {
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
                // _orderStatusText(),
                GestureDetector(
                  onTap: widget.itemClick,
                  child: Column(
                    children: [
                      _brandList(context),
                      _orderTotalPrice(),
                    ],
                  ),
                ),
                // _bottomOperations(),
              ],
            ),

        );
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
    // int totalQuantity = 0;
    // widget.orderModel.brands.forEach((brand) {
    //   brand.goods.forEach((goods) {
    //     totalQuantity += goods.quantity;
    //   });
    // });

    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(top: rSize(5), left: rSize(10)),
      padding: EdgeInsets.only(top: rSize(5)),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.3))),
      child: Row(
        children: <Widget>[
          Spacer(),
          RichText(
              text: TextSpan(
                  text: "共${widget.orderModel.totalGoodsCount}件商品  总计￥",
                  style: AppTextStyle.generate(13 * 2.sp),
                  children: [
                TextSpan(
                    text:
                        "${widget.orderModel.goodsTotalAmount.toStringAsFixed(2)}",
                    style: AppTextStyle.generate(16 * 2.sp))
              ])),
        ],
      ),
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
              right: rSize(3), top: rSize(3), bottom: rSize(3), left: rSize(3)),
          height: rSize(30),
          direction: Direction.horizontal,
          pureDisplay: true,
          // icon: CustomCacheImage(
          //   imageUrl: Api.getResizeImgUrl(goods.brandLogoUrl, 30),
          // ),
          icon: Image.asset(R.ASSETS_WHOLESALE_WHOLESALE_DIAN_PNG, width: 20,),
          contentSpacing: rSize(8),
          style: AppTextStyle.generate(
            14 * 2.sp,
          ),
          title: DateTime.fromMillisecondsSinceEpoch(widget.orderModel.createdAt ).toString(),
        ),

        Spacer(),
        _orderStatusText(),
        6.wb,
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
        _status = "交易已关闭";
        _color = Colors.red[300];
        break;
    }
  }

  _goodsList() {
    return ListView.builder(
        itemCount: widget.orderModel.goods.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return _goodsItem(widget.orderModel.goods[index]);
        }));
  }



  _goodsItem(Goods goods) {
    return Container(
      height: 90.rw,
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
              width: 68.rw,
              height: 68.rw,
              imageUrl: Api.getImgUrl(goods.mainPhotoUrl),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.all(Radius.circular(8.rw)),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8.rw),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 180.rw,
                        child: ExtendedText.rich(
                          TextSpan(
                            children: [
                              ExtendedWidgetSpan(
                                child: widget.orderModel.shippingMethod == 1
                                    ? Container(
                                        margin: EdgeInsets.only(right: 2.rw),
                                        height: 14.rw,
                                        width: 24.rw,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFCC1B4F),
                                          borderRadius: BorderRadius.circular(3.rw),
                                        ),
                                        child: Text(
                                          '自提',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.rsp,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                              ExtendedWidgetSpan(
                                child: goods.importValue
                                    ? Container(
                                        margin: EdgeInsets.only(right: 2.rw),
                                        height: 14.rw,
                                        width: 24.rw,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                                                                color: goods.countryIcon == null
                                              ? Color(0xFFCC1B4F)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(3.rw),
                                        ),
                                        child: goods.countryIcon == null
                                            ? Text(
                                                '进口',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10 * 2.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            : CustomCacheImage(
                                                width: rSize(100),
                                                height: rSize(100),
                                                imageUrl: Api.getImgUrl(
                                                    goods.countryIcon),
                                                fit: BoxFit.cover,
                                              ),
                                      )
                                    : SizedBox(),
                              ),
                              TextSpan(text: goods.goodsName,style: TextStyle(fontSize: 12.rsp)),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(
                            14 * 2.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          "¥${goods.unitPrice.toStringAsFixed(2)}".text.size(12.rsp).color(Color(0xFF333333)).make(),

                        ],
                      )
                    ],
                  ),
                  20.hb,
                  Container(
                    // margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color(0xffeff1f6),
                          ),
                          constraints: BoxConstraints(maxWidth: 150.rw),//增加最大宽度
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 6),
                          child: Text(
                            "${goods.skuName}",
                            maxLines: 1,
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
                            "¥共${goods.quantity}件",
                            style: AppTextStyle.generate(13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     RichText(
                  //         text: TextSpan(children: [
                  //       TextSpan(
                  //         text: "￥",
                  //         style: AppTextStyle.generate(10 * 2.sp,
                  //             color: AppColor.priceColor),
                  //       ),
                  //       TextSpan(
                  //         text: "${goods.unitPrice.toStringAsFixed(2)}",
                  //         style: AppTextStyle.generate(14 * 2.sp,
                  //             color: AppColor.priceColor),
                  //       )
                  //     ])),
                  //     Spacer(),
                  //     Text(
                  //       goods.rStatus,
                  //       maxLines: 1,
                  //       overflow: TextOverflow.ellipsis,
                  //       style: AppTextStyle.generate(14 * 2.sp,
                  //           color: AppColor.priceColor),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _refundStatus(OrderGoodsModel goods) {
    if (goods.assType == 0) return "";
    if (goods.refundStatus != 0) {
      return goods.refundStatus == 1 ? "退款中" : "退款成功";
    }

    if (goods.returnStatus == 1) {
      return "等待商家确认退货";
    } else if (goods.returnStatus == 2) {
      return "退货被拒绝";
    } else if (goods.returnStatus == 3) {
      return "退货成功";
    }
    return "";
  }
}
