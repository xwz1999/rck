import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';

import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/models/goods_hot_sell_list_model.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/models/promotion_goods_list_model.dart';

import 'package:recook/pages/goods/small_coupon_widget.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/pages/seckill_activity/model/SeckillModel.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';

import 'package:recook/models/goods_hot_sell_list_model.dart'
    as GoodsHotSellListModel;

enum GoodsItemType {
  NONE,
  NORMAL,
  HOT_LIST,
  ROW_GOODS,
  SECKILL,
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
  final SeckillModel seckillModel;
  final SecKill secKill;


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
    this.living, this.gifController, this.gysId, this.seckillModel, this.secKill,
    //this.special_sale,
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
    this.specialSale,
    this.type, this.gifController, this.seckillModel,

    //this.special_sale,
  })  : goodsName = model.goodsName,
        brandName = model.brandName,
        brandPictureUrl = model.brandImg,
        description = model.description,
        mainPhotoUrl = model.mainPhotoUrl,

        inventory = model.secKill.secKill==1? model.secKill.realStock:model.inventory,

        originalPrice = model.originalPrice,
        percent = model.percent,
        coupon = model.coupon,
        id = model.id,
        promotionStatus = model.getPromotionStatus(),
        widgetType = GoodsItemType.NORMAL,
        isImport = model.isImport,
        specialIcon = model.specialIcon,
        countryIcon = model.countryIcon,
        living = model.living,
        gysId = model.gysId,
        secKill = model.secKill,

        salesVolume = model.secKill.secKill==1? model.secKill.saleNum:model.salesVolume,
        discountPrice = model.secKill.secKill==1? model.secKill.secKillMinPrice:model.discountPrice,
        commission = model.secKill.secKill==1? model.secKill.secKillCommission:model.commission,
        //secKill = model.
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
    this.specialSale,
    this.specialIcon,
    this.type,
    this.living, this.gifController, this.seckillModel,
  })  : goodsName = data.goodsName,
        brandName = data.brandName,
        brandPictureUrl = data.brandImg,
        description = data.description,
        mainPhotoUrl = data.mainPhotoUrl,

        inventory = data.secKill.secKill==1? data.secKill.realStock:data.inventory,
        originalPrice = data.originalPrice,
        //TODO hot list unset percent;
        percent = 0,
        coupon = data.coupon,
        id = data.id,
        //TODO hot list unset promotion status;
        promotionStatus = PromotionStatus.none,
        widgetType = GoodsItemType.HOT_LIST,
        isImport = data.isImport,
        countryIcon = data.countryIcon,
        gysId = data.gysId,
        secKill = data.secKill,
        salesVolume = data.secKill.secKill==1? data.secKill.saleNum:data.salesVolume,
        discountPrice = data.secKill.secKill==1? data.secKill.secKillMinPrice:data.discountPrice,
        commission = data.secKill.secKill==1? data.secKill.secKillCommission:data.commission,
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
    this.type, this.gifController,  this.seckillModel,
  })  : goodsName = model.goodsName,
        brandName = model.brandName,
        brandPictureUrl = model.brandImg,
        description = model.description,
        mainPhotoUrl = model.picture.url,

        inventory = model.secKill.secKill==1? model.secKill.realStock:model.inventory,
        originalPrice = model.primePrice,

        percent = model.percentage,
        coupon = model.coupon,
        id = model.goodsId,
        promotionStatus = model.getPromotionStatus(),
        widgetType = GoodsItemType.ROW_GOODS,
        isImport = model.isImport,
        specialSale = model.specialSale,
        specialIcon = model.specialIcon,
        countryIcon = model.countryIcon,
        living = model.living,
        gysId = model.gysId,
        secKill = model.secKill,
        salesVolume = model.secKill.secKill==1? model.secKill.saleNum:model.totalSalesVolume,
        discountPrice = model.secKill.secKill==1? model.secKill.secKillMinPrice:model.price,
        commission = model.secKill.secKill==1? model.secKill.secKillCommission:model.commission,
        super(key: key);

  //秒杀活动
  GoodsItemWidget.seckillGoodsItem({
    Key key,
    this.isSingleDayGoods = false,
    this.buildCtx,
    this.shareClick,
    this.buyClick,
    this.onBrandClick,
    SeckillGoods model,
    SeckillModel seckillModel,
    this.notShowAmount = false,
    this.specialSale,

    this.type, this.gifController,this.originalPrice, this.percent, this.coupon,this.isImport, this.specialIcon, this.promotionStatus, this.living, this.gysId, this.secKill,
    //this.special_sale,
  })  : goodsName = model.goodsName,
        brandName = model.brandName,
        brandPictureUrl = model.brandUrl,
        description = model.subTitle,
        mainPhotoUrl = model.mainPhoto,
        discountPrice = model.minDiscountPrice,
        salesVolume = model.saleNum,
        id = model.goodsId,
        widgetType = GoodsItemType.SECKILL,
        countryIcon = model.countryUrl,
        inventory = model.inventory,
        commission = model.commission,
        seckillModel = seckillModel,

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
                      gysId==1800||gysId==2000?//jd的商品供应商 自营为1800 pop 为2000?
                      WidgetSpan(
                          child: Container(
                            padding: EdgeInsets.only(right: 5.rw),
                            child:
                            Container(
                              width: 20.rw,
                              height: 22.rw,
                              //padding: EdgeInsets.only(left: 1.rw),

                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFFC92219),
                                borderRadius: BorderRadius.all(Radius.circular(4.rw)),


                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  2.hb,
                                  Text(
                                    gysId==1800?'京东':gysId==2000?'京东':'',
                                    maxLines: 1,

                                    style: TextStyle(fontSize: 9.rsp,height:1.05),
                                  ),
                                  Text(
                                    gysId==1800?'自营':gysId==2000?'优选':'',
                                    maxLines: 1,

                                    style: TextStyle(fontSize: 9.rsp,height:1.05),
                                  )
                                ],
                              )
,
                            )
                         )
                      ): WidgetSpan(child: SizedBox()),
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
                    :Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 2),
                  child:
                  // gysId==1800||gysId==2000?//jd的商品供应商 自营为1800 pop 为2000
                  // Container(
                  //   width: 30.rw,
                  //   height: 14.rw,
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(
                  //       color: Color(0xFFC92219),
                  //       borderRadius: BorderRadius.all(Radius.circular(1.rw))
                  //
                  //   ),
                  //   child: Text(
                  //     gysId==1800?'自营':gysId==2000?'POP':'',
                  //     style: TextStyle(height: 1.1),
                  //   ),
                  // ):

                        Text(
                          this.description,
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

  // _addGestureDetectorForWidget(Widget widget, VoidCallback click) {
  //   return GestureDetector(
  //     child: widget,
  //     onTap: () {
  //       if (click != null) click();
  //     },
  //   );
  // }

  _image() {
    bool sellout = false;
    if(this.widgetType == GoodsItemType.SECKILL){
      if(this.salesVolume>=this.inventory){
        sellout = true;
      }else{
        sellout = false;
      }
    }else{
      if(this.inventory>0){
        sellout = false;
      }else{
        sellout = true;
      }
      if(this.secKill!=null){
        if(secKill.secKill==1){
          if(secKill.realStock>0){
            sellout = false;
          }else{
            sellout = true;
          }

          //秒杀中 通过seckill中的库存和销量来判断是否是否售完
        }
      }
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
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(8.rw)),
                      //     gradient: LinearGradient(
                      //       begin: Alignment.centerLeft,
                      //       end: Alignment.centerRight,
                      //       colors: [
                      //         Color(0xFFEC4073),
                      //         Color(0xFFE50043),
                      //       ],
                      //     )),
                      child: GifImage(
                        controller: gifController,
                        image: AssetImage(R.ASSETS_LIVE_PLAY_GIF),
                        height: 16.rw,
                        width: 16.rw,
                      )
                    ),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.rw)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.rw)),
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
    //暂时隐藏
    // bool seckillout = this.salesVolume>=this.inventory&&(this.widgetType == GoodsItemType.SECKILL);
    // bool sellout = this.inventory <= 0;
    bool sellout = false;
    bool isSeckill = false;
    if(this.widgetType == GoodsItemType.SECKILL){
      if(this.seckillModel!=null){
        if(seckillModel.status==2){
          isSeckill = true;//秒杀页面的商品 非秒杀状态（2）的情况下 正常显示
        }
        else{
          isSeckill = false;
        }
      }
      if(this.salesVolume>=this.inventory){
        sellout = true;
      }else{
        sellout = false;
      }
    }else{
      if(this.inventory>0){
        sellout = false;
      }else{
        sellout = true;
      }
      if(this.secKill!=null){
        if(secKill.secKill==1){
          isSeckill = true;
          if(secKill.realStock>0){
            sellout = false;
          }else{
            sellout = true;
          }
          //秒杀中 通过seckill中的库存和销量来判断是否是否售完
        }
      }
    }
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
                          text: isSeckill&&this.widgetType == GoodsItemType.SECKILL? "¥": isSeckill&&this.widgetType != GoodsItemType.SECKILL?'¥':"券后 ¥ ",
                          style: AppTextStyle.generate(isSeckill?18.rsp: 12 * 2.sp,
                              color: priceColor, fontWeight: FontWeight.w500),
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
                          text: this.widgetType == GoodsItemType.SECKILL?'':"¥${this.originalPrice.toStringAsFixed(0)}",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Color(0xff898989),
                              fontSize: 12 * 2.sp,
                              color: Color(0xff898989),
                              fontWeight: FontWeight.w400),
                        )
                      ])),

                      AppConfig.getShowCommission()&&(isSeckill)
                          ? Container(
                        alignment: Alignment.center,
                        child: Text(
                          "赚" +  (this.commission??0).toStringAsFixed(2),
                          style: TextStyle(
                            color: Color(0xFFC92219),
                            fontSize: 12 * 2.sp,
                          ),
                        ),
                      )
                          : SizedBox(),
                    ],
                  )

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
                //             fontSize: 12*2.sp,
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
              //           fontSize: 13*2.sp,
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
              type != 4
                  ? GestureDetector(
                      child: CustomImageButton(
                        direction: Direction.horizontal,
                        height: 21,
                        //暂时隐藏
                        title: sellout?"已售完" : "自购",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13 * 2.sp,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                UserLevelTool.currentRoleLevelEnum() ==
                                            UserRoleLevel.Vip &&
                                        this.promotionStatus ==
                                            PromotionStatus.start
                                    ? 16.rw
                                    : 8.rw,
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
                        //暂时隐藏
                            sellout? AppColor.greyColor : _shareTextColor,

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
                            horizontal:
                                UserLevelTool.currentRoleLevelEnum() ==
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
                        if (onBrandClick != null) onBrandClick();
                      },
                    ),
            ],
          )
        ],
      ),
    );
  }

  // _priceView() {
  //   if (promotionStatus == PromotionStatus.ready) {
  //     return Container();
  //   }
  //   return Row(
  //     children: <Widget>[
  //       _stockWidget(),
  //       Container(
  //         width: 10,
  //       ),
  //       Expanded(
  //         child: Text.rich(
  //           TextSpan(children: [
  //             TextSpan(
  //                 text: "已售",
  //                 style: TextStyle(color: Colors.black, fontSize: 11)),
  //             TextSpan(
  //                 text: "${(this.percent / 100.0).toStringAsFixed(0)}%",
  //                 style: TextStyle(color: Color(0xffec294d), fontSize: 11)),
  //           ]),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  _saleNumberWidget() {

    bool isSeckill = false;
    if(this.widgetType == GoodsItemType.SECKILL){
      if(this.seckillModel!=null){
        if(seckillModel.status==2){
          isSeckill = true;//秒杀页面的商品 非秒杀状态（2）的情况下 正常显示
        }
        else{
          isSeckill = false;
        }
      }

    }else{
      if(this.secKill!=null){
        if(secKill.secKill==1){
          isSeckill = true;
          //秒杀中 通过seckill中的库存和销量来判断是否是否售完
        }else{
          isSeckill = false;
        }
      }
    }
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              isSeckill?SizedBox():
              (this.coupon != null && this.coupon != 0)
                  ? Container(
                      margin: EdgeInsets.only(right: 5),
                      child: SmallCouponWidget(
                        height: 18,
                        number: this.coupon,
                      ),
                    )
                  : SizedBox(),
              isSeckill?
                  Container(
                    child: Image.asset(R.ASSETS_SECKILL_ICON_PNG,width: 69.rw,height: 20.rw,),
                  ):
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
                              "赚" + (this.commission??0).toStringAsFixed(2),
                              style: TextStyle(
                                color: Colors.white.withAlpha(0),
                                fontSize: 12 * 2.sp,
                              ),
                            ),
                          ),
                          AppConfig.getShowCommission()
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "赚" +  (this.commission??0).toStringAsFixed(2),
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

  // _stockWidget() {
  //   double height = 4;
  //   double allWidth = 120;
  //   double proportion = this.percent / 100.0;
  //   double width = allWidth * proportion < 4 && allWidth * proportion > 0
  //       ? 4
  //       : allWidth * proportion;
  //   return Container(
  //     width: allWidth,
  //     height: height,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(height)),
  //         // color: AppColor.pinkColor,
  //         color: Color(0xffdcdddd)),
  //     child: Stack(
  //       alignment: AlignmentDirectional.centerStart,
  //       children: <Widget>[
  //         Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(height)),
  //             color: AppColor.themeColor,
  //           ),
  //           width: width,
  //           height: height,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future _shareEvent() async {
    String imgUrl;
    GoodsDetailModel imagesModel = await GoodsDetailModelImpl.getDetailInfo(
        this.id, UserManager.instance.user.info.id);
    if (imagesModel.data.mainPhotos.length >= 1) {
      imgUrl = imagesModel.data.mainPhotos[0].url;
    } else {
      imgUrl = imagesModel.data?.mainPhotos?.first?.url ?? '';
    }
    String goodsTitle =
        "￥${this.discountPrice} | ${this.goodsName} | ${this.description}";
    ShareTool().goodsShare(buildCtx,
        goodsPrice: this.discountPrice.toStringAsFixed(2),
        goodsName: this.goodsName,
        goodsDescription: this.description,
        miniTitle: goodsTitle,
        miniPicurl: imgUrl,
        amount: this.commission.toString(),
        goodsId: this.id.toString());
  }

  _buyEvent() {
    bool sellout = false;
    if(this.widgetType == GoodsItemType.SECKILL){
      if(this.salesVolume>=this.inventory){
        sellout = true;
      }else{
        sellout = false;
      }
    }else{
      if(this.inventory>0){
        sellout = false;
      }else{
        sellout = true;
      }
      if(this.secKill!=null){
        if(secKill.secKill==1){
          if(secKill.realStock>0){
            sellout = false;
          }else{
            sellout = true;
          }
          //秒杀中 通过seckill中的库存和销量来判断是否是否售完
        }
      }
    }
    if (buyClick != null) {
      buyClick();
    } else {
      AppRouter.push(buildCtx, RouteName.COMMODITY_PAGE,
          arguments: CommodityDetailPage.setArguments(
            this.id,

            seckillout:sellout
            // liveStatus: living == null ? null : living.status,
            // roomId: living == null ? null : living.roomId
          ));
    }
  }

  // _getLivingStatus(int status) {
  //   if (status == 1) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}

