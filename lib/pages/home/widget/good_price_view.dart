/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-11  15:52 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/goods/small_coupon_widget.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/utils/user_level_tool.dart';

import 'package:recook/widgets/custom_image_button.dart';

class GoodPriceView extends StatefulWidget {
  final GoodsDetailModel detailModel;
  final VoidCallback shareCallback;

  const GoodPriceView({Key key, this.detailModel, this.shareCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoodPriceViewState();
  }
}

class _GoodPriceViewState extends State<GoodPriceView> {
  GoodsDetailModel detailModel;
  VoidCallback shareCallback;

  @override
  void initState() {
    super.initState();

    detailModel = widget.detailModel;
    shareCallback = widget.shareCallback;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _price(),
        _name(),
        _detail(),
        _label(),
        _service(),
      ],
    );
  }

  Container _price() {
    // bool hasPromotion = detailModel.data.promotion != null;
    double minPrice,
        maxPrice,
        maxCommission,
        minCommission,
        minOriginPrice,
        maxOriginPrice;
    num coupon = 0;

    maxCommission = detailModel.data.price.max.commission;
    minCommission = detailModel.data.price.min.commission;
    minPrice = detailModel.data.price.min.discountPrice;
    maxPrice = detailModel.data.price.max.discountPrice;

    minOriginPrice = detailModel.data.price.min.originalPrice;
    maxOriginPrice = detailModel.data.price.max.originalPrice;

    if(detailModel.data.sku!=null&&detailModel.data.sku.length>0){
      coupon = detailModel.data.sku[0].coupon;
      detailModel.data.sku.forEach((element) {
        if(coupon>element.coupon)coupon = element.coupon;
      });
    }else{
      coupon =0;
    }

//    if (hasPromotion) {
//    } else {
//      minPrice = detailModel.data.price.min.originalPrice;
//      maxPrice = detailModel.data.price.max.originalPrice;
//    }

    String commission, price, originPrice;
    if (maxPrice == minPrice) {
      price = maxPrice.toStringAsFixed(2);
    } else {
      // price = "${minPrice.toStringAsFixed(2)}-${maxPrice.toStringAsFixed(2)}";
      price = "${_getDoubleText(minPrice)}-${_getDoubleText(maxPrice)}";
    }
    bool isTwoPrice = false;
    if (minOriginPrice == maxOriginPrice) {
      originPrice = maxOriginPrice.toStringAsFixed(2);
    } else {
      originPrice =
          "${_getDoubleText(minOriginPrice)}-${_getDoubleText(maxOriginPrice)}";
      isTwoPrice = true;
    }

    if (maxCommission == minCommission) {
      commission = maxCommission.toStringAsFixed(2);
    } else {
      commission =
          "${_getDoubleText(minCommission)}-${_getDoubleText(maxCommission)}";
    }
    return _normalPriceWidget(price, commission, originPrice, isTwoPrice,coupon);
  }

  _getDoubleText(double number) {
    if ((number - number.toInt()) > 0) {
      return number.toString();
    } else {
      return number.toInt().toString();
    }
  }

  _promotionPrice(price, commission, originPrice,coupon, {isTwoPrice = false}) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "券后",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: ScreenAdapterUtils.setSp(9)),
                    ),
                    TextSpan(
                      text: "￥",
                      style: AppTextStyle.generate(
                        ScreenAdapterUtils.setSp(
                          14,
                        ),
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                    TextSpan(
                        text: "$price ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenAdapterUtils.setSp(23),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        )),
                    
                    TextSpan(
                      text: (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None || UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip)
                          ? ""
                          : isTwoPrice ? "/ " : " / ",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None || UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip) ? "" : "赚",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(13),
                          color: Colors.white),
                    ),
                    TextSpan(
                      text: (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None || UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip) ? "" : "$commission",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                          color: Colors.white),
                    ),
                ])),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ( coupon!=null && coupon!=0)
              ? Padding(
                padding: EdgeInsets.only(right: 10),
                child: SmallCouponWidget(
                  couponType: SmallCouponType.white,
                  number:coupon,
                ),
              )
              : SizedBox(),
              Text(
                "$originPrice",
                style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                    decoration: TextDecoration.lineThrough,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _normalPriceWidget(price, commission, originPrice, isTwoPrice,coupon) {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
            child: Image.asset(
              'assets/goods_price_view_bg_all.png',
              fit: BoxFit.fill,
            ),
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
          ),
          Positioned(
            child: Image.asset(
              'assets/recook_mascot.png',
              fit: BoxFit.fill,
            ),
            width: 43,
            right: 40,
            height: 60,
            bottom: 0,
          ),
          _promotionPrice(price, commission, originPrice,coupon,
              isTwoPrice: isTwoPrice,),
        ],
      ),
    );
  }

  Container _name() {
    return Container(
      margin: EdgeInsets.only(left: 10, bottom: 5, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  detailModel.data.goodsName,
                  maxLines: 2,
                  style: AppTextStyle.generate(ScreenAdapterUtils.setSp(18),
                      fontWeight: FontWeight.w600, color: Color(0xff333333)),
                ),
              ],
            ),
          ),
          UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
              ? Container()
              : Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.topRight,
                  child: CustomImageButton(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    direction: Direction.horizontal,
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(20)),
                    backgroundColor: Colors.grey[200],
                    color: Colors.grey[500],
                    fontSize: ScreenAdapterUtils.setSp(13),
                    icon: Icon(
                      AppIcons.icon_share_2,
                      size: 18,
                      color: Colors.grey[500],
                    ),
                    title: "分享",
                    contentSpacing: 5,
                    onPressed: () {
                      if (widget.shareCallback != null) {
                        widget.shareCallback();
                      }
                      // if (shareCallback != null) {
                      //   shareCallback();
                      // }
                    },
                  ))
        ],
      ),
    );
  }

  /// 详情
  Padding _detail() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        detailModel.data.description,
        style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
            fontWeight: FontWeight.w400, color: Color(0xffb5b5b5)),
      ),
    );
  }

  /// 标签
  Widget _label() {
    return Container(
      height: 5,
    );
  }

  _serviceLabel(title) {
    return CustomImageButton(
        onPressed: () {},
        title: title,
        color: Colors.black,
        direction: Direction.horizontal,
        fontSize: ScreenAdapterUtils.setSp(14),
        icon: Icon(
          AppIcons.icon_check,
          // color: Color(0xFFFC8381),
          color: Colors.red,
          size: ScreenAdapterUtils.setSp(20),
        ));
  }

  /// 服务
  _service() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _serviceLabel("全球精品"),
        _serviceLabel("正品保障"),
        _serviceLabel("一件包邮"),
        _serviceLabel("售后无忧"),
      ],
    );
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }
}
