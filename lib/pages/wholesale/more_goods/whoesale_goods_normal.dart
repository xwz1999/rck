import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/goods_detail_model.dart';
import 'package:jingyaoyun/models/goods_hot_sell_list_model.dart'
as GoodsHotSellListModel;
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/models/promotion_goods_list_model.dart';
import 'package:jingyaoyun/pages/goods/small_coupon_widget.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:jingyaoyun/pages/home/promotion_time_tool.dart';
import 'package:jingyaoyun/utils/share_tool.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

enum GoodsItemType {
  NONE,
  NORMAL,
  HOT_LIST,
  ROW_GOODS,
}

class GoodsItemWidget extends StatelessWidget {
  final bool isSingleDayGoods;
  final String goodsName;
  final String description;
  final String mainPhotoUrl;
  final num inventory;
  final num discountPrice;
  final num originalPrice;
  final num percent;
  final num coupon;
  final num commission;
  final num salesVolume;
  final num id;
  final String brandName;
  final String brandPictureUrl;
  final int isImport;

  final GoodsItemType widgetType;

  final bool notShowAmount;

  final List<String> specialSale;

  final List<String> specialIcon;

  // model.getPromotionStatus()
  final PromotionStatus promotionStatus;
  final Function onBrandClick;
  final int type; //type = 4 找相似  type = 3  京东商品

  final String countryIcon;
  final Living living;
  final GifController gifController;
  final num gysId;

  const GoodsItemWidget({
    Key key,
    this.isSingleDayGoods = false,
    this.goodsName,
    this.description,
    this.mainPhotoUrl,
    this.inventory,
    this.discountPrice,
    this.originalPrice,
    this.percent,
    this.coupon,
    this.commission,
    this.salesVolume,
    this.id,
    this.promotionStatus,
    this.buildCtx,
    this.shareClick,
    this.buyClick,
    this.brandName = "",
    this.brandPictureUrl = "",
    this.onBrandClick,
    this.isImport,
    this.notShowAmount = false,
    this.specialSale,
    this.specialIcon,
    this.type,
    this.countryIcon,
    this.living,
    this.gifController,
    this.gysId,
    //this.special_sale,
  })  : widgetType = GoodsItemType.NONE,
        super(key: key);




  final BuildContext buildCtx;
  final VoidCallback shareClick;
  final VoidCallback buyClick;

  static Color _shareTextColor = Color(0xffc70404);
  static double _height = 0;

  @override
  Widget build(BuildContext context) {
    _height = (MediaQuery.of(context).size.width - 20) * 150.0 / 350.0;

    return Container(
      height: _height,
      padding: EdgeInsets.only(bottom: 3.33, left: 10, right: 10),
      color: (this.widgetType == GoodsItemType.ROW_GOODS)
          ? AppColor.frenchColor
          : Colors.transparent,
      child: _container(),
    );
  }

  _container() {
    return Container(
      height: _height,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              color: Colors.white.withAlpha(0),
            ),
            onTap: () {
              _buyEvent();
            },
          ),
          GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _buyEvent();
                  },
                  child: _image(),
                ),
                _rowInfoWidget(),
              ],
            ),
            onTap: () {
              _buyEvent();
            },
          ),
        ],
      ),
    );
  }

  _brandWidget() {
    return GestureDetector(
        onTap: () {
          if (onBrandClick != null) onBrandClick();
        },
        child: Container(
          width: double.infinity,
          height: 25,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  TextUtils.isEmpty(brandName) ? "" : brandName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xffc70404),
                    fontSize: 12 * 2.sp,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _rowInfoWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 2,
                ),
                ExtendedText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: this.goodsName,
                        style: AppTextStyle.generate(16 * 2.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            // Offstage(
            //   offstage: !(model.getPromotionStatus() == PromotionStatus.start),
            //   // offstage: !(model.getPromotionStatus() == PromotionStatus.start || model.getPromotionStatus() == PromotionStatus.ready),
            //   child: _priceView(),
            // ),
            AppConfig.getShowCommission() ? _brandWidget() : SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _saleNumberWidget(),
                _inventoryView(),
              ],
            ),
          ],
        ),
      ),
    );
  }


  _image() {
    bool sellout = false;

    if (this.inventory > 0) {
      sellout = false;
    } else {
      sellout = true;
    }


    double cir = 5;
    return Container(
      width: _height - 8,
      height: _height - 8,
      decoration: BoxDecoration(
        color: AppColor.frenchColor,
        borderRadius: BorderRadius.all(Radius.circular(cir)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(cir)),
        child: Stack(children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: CustomCacheImage(
              borderRadius: BorderRadius.circular(5),
              width: _height - 8,
              height: _height - 8,
              imageUrl: Api.getImgUrl(this.mainPhotoUrl),
              fit: BoxFit.cover,
            ),
          ),
          //暂时隐藏
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Offstage(
              offstage: !sellout,
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Image.asset(
                    'assets/sellout_bg.png',
                    width: rSize(70),
                    height: rSize(70),
                  ),
                ),
              ),
            ),
          ),
          living?.status == 1
              ? Positioned(
            top: 6.rw,
            right: 6.rw,
            child: Container(
                width: 16.rw,
                height: 16.rw,
                child: GifImage(
                  controller: gifController,
                  image: AssetImage(R.ASSETS_LIVE_PLAY_GIF),
                  height: 16.rw,
                  width: 16.rw,
                )),
          )
              : SizedBox(),
          isSingleDayGoods
              ? Positioned(
            left: 0,
            top: 0,
            child: Image.asset(
              R.ASSETS_HOME_SINGLE_DAY_PNG,
              height: rSize(20),
            ),
          )
              : SizedBox(),
          specialSale != null
              ? Positioned(
              left: 5.rw,
              top: 5.rw,
              child: Container(
                ///color: Colors.red,
                width: (_height - 8.rw) / 3.rw * 2.rw,
                height: specialSale == null
                    ? 0
                    : specialSale.length ~/ 2 * 24.rw + 24.rw,
                child: GridView.builder(
                  shrinkWrap: true,
                  //reverse: true,
                  padding: EdgeInsets.zero,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.4,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemCount: specialSale.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                      // Container(
                      //   color: Colors.red,
                      // );
                      CustomCacheImage(
                        borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                        imageUrl: Api.getImgUrl(specialSale[index]),
                        fit: BoxFit.fill,
                      );
                  },
                ),
              ))
              : SizedBox(),
          specialIcon != null
              ? Positioned(
              left: 5.rw,
              top: 5.rw,
              child: Container(
                width: (_height - 8.rw) / 3.rw * 2.rw,
                height: specialSale == null
                    ? 0
                    : specialSale.length ~/ 2 * 26.rw,
                child: GridView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  padding: EdgeInsets.zero,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.4,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemCount: specialIcon.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                      // Container(
                      //   color: Colors.red,
                      // );
                      CustomCacheImage(
                        borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                        imageUrl: Api.getImgUrl(specialIcon[index]),
                        fit: BoxFit.fill,
                      );
                  },
                ),
              ))
              : SizedBox()
        ]),
      ),
    );
  }

  _inventoryView() {
    bool sellout = this.inventory <= 0;

    Color priceColor = Color(0xffc70404);
    return Container(
      height: 20 * 2.h,
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 1,
                ),
                Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        ExtendedText.rich(TextSpan(children: [
                          TextSpan(
                            text:  "券后 ¥ ",
                            style: AppTextStyle.generate(
                                12 * 2.sp,
                                color: priceColor,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text:
                            "${(this.discountPrice - this.discountPrice.toInt()) > 0 ? this.discountPrice.toStringAsFixed(1) : this.discountPrice.toStringAsFixed(0)}",
                            // text: "${model.discountPrice>=100?model.discountPrice.toStringAsFixed(0):model.discountPrice.toStringAsFixed(1)}",
                            style: TextStyle(
                                letterSpacing: -1,
                                wordSpacing: -1,
                                fontSize: 19 * 2.sp,
                                color: priceColor,
                                fontWeight: FontWeight.w500),
                          ),
                          WidgetSpan(
                              child: SizedBox(
                                width: 5,
                              )),
                          TextSpan(
                            text: "¥${this.originalPrice.toStringAsFixed(0)}",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Color(0xff898989),
                                fontSize: 12 * 2.sp,
                                color: Color(0xff898989),
                                fontWeight: FontWeight.w400),
                          )
                        ])),
                      ],
                    )),
                Expanded(child: Container()),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Spacer(),
              Container(
                width: 10,
              ),
             GestureDetector(
                child: CustomImageButton(
                  direction: Direction.horizontal,
                  height: 21,
                  //暂时隐藏
                  title: sellout ? "已售完" : "批发",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13 * 2.sp,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: UserLevelTool.currentRoleLevelEnum() ==
                          UserRoleLevel.Vip &&
                          this.promotionStatus ==
                              PromotionStatus.start
                          ? 16.rw
                          : 8.rw,
                      vertical: rSize(0)),
                  borderRadius: BorderRadius.circular(40),
                  backgroundColor:
                  //暂时隐藏
                  sellout ? AppColor.greyColor : _shareTextColor,

                  pureDisplay: true,
                ),
                onTap: () {
                  _buyEvent();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  _saleNumberWidget() {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: notShowAmount
                ? SizedBox()
                : Text(
              "已售${this.salesVolume}件",
              style: TextStyle(
                color: Color(0xff595757),
                fontSize: 12 * 2.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buyEvent() {

    if (buyClick != null) {
      buyClick();
    } else {
      AppRouter.push(buildCtx, RouteName.COMMODITY_PAGE,
          arguments:
          CommodityDetailPage.setArguments(this.id,
          ));
    }
  }

}
