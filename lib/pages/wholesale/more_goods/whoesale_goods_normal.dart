import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/goods_hot_sell_list_model.dart';
import 'package:jingyaoyun/models/goods_hot_sell_list_model.dart'
as GoodsHotSellListModel;
import 'package:jingyaoyun/pages/wholesale/models/wholesale_good_model.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

import '../wholeasale_detail_page.dart';


class WholesaleGoodsItem extends StatelessWidget {

  final String goodsName;
  final String description;
  final String mainPhotoUrl;
  final num inventory;
  final num discountPrice;
  final num originalPrice;
  // final num percent;
  final num coupon;
  final num commission;
  final num salesVolume;
  final num id;
  final BuildContext buildCtx;


  const WholesaleGoodsItem({
    Key key,
    this.goodsName,
    this.description,
    this.mainPhotoUrl,
    this.inventory,
    this.discountPrice,
    this.originalPrice,
    // this.percent,
    this.coupon,
    this.commission,
    this.salesVolume,
    this.id,
    this.buildCtx,

  }) :super(key: key);


  static Color _shareTextColor = Color(0xffc70404);
  static double _height = 0;


  WholesaleGoodsItem.normalGoodsItem({
    Key key,
    WholesaleGood model, this.buildCtx,

    //this.special_sale,
  })  : goodsName = model.goodsName,

        description = model.description,
        mainPhotoUrl = model.mainPhotoUrl,
        inventory = model.inventory,
        originalPrice = model.discountPrice,
        // percent = model.percent,
        coupon = model.coupon,
        id = model.id,
        salesVolume =  model.salesVolume,
        discountPrice =  model.salePrice,
        commission =  model.commission,
        super(key: key);



  WholesaleGoodsItem.hotList({
    Key key,
    this.buildCtx,


    GoodsHotSellListModel.Data data,


  })  : goodsName = data.goodsName,

        description = data.description,
        mainPhotoUrl = data.mainPhotoUrl,
        inventory =  data.inventory,
        originalPrice = data.discountPrice,

        coupon = data.coupon,
        id = data.id,
        salesVolume = data.salesVolume,
        discountPrice = data.salePrice,
        commission =  data.commission,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _height = 140.rw;

    return Container(
      height: _height,
      padding: EdgeInsets.only(top: 8.rw, left: 8.rw, right: 8.rw),
      color: Colors.transparent,
      child: _container(),
    );
  }

  _container() {
    return Container(

      height: _height,
      padding: EdgeInsets.all(7.rw),
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

  _rowInfoWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 7.rw),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _saleNumberWidget(),
                10.hb,
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
                            text:  "批发价 ¥ ",
                            style: AppTextStyle.generate(
                                12 * 2.sp,
                                color: priceColor,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text:
                            "${this.discountPrice.toStringAsFixed(2)}",
                            // text: "${model.discountPrice>=100?model.discountPrice.toStringAsFixed(0):model.discountPrice.toStringAsFixed(1)}",
                            style: TextStyle(
                                letterSpacing: -1,
                                wordSpacing: -1,
                                fontSize: 16 * 2.sp,
                                color: priceColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ])),
                      ],
                    )),

              ],
            ),
          ),
          Row(
            children: <Widget>[
              Spacer(),
              Container(
                width: 10,
              ),
             CustomImageButton(
               direction: Direction.horizontal,
               height: 21,
               //暂时隐藏
               title: sellout ? "已售完" : "批发",

               style: TextStyle(
                 color: Colors.white,
                 fontSize: 13 * 2.sp,
               ),
               padding: EdgeInsets.symmetric(
                   horizontal:  8.rw,
                   vertical: rSize(0)),
               borderRadius: BorderRadius.circular(40),
               backgroundColor:
               //暂时隐藏
               sellout ? AppColor.greyColor : _shareTextColor,

               pureDisplay: true,
             )
            ],
          )
        ],
      ),
    );
  }

  _saleNumberWidget() {
    return Row(

      children: [
        Container(
          child: Text(
            '零售价¥${this.originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 12 * 2.sp,
                color: Color(0xFF999999),
                fontWeight: FontWeight.w400),
          )
        ),
        Spacer(),
        Container(
          child: Text(
                  "已订${this.salesVolume}件",
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12 * 2.sp,
                  ),
                ),

        ),
      ],
    );
  }

  _buyEvent() {
    Get.to(()=>WholesaleDetailPage(goodsId: this.id,));
  }


}
