import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/app_image_resources.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/models/goods_detail_model.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_detail_model.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class WholesaleGoodPriceView extends StatefulWidget {
  final WholesaleDetailModel detailModel;
  final VoidCallback shareCallback;


  const WholesaleGoodPriceView(
      {Key key, this.detailModel, this.shareCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleGoodPriceViewState();
  }
}

class _WholesaleGoodPriceViewState extends State<WholesaleGoodPriceView> {
  WholesaleDetailModel detailModel;
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
        Container(
          width: double.infinity,
          height: 8.rw,
          color: AppColor.frenchColor,
        ),
        _name(),
        _detail(),
      ],
    );
  }

  Container _price() {
    // bool hasPromotion = detailModel.data.promotion != null;
    num minPrice,
        maxPrice,
        maxCommission,
        minCommission,
        minOriginPrice,
        maxOriginPrice;

    int saleNum = 0;

    int min = 0;///起批量



    minPrice = detailModel.price.min.salePrice;
    maxPrice = detailModel.price.max.salePrice;


    saleNum = detailModel.salesVolume;

    minOriginPrice = detailModel.price.min.discountPrice;///批发的零售价为券后价
    maxOriginPrice = detailModel.price.max.discountPrice;

    maxCommission = maxOriginPrice - maxPrice;
    minCommission = minOriginPrice - minPrice;

    if (detailModel.sku != null && detailModel.sku.length > 0) {
      min = detailModel.sku[0].min;
      detailModel.sku.forEach((element) {
        if (min < element.min) min = element.min;
      });
    } else {
      min = 0;
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
        price, commission, originPrice, isTwoPrice, saleNum,min);
  }

  _getDoubleText(num number) {
    if ((number - number.toInt()) > 0) {
      return number.toStringAsFixed(2);
    } else {
      return number.toInt().toStringAsFixed(2);
    }
  }

  _promotionPrice(price, commission, originPrice, saleNum,min,
      {isTwoPrice = false}) {
    return Container(
      padding: EdgeInsets.only(top: 8.rw, left: 12.rw),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text:  '批发价' ,
                    style: TextStyle(
                        color: Color(0xFFD5101A),
                        fontSize: 14.rsp,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " ￥",
                    style: TextStyle(
                        color: Color(0xFFD5101A),
                        fontSize: 16.rsp,
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                      text: "$price ",
                      style: TextStyle(
                        color: Color(0xFFD5101A),
                        fontSize: 22.rsp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      )),
                    TextSpan(
                          text: "$min件起批",
                          style: AppTextStyle.generate(12 * 2.sp,
                              color: Color(0xFF666666)),
                        ),

                ]),
              ),
              Spacer(),
              Text(
                '已定$saleNum单',
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
              24.wb,
            ],
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Container(
                      height: rSize(23),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFFD5101A), width: 0.5.rw),
                          borderRadius: BorderRadius.all(Radius.circular(4.rw))
                          // image: DecorationImage(
                          //   fit: BoxFit.fill,
                          //   image: AssetImage(
                          //       R.ASSETS_GOODS_DETAILS_BOTTOM_GOLD_PNG),
                          // ),
                          ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 6.rw,
                          top: rSize(0),
                          right: 6.rw,
                          bottom: rSize(0),
                        ),
                        child: Text(
                          '预估利润¥$commission',
                          style: TextStyle(
                            // shadows: [
                            //   Shadow(
                            //     color: Colors.black26,
                            //     blurRadius: rSize(1),
                            //     offset: Offset(0, rSize(1)),
                            //   ),
                            // ],
                            fontSize: 12.rsp,
                            color: Color(0xFFD5101A),
                          ),
                        ),
                      ),
                    ),
              rWBox(10),
             Text(
                "零售价¥$originPrice",
                style: AppTextStyle.generate(
                  14.rsp,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          rHBox(10),
        ],
      ),
    );
  }

  _normalPriceWidget(
      price, commission, originPrice, isTwoPrice, saleNum,limit) {
    return Container(
      height: 82.rw,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFDBDBDB),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: _promotionPrice(
        price,
        commission,
        originPrice,
        saleNum,
        limit,
        isTwoPrice: isTwoPrice,
      ),
    );
  }

  Container _name() {
    return Container(
      margin: EdgeInsets.all(12.rw),
      alignment: Alignment.center,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          detailModel.isImport == 1
              ? Container(
                  child: Container(
                  width: 5 * 2.w,
                ))
              : Container(child: SizedBox()),
          detailModel.vendorId == 1800 || detailModel.vendorId == 2000
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
                        detailModel.vendorId == 1800
                            ? '京东自营'
                            : detailModel.vendorId == 2000
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
              detailModel.goodsName,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.generate(
                16.rsp,
                fontWeight: FontWeight.w600,
                color: Color(0xff333333),
              ),
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
    );
  }

  /// 详情
  Widget _detail() {
    return detailModel.description != ''
        ? Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              detailModel.description,
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
