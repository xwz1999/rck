/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-12  14:42 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/order_preview_model.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/bottom_sheet/action_sheet.dart';
import 'package:recook/widgets/bottom_sheet/bottom_textfield_dialog.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/input_view.dart';

class GoodsOrderItem extends StatefulWidget {
  final Brands brand;
  final int shippingMethod;

  const GoodsOrderItem({Key key, this.brand, this.shippingMethod})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoodsOrderItemState();
  }
}

class _GoodsOrderItemState extends State<GoodsOrderItem> {
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Container _buildBody(BuildContext context) {
    int goodsNum = 0;
    double commissionPrice = 0;
    widget.brand.goods.forEach((goods) {
      goodsNum += goods.quantity;
      commissionPrice += goods.totalCommission;
    });

    String expressMsg = "";
    if (widget.shippingMethod == 0) {
      if (widget.brand.brandExpressTotalAmount <= 0) {
        expressMsg = "免邮";
      } else {
        expressMsg = "${widget.brand.brandExpressTotalAmount}元";
      }
    }

    return Container(
      margin:
          EdgeInsets.only(left: rSize(13), right: rSize(13), bottom: rSize(13)),
      padding: EdgeInsets.all(rSize(8)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _brandName(),
          _goods(context),
          // _tile(
          //     "优惠信息",
          //     widget.brand.coupon != null
          //         ? widget.brand.coupon.couponName
          //         : "暂无优惠信息",
          //     needArrow: false),
          // Offstage(
          //   offstage: widget.shippingMethod == 1,
          //   child: _tile("运费", expressMsg, needArrow: false),
          // ),
          _bottomView(goodsNum, commissionPrice)
        ],
      ),
    );
  }

  CustomImageButton _brandName() {
    return CustomImageButton(
      direction: Direction.horizontal,
      height: rSize(35),
      color: Colors.black,
      pureDisplay: true,
      contentSpacing: 10,
      fontSize: ScreenAdapterUtils.setSp(16),
      title: widget.brand.brandName,
      padding: EdgeInsets.symmetric(horizontal: 3),
      icon: CustomCacheImage(
        height: rSize(25),
        width: rSize(25),
        imageUrl: Api.getResizeImgUrl(widget.brand.brandLogoUrl, 40),
        borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
      ),
    );
  }

  Container _bottomView(int goodsNum, double commission) {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(
          top: rSize(7), left: rSize(4), right: rSize(4), bottom: rSize(3)),
      child: RichText(
          text: TextSpan(
              text: "共 $goodsNum 件",
              style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                  color: Colors.grey[600]),
              children: [
            TextSpan(
                text: " 合计:",
                style: AppTextStyle.generate(
                  ScreenAdapterUtils.setSp(13),
                )),
            TextSpan(
                text:
                    "￥${widget.brand.brandGoodsTotalAmount.toStringAsFixed(2)}",
                style: AppTextStyle.generate(
                  ScreenAdapterUtils.setSp(13),
                  color: Color.fromARGB(255, 249, 62, 13),
                )),
            AppConfig.getShowCommission()
                ? TextSpan(
                    text: "  赚:",
                    style: AppTextStyle.generate(
                      ScreenAdapterUtils.setSp(13),
                    ))
                : TextSpan(text: ''),
            AppConfig.getShowCommission()
                ? TextSpan(
                    text: '$commission',
                    style: AppTextStyle.generate(
                      ScreenAdapterUtils.setSp(13),
                      color: Color.fromARGB(255, 249, 62, 13),
                    ))
                : TextSpan(text: ''),
          ])),
    );
  }

  _goods(context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.brand.goods.length,
        itemBuilder: ((context, index) {
          return _buildSku(widget.brand.goods[index]);
        }),
      ),
    );
  }

  Container _buildSku(OrderGoods goods) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: TextUtils.isEmpty(goods.promotionName) ? rSize(110) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomCacheImage(
            imageUrl: Api.getImgUrl(goods.mainPhotoUrl),
            fit: BoxFit.cover,
            width: rSize(90),
            height: rSize(90),
            borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    goods.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Container(
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
                        style: AppTextStyle.generate(
                            ScreenAdapterUtils.setSp(11),
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  // TextUtils.isEmpty(goods.promotionName)
                  //     ? Spacer()
                  //     : Row(
                  //         children: <Widget>[
                  //           CustomImageButton(
                  //             pureDisplay: true,
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: rSize(2),
                  //                 vertical: rSize(2)),
                  //             borderRadius: BorderRadius.all(Radius.circular(
                  //                 rSize(3))),
                  //             title:"${goods.promotionName}",
                  //             // title:
                  //             //     "${goods.promotionName} ${goods.promotionDiscount}折",
                  //             fontSize: ScreenAdapterUtils.setSp(11),
                  //             color: AppColor.themeColor,
                  //             backgroundColor: Colors.pink[50],
                  //           ),
                  //         ],
                  //       ),
                  Text(
                    "￥ ${goods.unitPrice.toStringAsFixed(2)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: rSize(80),
            child: Text(
              "x${goods.quantity}",
              style: AppTextStyle.generate(13,
                  color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }

  _tile(String title, String value,
      {VoidCallback listener, bool needArrow = true}) {
    return GestureDetector(
      onTap: listener,
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: <Widget>[
            Container(
                width: rSize(80),
                child: Text(
                  title,
                  style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                      fontWeight: FontWeight.w400),
                )),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13.5),
                    color: Colors.grey[600], fontWeight: FontWeight.w300),
              ),
            ),
            Offstage(
                offstage: !needArrow,
                child: Icon(
                  AppIcons.icon_next,
                  size: rSize(14),
                  color: Colors.grey,
                ))
          ],
        ),
      ),
    );
  }
}
