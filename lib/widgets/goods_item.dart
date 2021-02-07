import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_hot_sell_list_model.dart'
    as GoodsHotSellListModel;
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/models/promotion_goods_list_model.dart';
import 'package:recook/pages/goods/small_coupon_widget.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  // model.getPromotionStatus()
  final PromotionStatus promotionStatus;
  final Function onBrandClick;
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
  })  : widgetType = GoodsItemType.NONE,
        super(key: key);

  /// Normal Goods Item
  GoodsItemWidget.normalGoodsItem({
    Key key,
    this.isSingleDayGoods = false,
    this.buildCtx,
    this.shareClick,
    this.buyClick,
    this.onBrandClick,
    GoodsSimple model,
    this.notShowAmount = false,
  })  : goodsName = model.goodsName,
        brandName = model.brandName,
        brandPictureUrl = model.brandImg,
        description = model.description,
        mainPhotoUrl = model.mainPhotoUrl,
        inventory = model.inventory,
        discountPrice = model.discountPrice,
        originalPrice = model.originalPrice,
        percent = model.percent,
        coupon = model.coupon,
        commission = model.commission,
        salesVolume = model.salesVolume,
        id = model.id,
        promotionStatus = model.getPromotionStatus(),
        widgetType = GoodsItemType.NORMAL,
        isImport = model.isImport,
        super(key: key);

  ///Hot List
  GoodsItemWidget.hotList({
    Key key,
    this.buildCtx,
    this.shareClick,
    this.buyClick,
    this.onBrandClick,
    this.isSingleDayGoods = false,
    GoodsHotSellListModel.Data data,
    this.notShowAmount = false,
  })  : goodsName = data.goodsName,
        brandName = data.brandName,
        brandPictureUrl = data.brandImg,
        description = data.description,
        mainPhotoUrl = data.mainPhotoUrl,
        inventory = data.inventory,
        discountPrice = data.discountPrice,
        originalPrice = data.originalPrice,
        //TODO hot list unset percent;
        percent = 0,
        coupon = data.coupon,
        commission = data.commission,
        salesVolume = data.salesVolume,
        id = data.id,
        //TODO hot list unset promotion status;
        promotionStatus = PromotionStatus.none,
        widgetType = GoodsItemType.HOT_LIST,
        isImport = data.isImport,
        super(key: key);

  /// 活动列表
  GoodsItemWidget.rowGoods({
    Key key,
    this.buildCtx,
    this.shareClick,
    this.onBrandClick,
    this.isSingleDayGoods = false,
    @required this.buyClick,
    PromotionGoodsModel model,
    this.notShowAmount = false,
  })  : goodsName = model.goodsName,
        brandName = model.brandName,
        brandPictureUrl = model.brandImg,
        description = model.description,
        mainPhotoUrl = model.picture.url,
        inventory = model.inventory,
        originalPrice = model.primePrice,
        discountPrice = model.price,
        percent = model.percentage,
        coupon = model.coupon,
        commission = model.commission,
        salesVolume = model.totalSalesVolume,
        id = model.goodsId,
        promotionStatus = model.getPromotionStatus(),
        widgetType = GoodsItemType.ROW_GOODS,
        isImport = model.isImport,
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
      // color: Colors.transparent,
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
              Container(
                width: 13 * 1.5,
                height: 13 * 1.5,
                child: TextUtils.isEmpty(brandPictureUrl)
                    ? SizedBox()
                    : ExtendedImage.network(
                        Api.getImgUrl(brandPictureUrl),
                        fit: BoxFit.fill,
                      ),
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  TextUtils.isEmpty(brandName) ? "" : brandName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xffc70404),
                    fontSize: ScreenAdapterUtils.setSp(12),
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
                      this.isImport == 1
                          ? WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                alignment: Alignment.center,
                                width: 24,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Color(0xFFCC1B4F),
                                  borderRadius: BorderRadius.circular(
                                      ScreenAdapterUtils.setWidth(3)),
                                ),
                                child: Text(
                                  '进口',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenAdapterUtils.setSp(10),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : WidgetSpan(child: SizedBox()),
                      this.isImport == 1
                          ? WidgetSpan(
                              child: Container(
                              width: ScreenAdapterUtils.setWidth(5),
                            ))
                          : WidgetSpan(child: SizedBox()),
                      TextSpan(
                        text: this.goodsName,
                        style: AppTextStyle.generate(
                            ScreenAdapterUtils.setSp(15),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 2),
                  child: this.description == null
                      ? Container()
                      : Text(
                          this.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(
                              ScreenAdapterUtils.setSp(14),
                              color: Colors.black54,
                              fontWeight: FontWeight.w300),
                        ),
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

  _addGestureDetectorForWidget(Widget widget, VoidCallback click) {
    return GestureDetector(
      child: widget,
      onTap: () {
        if (click != null) click();
      },
    );
  }

  _image() {
    double cir = 5;
    return Container(
      width: _height - 8,
      height: _height - 8,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(cir)),
        child: Stack(children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(color: AppColor.frenchColor),
          ),
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
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Offstage(
              offstage: this.inventory > 0,
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
        ]),
      ),
    );
  }

  _inventoryView() {
    bool sellout = this.inventory <= 0;
    Color priceColor = Color(0xffc70404);
    return Container(
      height: ScreenAdapterUtils.setHeight(20),
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
                  child: ExtendedText.rich(TextSpan(children: [
                    TextSpan(
                      text: "券后 ¥ ",
                      style: AppTextStyle.generate(ScreenAdapterUtils.setSp(12),
                          color: priceColor, fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text:
                          "${(this.discountPrice - this.discountPrice.toInt()) > 0 ? this.discountPrice.toStringAsFixed(1) : this.discountPrice.toStringAsFixed(0)}",
                      // text: "${model.discountPrice>=100?model.discountPrice.toStringAsFixed(0):model.discountPrice.toStringAsFixed(1)}",
                      style: TextStyle(
                          letterSpacing: -1,
                          wordSpacing: -1,
                          fontSize: ScreenAdapterUtils.setSp(18),
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
                          fontSize: ScreenAdapterUtils.setSp(12),
                          color: Color(0xff898989),
                          fontWeight: FontWeight.w400),
                    )
                  ])),
                ),
                // Container(
                //   width: 5,
                // ),
                // Container(
                //   height: double.infinity,
                //   alignment: Alignment.center,
                //   child: RichText(
                //     text: TextSpan(children: [
                //       TextSpan(
                //         text: "¥${this.originalPrice.toStringAsFixed(0)}",
                //         style: TextStyle(
                //             decoration: TextDecoration.lineThrough,
                //             decorationColor: Color(0xff898989),
                //             fontSize: ScreenAdapterUtils.setSp(12),
                //             color: Color(0xff898989),
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ])),
                // ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Spacer(),
              UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        if (shareClick != null) {
                          shareClick();
                        } else {
                          _shareEvent();
                        }
                      },
                      child: Container(
                        color: Colors.white.withAlpha(1),
                        height: double.infinity,
                        padding: EdgeInsets.only(left: 10),
                        child: Image.asset(
                          "assets/share.png",
                          width: 19,
                          height: 19,
                        ),
                      ),
                    ),
              // GestureDetector(
              //     child: CustomImageButton(
              //       height: 21,
              //       title: "导购",
              //       style: TextStyle(
              //           fontSize: ScreenAdapterUtils.setSp(13),
              //           color: sellout ? Colors.grey : _shareTextColor),
              //       padding: EdgeInsets.symmetric(
              //           horizontal: rSize(8),
              //           vertical: rSize(0)),
              //       borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(40),
              //           bottomLeft: Radius.circular(40)),
              //       border: Border.all(
              //           color: sellout ? Colors.grey : _shareTextColor,
              //           width: 0.5),
              //       pureDisplay: true,
              //     ),
              //     onTap: () {
              //       // if (shareClick != null) shareClick();
              //       if (shareClick != null) {
              //         shareClick();
              //       } else {
              //         _shareEvent();
              //       }
              //     },
              //   ),
              Container(
                width: 10,
              ),
              GestureDetector(
                child: CustomImageButton(
                  direction: Direction.horizontal,
                  height: 21,
                  title: sellout ? "已售完" : "自购",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenAdapterUtils.setSp(13),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenAdapterUtils.setWidth(
                          UserLevelTool.currentRoleLevelEnum() ==
                                      UserRoleLevel.Vip &&
                                  this.promotionStatus == PromotionStatus.start
                              ? 16
                              : 8),
                      vertical: rSize(0)),
                  borderRadius: BorderRadius.circular(40),
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(
                  //         UserLevelTool.currentRoleLevelEnum() ==
                  //                 UserRoleLevel.Vip
                  //             ? 40
                  //             : 0),
                  //     bottomLeft: Radius.circular(
                  //         UserLevelTool.currentRoleLevelEnum() ==
                  //                 UserRoleLevel.Vip
                  //             ? 40
                  //             : 0),
                  //     topRight: Radius.circular(40),
                  //     bottomRight: Radius.circular(40)),
                  backgroundColor:
                      sellout ? AppColor.greyColor : _shareTextColor,
                  pureDisplay: true,
                ),
                onTap: () {
                  _buyEvent();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _priceView() {
    if (promotionStatus == PromotionStatus.ready) {
      return Container();
    }
    return Row(
      children: <Widget>[
        _stockWidget(),
        Container(
          width: 10,
        ),
        Expanded(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: "已售",
                  style: TextStyle(color: Colors.black, fontSize: 11)),
              TextSpan(
                  text: "${(this.percent / 100.0).toStringAsFixed(0)}%",
                  style: TextStyle(color: Color(0xffec294d), fontSize: 11)),
            ]),
          ),
        ),
      ],
    );
  }

  _saleNumberWidget() {
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              (this.coupon != null && this.coupon != 0)
                  ? Container(
                      margin: EdgeInsets.only(right: 5),
                      child: SmallCouponWidget(
                        height: 18,
                        number: this.coupon,
                      ),
                    )
                  : SizedBox(),
              AppConfig.commissionByRoleLevel
                  ? Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: Color(0xffec294d),
                                  width: 0.5,
                                )),
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              "赚" + this.commission.toStringAsFixed(2),
                              style: TextStyle(
                                color: Colors.white.withAlpha(0),
                                fontSize: ScreenAdapterUtils.setSp(12),
                              ),
                            ),
                          ),
                          AppConfig.getShowCommission()
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "赚" + this.commission.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Color(0xffeb0045),
                                      fontSize: ScreenAdapterUtils.setSp(12),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
                  : SizedBox(),
              Spacer(),
            ],
          ),
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
                      fontSize: ScreenAdapterUtils.setSp(12),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _stockWidget() {
    double height = 4;
    double allWidth = 120;
    double proportion = this.percent / 100.0;
    double width = allWidth * proportion < 4 && allWidth * proportion > 0
        ? 4
        : allWidth * proportion;
    return Container(
      width: allWidth,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(height)),
          // color: AppColor.pinkColor,
          color: Color(0xffdcdddd)),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(height)),
              color: AppColor.themeColor,
            ),
            width: width,
            height: height,
          ),
        ],
      ),
    );
  }

  _shareEvent() {
    String goodsTitle =
        "￥${this.discountPrice} | ${this.goodsName} | ${this.description}";
    ShareTool().goodsShare(buildCtx,
        goodsPrice: this.discountPrice.toStringAsFixed(2),
        goodsName: this.goodsName,
        goodsDescription: this.description,
        miniTitle: goodsTitle,
        miniPicurl: this.mainPhotoUrl,
        amount: this.commission.toString(),
        goodsId: this.id.toString());
  }

  _buyEvent() {
    if (buyClick != null) {
      buyClick();
    } else {
      AppRouter.push(buildCtx, RouteName.COMMODITY_PAGE,
          arguments: CommodityDetailPage.setArguments(this.id));
    }
  }
}
