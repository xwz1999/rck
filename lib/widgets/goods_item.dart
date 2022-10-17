import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/goods_hot_sell_list_model.dart'
    as GoodsHotSellListModel;
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/models/promotion_goods_list_model.dart';
import 'package:recook/pages/goods/small_coupon_widget.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/toast.dart';

enum GoodsItemType {
  NONE,
  NORMAL,
  HOT_LIST,
  ROW_GOODS,
}

class GoodsItemWidget extends StatelessWidget {

  final bool isSingleDayGoods;
  final String? goodsName;
  final String? description;
  final String? mainPhotoUrl;
  final num? inventory;
  final num? discountPrice;
  final num? originalPrice;
  final num? percent;
  final num? coupon;
  final num? commission;
  final num? salesVolume;
  final num? id;
  final String? brandName;
  final String? brandPictureUrl;
  final int? isImport;

  final GoodsItemType widgetType;

  final bool notShowAmount;

  final List<String>? specialSale;

  final List<String>? specialIcon;

  // model.getPromotionStatus()
  final PromotionStatus? promotionStatus;
  final Function? onBrandClick;
  final int? type; //type = 4 找相似  type = 3  京东商品

  final String? countryIcon;
  final Living? living;
  final GifController? gifController;
  final num? gysId;

  const GoodsItemWidget({
    Key? key,
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

  /// Normal Goods Item
  GoodsItemWidget.normalGoodsItem({
    Key? key,
    this.isSingleDayGoods = false,
    this.buildCtx,
    this.shareClick,
    this.buyClick,
    this.onBrandClick,
    required GoodsSimple model,
    this.notShowAmount = false,
    this.specialSale,
    this.type,
    this.gifController,

    //this.special_sale,
  })  : goodsName = model.goodsName,
        brandName = model.brandName,
        brandPictureUrl = model.brandImg,
        description = model.description,
        mainPhotoUrl = model.mainPhotoUrl,
        inventory = model.inventory,
        originalPrice = model.originalPrice,
        percent = model.percent,
        coupon = model.coupon,
        id = model.id,
        promotionStatus = model.getPromotionStatus(),
        widgetType = GoodsItemType.NORMAL,
        isImport = model.isImport as int?,
        specialIcon = model.specialIcon,
        countryIcon = model.countryIcon,
        living = model.living,
        gysId = model.gysId,
        salesVolume =  model.salesVolume,
        discountPrice =  model.discountPrice,
        commission =  model.commission,
        super(key: key);

  ///Hot List
  GoodsItemWidget.hotList({
    Key? key,
    this.buildCtx,
    this.shareClick,
    this.buyClick,
    this.onBrandClick,
    this.isSingleDayGoods = false,
    required GoodsHotSellListModel.Data data,
    this.notShowAmount = false,
    this.specialSale,
    this.specialIcon,
    this.type,
    this.living,
    this.gifController,
  })  : goodsName = data.goodsName,
        brandName = data.brandName,
        brandPictureUrl = data.brandImg,
        description = data.description,
        mainPhotoUrl = data.mainPhotoUrl,
        inventory =  data.inventory,
        originalPrice = data.originalPrice,
        percent = 0,
        coupon = data.coupon,
        id = data.id,
        promotionStatus = PromotionStatus.none,
        widgetType = GoodsItemType.HOT_LIST,
        isImport = data.isImport,
        countryIcon = data.countryIcon,
        gysId = data.gysId,
        salesVolume = data.salesVolume,
        discountPrice = data.discountPrice,
        commission =  data.commission,
        super(key: key);

  /// 活动列表
  GoodsItemWidget.rowGoods({
    Key? key,
    this.buildCtx,
    this.shareClick,
    this.onBrandClick,
    this.isSingleDayGoods = false,
    required this.buyClick,
    required PromotionGoodsModel model,
    this.notShowAmount = false,
    this.type,
    this.gifController,
  })  : goodsName = model.goodsName,
        brandName = model.brandName,
        brandPictureUrl = model.brandImg,
        description = model.description,
        mainPhotoUrl = model.picture!.url,
        inventory = model.secKill!.secKill == 1
            ? model.secKill!.realStock
            : model.inventory,
        originalPrice = model.primePrice,
        percent = model.percentage,
        coupon = model.coupon,
        id = model.goodsId,
        promotionStatus = model.getPromotionStatus(),
        widgetType = GoodsItemType.ROW_GOODS,
        isImport = model.isImport as int?,
        specialSale = model.specialSale,
        specialIcon = model.specialIcon,
        countryIcon = model.countryIcon,
        living = model.living,
        gysId = model.gysId,
        salesVolume =  model.totalSalesVolume,
        discountPrice =  model.price,
        commission =  model.commission,
        super(key: key);


  final BuildContext? buildCtx;
  final VoidCallback? shareClick;
  final VoidCallback? buyClick;

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
          if (onBrandClick != null) onBrandClick!();
        },
        child: Container(
          width: double.infinity,
          height: 25,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  TextUtils.isEmpty(brandName) ? "" : brandName!,
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
                      this.isImport == 1
                          ? WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                alignment: Alignment.center,
                                width: 24.rw,
                                height: 16.rw,
                                decoration: BoxDecoration(
                                  color: countryIcon == null
                                      ? Color(0xFFCC1B4F)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(3 * 2.w),
                                ),
                                child: countryIcon == null
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
                                        imageUrl: Api.getImgUrl(countryIcon),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            )
                          : WidgetSpan(child: SizedBox()),
                      this.isImport == 1
                          ? WidgetSpan(
                              child: Container(
                              width: 5 * 2.w,
                            ))
                          : WidgetSpan(child: SizedBox()),
                      gysId == 1800 || gysId == 2000
                          ? //jd的商品供应商 自营为1800 pop 为2000?
                          WidgetSpan(
                              child: Container(
                                  padding:
                                      EdgeInsets.only(right: 5.rw, bottom: 2.w),
                                  child: Container(
                                    width: 40.rw,
                                    height: 15.rw,
                                    //padding: EdgeInsets.only(left: 1.rw),

                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC92219),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.rw)),
                                    ),

                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        2.hb,
                                        Text(
                                          gysId == 1800
                                              ? '京东自营'
                                              : gysId == 2000
                                                  ? '京东优选'
                                                  : '',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 9.rsp, height: 1.05),
                                        ),
                                      ],
                                    ),
                                  )))
                          : WidgetSpan(child: SizedBox()),
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
                this.description == null
                    ? SizedBox()
                    : Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 2),
                        child:
                            Text(
                          this.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.generate(14 * 2.sp,
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
            AppConfig.getShowCommission()! ? _brandWidget() : SizedBox(),
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

      if (this.inventory! > 0) {
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
              placeholder: Assets.placeholderNew1x1A.path,
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
                        controller: gifController!,
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
                        : specialSale!.length ~/ 2 * 24.rw + 24.rw,
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
                      itemCount: specialSale!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return
                            // Container(
                            //   color: Colors.red,
                            // );
                            CustomCacheImage(
                          borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                          imageUrl: Api.getImgUrl(specialSale![index]),
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
                        : specialSale!.length ~/ 2 * 26.rw,
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
                      itemCount: specialIcon!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return
                            // Container(
                            //   color: Colors.red,
                            // );
                            CustomCacheImage(
                          borderRadius: BorderRadius.all(Radius.circular(2.rw)),
                          imageUrl: Api.getImgUrl(specialIcon![index]),
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
    bool sellout = this.inventory! <= 0;

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
                            text:  "折后 ¥",
                            style: AppTextStyle.generate(
                                 12 * 2.sp,
                                color: priceColor,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text:
                                "${(this.discountPrice!-this.commission!).toStringAsFixed(2)}",
                            // text: "${model.discountPrice>=100?model.discountPrice.toStringAsFixed(0):model.discountPrice.toStringAsFixed(1)}",
                            style: TextStyle(
                                letterSpacing: -1,
                                wordSpacing: -1,
                                fontSize: 17 * 2.sp,
                                color: priceColor,
                                fontWeight: FontWeight.w500),
                          ),
                          WidgetSpan(
                              child: SizedBox(
                            width: 5,
                          )),
                          TextSpan(
                            text: "¥${this.originalPrice!.toStringAsFixed(1)}",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Color(0xff898989),
                                fontSize: 11 * 2.sp,
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
              GestureDetector(
                      onTap: () {
                        if (UserManager.instance!.user.info!.id == 0) {
                          AppRouter.pushAndRemoveUntil(buildCtx!, RouteName.LOGIN);
                          Toast.showError('请先登录...');
                          return;
                        }
                        if (shareClick != null) {
                          shareClick!();
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
              Container(
                width: 5.rw,
              ),
              type != 4
                  ? GestureDetector(
                      child: CustomImageButton(
                        direction: Direction.horizontal,
                        height: 21,
                        //暂时隐藏
                        title: sellout ? "已售完" : "自购",

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
                  : GestureDetector(
                      child: CustomImageButton(
                        direction: Direction.horizontal,
                        height: 21,
                        title: '前往品牌馆',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.rsp,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: UserLevelTool.currentRoleLevelEnum() ==
                                        UserRoleLevel.Vip &&
                                    this.promotionStatus ==
                                        PromotionStatus.start
                                ? 32.rw
                                : 16.rw,
                            vertical: rSize(0)),
                        borderRadius: BorderRadius.circular(40),
                        backgroundColor: _shareTextColor,
                        pureDisplay: true,
                      ),
                      onTap: () {
                        if (onBrandClick != null) onBrandClick!();
                      },
                    ),
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
                                  "赚" +
                                      (this.commission ?? 0).toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(0),
                                    fontSize: 12 * 2.sp,
                                  ),
                                ),
                              ),
                              AppConfig.getShowCommission()!
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "赚" +
                                            (this.commission ?? 0)
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Color(0xffeb0045),
                                          fontSize: 12 * 2.sp,
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
                      fontSize: 12 * 2.sp,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future _shareEvent() async {
    String? imgUrl;
    GoodsDetailModel imagesModel = await GoodsDetailModelImpl.getDetailInfo(
        this.id as int?, UserManager.instance!.user.info!.id);
    if (imagesModel.data!.mainPhotos!.length >= 1) {
      imgUrl = imagesModel.data!.mainPhotos![0].url;
    } else {
      imgUrl = imagesModel.data?.mainPhotos?.first.url ?? '';
    }
    String goodsTitle =
        "￥${this.discountPrice} | ${this.goodsName} | ${this.description}";
    ShareTool().goodsShare(buildCtx,
        goodsPrice: this.discountPrice!.toStringAsFixed(2),
        goodsName: this.goodsName,
        goodsDescription: this.description,
        miniTitle: goodsTitle,
        miniPicurl: imgUrl,
        amount: this.commission.toString(),
        goodsId: this.id.toString());
  }

  _buyEvent() {

    if (buyClick != null) {
      buyClick!();
    } else {
      AppRouter.push(buildCtx!, RouteName.COMMODITY_PAGE,
          arguments:
              CommodityDetailPage.setArguments(this.id as int?,
                  ));
    }
  }

}
