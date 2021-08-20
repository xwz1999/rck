/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-11  15:52 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:extended_text/extended_text.dart';
import 'package:recook/constants/api.dart';

import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_cache_image.dart';
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

    if (detailModel.data.sku != null && detailModel.data.sku.length > 0) {
      coupon = detailModel.data.sku[0].coupon;
      detailModel.data.sku.forEach((element) {
        if (coupon > element.coupon) coupon = element.coupon;
      });
    } else {
      coupon = 0;
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
    return _normalPriceWidget(
        price, commission, originPrice, isTwoPrice, coupon);
  }

  _getDoubleText(double number) {
    if ((number - number.toInt()) > 0) {
      return number.toString();
    } else {
      return number.toInt().toString();
    }
  }

  _promotionPrice(price, commission, originPrice, coupon,
      {isTwoPrice = false}) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              (coupon != null && coupon != 0)
                  ? Container(
                      height: rSize(23),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              R.ASSETS_GOODS_DETAILS_BOTTOM_GOLD_PNG),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: rSize(12),
                            top: rSize(1),
                            right: rSize(12),
                            bottom: rSize(1)),
                        child: Text(
                          '$coupon\元优惠券',
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: rSize(1),
                                offset: Offset(0, rSize(1)),
                              ),
                            ],
                            fontSize: 14 * 2.sp,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              rWBox(10),
              Text(
                "$originPrice",
                style: AppTextStyle.generate(14 * 2.sp,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // (coupon != null && coupon != 0)
              //     ? Padding(
              //         padding: EdgeInsets.only(right: 10),
              //         child: SmallCouponWidget(
              //           couponType: SmallCouponType.white,
              //           number: coupon,
              //         ),
              //       )
              //     : SizedBox(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "券后价",
                    style: TextStyle(color: Colors.yellow, fontSize: 9 * 2.sp),
                  ),
                  TextSpan(
                      text: "￥",
                      style: AppTextStyle.generate(
                        ScreenAdapterUtils.setSp(
                          14,
                        ),
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )),
                  TextSpan(
                      text: "$price ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23 * 2.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      )),
                  TextSpan(
                    text: (UserLevelTool.currentRoleLevelEnum() ==
                                UserRoleLevel.None ||
                            UserLevelTool.currentRoleLevelEnum() ==
                                UserRoleLevel.Vip)
                        ? ""
                        : isTwoPrice
                            ? "/ "
                            : " / ",
                    style: AppTextStyle.generate(15 * 2.sp,
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: (UserLevelTool.currentRoleLevelEnum() ==
                                UserRoleLevel.None ||
                            UserLevelTool.currentRoleLevelEnum() ==
                                UserRoleLevel.Vip)
                        ? ""
                        : "赚",
                    style:
                        AppTextStyle.generate(13 * 2.sp, color: Colors.white),
                  ),
                  TextSpan(
                    text: (UserLevelTool.currentRoleLevelEnum() ==
                                UserRoleLevel.None ||
                            UserLevelTool.currentRoleLevelEnum() ==
                                UserRoleLevel.Vip)
                        ? ""
                        : "$commission",
                    style:
                        AppTextStyle.generate(15 * 2.sp, color: Colors.white),
                  ),
                ]),
              ),
            ],
          ),
          rHBox(10),
        ],
      ),
    );
  }

  _normalPriceWidget(price, commission, originPrice, isTwoPrice, coupon) {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
            child: Image.asset(
              R.ASSETS_GOODS_DETAILS_BOTTOM_ANIMAL_PNG,
              fit: BoxFit.fitWidth,
            ),
            left: 0,
            right: 0,
            bottom: 0,
          ),
          _promotionPrice(
            price,
            commission,
            originPrice,
            coupon,
            isTwoPrice: isTwoPrice,
          ),
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
                ExtendedText.rich(
                  TextSpan(
                    children: [
                      detailModel.data.isImport == 1
                          ? ExtendedWidgetSpan(
                              alignment: PlaceholderAlignment.bottom,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 3),
                                alignment: Alignment.center,
                                width: 24,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: detailModel.data.countryIcon == null
                                      ? Color(0xFFCC1B4F)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(3 * 2.w),
                                ),
                                child: detailModel.data.countryIcon == null
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
                                            detailModel.data.countryIcon),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            )
                          : WidgetSpan(child: SizedBox()),
                      detailModel.data.isImport == 1
                          ? WidgetSpan(
                              child: Container(
                              width: 5 * 2.w,
                            ))
                          : WidgetSpan(child: SizedBox()),
                      TextSpan(
                        text: detailModel.data.goodsName,
                        style: AppTextStyle.generate(18 * 2.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff333333)),
                      ),
                    ],
                  ),
                  maxLines: 2,
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
                    fontSize: 13 * 2.sp,
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
        style: AppTextStyle.generate(14 * 2.sp,
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
        fontSize: 14 * 2.sp,
        icon: Icon(
          AppIcons.icon_check,
          // color: Color(0xFFFC8381),
          color: Colors.red,
          size: 20 * 2.sp,
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
