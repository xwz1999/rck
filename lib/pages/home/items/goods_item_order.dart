/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-12  14:42 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/order_preview_model.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class GoodsOrderItem extends StatefulWidget {
  final Brands brand;
  final int shippingMethod;
  final int index;
  final int length;

  const GoodsOrderItem({Key key, this.brand, this.shippingMethod, this.length, this.index})
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
          EdgeInsets.only(left: rSize(13), right: rSize(13)),
      padding: EdgeInsets.all(rSize(8)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: widget.length==1? BorderRadius.all(Radius.circular(8.rw)): widget.index==0?BorderRadius.vertical(top: Radius.circular(8.rw)):
          widget.index==widget.length-1?BorderRadius.vertical(bottom: Radius.circular(8.rw)):BorderRadius.vertical(top: Radius.circular(0.rw))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //_brandName(),
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
          //_bottomView(goodsNum, commissionPrice)
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
      fontSize: 16 * 2.sp,
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
              style: AppTextStyle.generate(13 * 2.sp, color: Colors.grey[600]),
              children: [
            TextSpan(
                text: " 合计:",
                style: AppTextStyle.generate(
                  13 * 2.sp,
                )),
            TextSpan(
                text:
                    "￥${widget.brand.brandGoodsTotalAmount.toStringAsFixed(2)}",
                style: AppTextStyle.generate(
                  13 * 2.sp,
                  color: Color.fromARGB(255, 249, 62, 13),
                )),
            AppConfig.commissionByRoleLevel
                ? TextSpan(
                    text: "  赚:",
                    style: AppTextStyle.generate(
                      13 * 2.sp,
                    ))
                : TextSpan(text: ''),
            AppConfig.commissionByRoleLevel
                ? TextSpan(
                    text: '$commission',
                    style: AppTextStyle.generate(
                      13 * 2.sp,
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
            width: 80.rw,
            height: 80.rw,
            borderRadius: BorderRadius.all(Radius.circular(rSize(5))),
          ),
           Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              width: 160.rw,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    goods.goodsName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(12.rsp,
                        fontWeight: FontWeight.w400),
                  ),
                  rHBox(5),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Color(0xffeff1f6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Text(
                      goods.skuName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(11 * 2.sp,
                          color: Colors.grey[600], fontWeight: FontWeight.w300),
                    ),
                  ),
                  rHBox(2),
                  goods.isImport == 0
                      ? SizedBox()
                      : Row(
                          children: [
                            goods.isFerme == 1
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: rSize(3)),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFE5ED),
                                      borderRadius:
                                          BorderRadius.circular(rSize(2)),
                                    ),
                                    child: Text(
                                      '包税',
                                      style: TextStyle(
                                        color: Color(0xFFCC1B4F),
                                        fontSize: rSP(10),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            rWBox(4),
                            Text(
                              '此商品不支持7天无理由退换',
                              style: TextStyle(
                                color: Color(0xFFEF7115),
                                fontSize: rSP(10),
                              ),
                            ),
                          ],
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
                  //             fontSize: 11*2.sp,
                  //             color: AppColor.themeColor,
                  //             backgroundColor: Colors.pink[50],
                  //           ),
                  //         ],
                  //       ),

                ],
              ),
            ),
          Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
              children: [
            Text(
              "￥ ${(goods.goodsAmount-goods.coinAmount).toStringAsFixed(2)}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.generate(14 * 2.sp,
                  fontWeight: FontWeight.w300),
            ),
                Text(
                  "(折后价)",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.generate(12 * 2.sp,color: Color(0xFF999999)),
                ),
            5.hb,
            Text(
              "x${goods.quantity}",
              style: AppTextStyle.generate(13,
                  color: Colors.grey, fontWeight: FontWeight.w300),
            ),
          ]),

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
