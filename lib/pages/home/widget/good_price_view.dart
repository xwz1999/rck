import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';

class GoodPriceView extends StatefulWidget {
  final GoodsDetailModel detailModel;
  final VoidCallback shareCallback;

  const GoodPriceView({
    Key key,
    this.detailModel,
    this.shareCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoodPriceViewState();
  }
}

class _GoodPriceViewState extends State<GoodPriceView> {
  GoodsDetailModel detailModel;
  VoidCallback shareCallback;

  num _coupon = 0;

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
        Padding(
          padding: EdgeInsets.only(left: 10.rw, right: 10.rw,top: 8.rw),
          child: _price(),
        ),
        _name(),
        _detail(),
        //京东商品隐藏
        widget.detailModel.data.vendorId == 1800 ||
                widget.detailModel.data.vendorId == 2000
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.only(top: 5.rw),
                child: _service(),
              ),
      ],
    );
  }

  Container _price() {
    // bool hasPromotion = detailModel.data.promotion != null;
    double minPrice = 0.0,
        //maxPrice,
        // maxCommission,
        minCommission = 0.0,
        minOriginPrice = 0.0;
        //maxOriginPrice;
    num coupon = 0;
    int saleNum = 0;
    //
    // maxCommission = detailModel.data.price.max.commission;
    // minCommission = detailModel.data.price.min.commission;

    detailModel.data.sku.forEach((element) {
      if(minPrice==0.0){
        minPrice = element.discountPrice;
        minCommission = element.commission;
        minOriginPrice = element.originalPrice;
      }else
        if(element.discountPrice<minPrice){
          minPrice = element.discountPrice;
          minCommission = element.commission;
          minOriginPrice = element.originalPrice;
        }

    });


    saleNum = detailModel.data.salesVolume;

    // minOriginPrice = detailModel.data.price.min.originalPrice;


    if (detailModel.data.sku != null && detailModel.data.sku.length > 0) {
      coupon = detailModel.data.sku[0].coupon;
      detailModel.data.sku.forEach((element) {
        if (coupon > element.coupon) coupon = element.coupon;
      });
    } else {
      coupon = 0;
    }

    _coupon = coupon;

//    if (hasPromotion) {
//    } else {
//      minPrice = detailModel.data.price.min.originalPrice;
//      maxPrice = detailModel.data.price.max.originalPrice;
//    }

    String commission, price, originPrice;


    commission = minCommission.toStringAsFixed(2);

    price = (minPrice - minCommission).toStringAsFixed(2);


    originPrice = minOriginPrice.toStringAsFixed(2);


    //
    // if (maxPrice == minPrice) {
    //   price = maxPrice.toStringAsFixed(2);
    // } else {
    //   // price = "${minPrice.toStringAsFixed(2)}-${maxPrice.toStringAsFixed(2)}";
    //   price = minPrice.toStringAsFixed(2); //"${_getDoubleText(minPrice)}-${_getDoubleText(maxPrice)}";
    // }
    // bool isTwoPrice = false;
    // if (minOriginPrice == maxOriginPrice) {
    //   originPrice = maxOriginPrice.toStringAsFixed(2);
    // } else {
    //   originPrice =_getDoubleText(minOriginPrice);
    //       //"${_getDoubleText(minOriginPrice)}-${_getDoubleText(maxOriginPrice)}";
    //   isTwoPrice = true;
    // }
    //
    // if (maxCommission == minCommission) {
    //   commission = maxCommission.toStringAsFixed(2);
    // } else {
    //   commission =_getDoubleText(minCommission);
    //       //"${_getDoubleText(minCommission)}-${_getDoubleText(maxCommission)}";
    // }
    return _normalPriceWidget(
        price, commission, originPrice, coupon, saleNum);
  }

  _getDoubleText(double number) {
    if ((number - number.toInt()) > 0) {
      return number.toString();
    } else {
      return number.toInt().toString();
    }
  }

  _promotionPrice(price, commission, originPrice, coupon, saleNum,
      {isTwoPrice = false}) {
    return Container(
      padding: EdgeInsets.only(top: 8.rw, left: 12.rw),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "折后价",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.rsp,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " ￥",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.rsp,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: "$price ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.rsp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      )),
                  WidgetSpan(child:
                  !AppConfig.commissionByRoleLevel?SizedBox():Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.rw,
                      horizontal: 8.rw
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(Assets.priceGoodsBg.path),fit: BoxFit.fill)
                    ),
                    child: Row(
                      children: [
                        Text(
                           "分享赚",
                          style: AppTextStyle.generate(12 * 2.sp,
                              color: Color(0xFFED3D19)),
                        ),
                        Text(
                           "¥$commission",
                          style: AppTextStyle.generate(14 * 2.sp,
                              color: Color(0xFFED3D19)),
                        ),

                      ],
                    ),
                  )),

                ]),
              ),
              Spacer(),

              24.wb,
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 2.rw,
                horizontal: 8.rw
            ),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(Assets.priceDetailBg.path),fit: BoxFit.fill)
            ),
            child: Row(
              children: <Widget>[
                Text(
                  "折后价=$originPrice(官方指导价)",
                  style: AppTextStyle.generate(
                    10 .rsp,
                    color: Colors.white,
                  ),
                ),

                (coupon != null && coupon != 0)
                    ? Text(
                      '—¥$coupon(优惠券)',
                      style: TextStyle(
                        fontSize: 10.rsp,
                        color: Colors.white,
                      ),
                    )
                    : SizedBox(),
                Text(
                  '—¥$commission(折扣额)',
                  style: TextStyle(
                    fontSize: 10.rsp,
                    color: Colors.white,
                  ),
                ),
                rWBox(10),

              ],
            ),
          ),
          rHBox(10),
        ],
      ),
    );
  }

  _normalPriceWidget(
      price, commission, originPrice, coupon, saleNum) {
    return Container(
      height: 82.rw,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill, image: AssetImage(Assets.headPriceBg.path)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Color(0xFFDBDBDB),
        //     blurRadius: 4,
        //     offset: Offset(0, -2),
        //   ),
        // ],
      ),
      child: _promotionPrice(
        price,
        commission,
        originPrice,
        coupon,
        saleNum,

      ),
    );
  }

  Container _name() {
    return Container(
      margin: EdgeInsets.all(12.rw),

      alignment: Alignment.center,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              detailModel.data.isImport == 1
                  ? Container(
                      child: Container(
                        margin: EdgeInsets.only(right: 8.rw, top: 5.rw),
                        alignment: Alignment.center,
                        width: 24.rw,
                        height: 15.rw,
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
                                imageUrl:
                                    Api.getImgUrl(detailModel.data.countryIcon),
                                fit: BoxFit.cover,
                              ),
                      ),
                    )
                  : Container(child: SizedBox()),
              detailModel.data.isImport == 1
                  ? Container(
                      child: Container(
                      width: 5 * 2.w,
                    ))
                  : Container(child: SizedBox()),
              detailModel.data.vendorId == 1800 || detailModel.data.vendorId == 2000
                  ? //jd的商品供应商 自营为1800 pop 为2000?
                  Container(
                      child: Container(
                      width: 40.rw,
                      height: 15.rw,
                      margin: EdgeInsets.only(right: 8.rw, top: 5.rw),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFC92219),
                        borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                      ),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          2.hb,
                          Text(
                            detailModel.data.vendorId == 1800
                                ? '京东自营'
                                : detailModel.data.vendorId == 2000
                                    ? '京东优选'
                                    : '',
                            maxLines: 1,
                            style: TextStyle(fontSize: 9.rsp, height: 1.05),
                          ),
                        ],
                      ),
                    ))
                  : Container(child: SizedBox()),

              Expanded(
                child: Text(
                  detailModel.data.goodsName,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.generate(
                    16.rsp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333),
                  ),
                ),
              ),
              Text(
                '已售${detailModel.data.salesVolume}件',
                style: TextStyle(
                  // shadows: [
                  //   Shadow(
                  //     color: Colors.black26,
                  //     blurRadius: rSize(1),
                  //     offset: Offset(0, rSize(1)),
                  //   ),
                  // ],
                  fontSize: 12.rsp,
                  color: Color(0xFF666666),
                ),
              ),

              // UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
              //     ? Container()
              //     : Container(
              //         margin: EdgeInsets.only(left: 10),
              //         alignment: Alignment.topRight,
              //         child: CustomImageButton(
              //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              //           direction: Direction.horizontal,
              //           borderRadius:
              //               BorderRadius.horizontal(left: Radius.circular(20)),
              //           backgroundColor: Colors.grey[200],
              //           color: Colors.grey[500],
              //           fontSize: 13 * 2.sp,
              //           icon: Icon(
              //             AppIcons.icon_share_2,
              //             size: 18,
              //             color: Colors.grey[500],
              //           ),
              //           title: "分享",
              //           contentSpacing: 5,
              //           onPressed: () {
              //             if (widget.shareCallback != null) {
              //               widget.shareCallback();
              //             }
              //             // if (shareCallback != null) {
              //             //   shareCallback();
              //             // }
              //           },
              //         ))
            ],
          ),
          32.hb,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.rw,horizontal: 21.rw),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage(Assets.couponBg.path)),
            ),
            child: Row(
              children: [
                Text(
                  '¥',
                  style: TextStyle(
                    fontSize: 16.rsp,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$_coupon',
                  style: TextStyle(
                    fontSize: 24.rsp,
                    color: Colors.white,
                  ),
                ),
                32.wb,
                Text(
                  '商家补贴优惠券',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Text(
                  '下单直降',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

  /// 详情
  Widget _detail() {
    return detailModel.data.description != ''
        ? Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              detailModel.data.description,
              style: AppTextStyle.generate(14 * 2.sp,
                  fontWeight: FontWeight.w400, color: Color(0xffb5b5b5)),
            ),
          )
        : SizedBox();
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
