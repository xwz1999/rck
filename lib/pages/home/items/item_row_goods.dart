/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-01  15:04 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/promotion_goods_list_model.dart';
import 'package:jingyaoyun/pages/goods/small_coupon_widget.dart';
import 'package:jingyaoyun/pages/home/promotion_time_tool.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_cache_image.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class RowGoodsItem extends StatelessWidget {
  final PromotionGoodsModel model;
  final VoidCallback shareClick;
  final VoidCallback buyClick;

  const RowGoodsItem({Key key, this.model, this.shareClick, this.buyClick})
      : super(key: key);

  static Color _shareTextColor = Color(0xffc70404);

  static double _height = 0;

  @override
  Widget build(BuildContext context) {
    _height = (MediaQuery.of(context).size.width - 20) * 140.0 / 350.0;
    return Container(
      height: _height,
      padding: EdgeInsets.only(bottom: 3.33, left: 10, right: 10),
      color: AppColor.frenchColor,
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
              buyClick();
            },
          ),
          GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _addGestureDetectorForWidget(_image(), buyClick),
                _rowInfoWidget(),
              ],
            ),
            onTap: () {
              buyClick();
            },
          ),
        ],
      ),
    );
  }

  _rowInfoWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 2,
                  ),
                  Text(
                    model.goodsName,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.generate(15 * 2.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      // margin: EdgeInsets.only(top: 7),
                      child: model.description == null
                          ? Container()
                          : Text(
                              model.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.generate(12 * 2.sp,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300),
                            ),
                    ),
                  )
                ],
              ),
            ),
            // _priceView(),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: _saleNumberWidget(),
                  ),
                  // Container(height: 10),
                  _inventoryView(),
                  // Container(height: 2,),
                ],
              ),
            )
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
              imageUrl: Api.getImgUrl(model.picture.url),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Offstage(
              offstage: model.inventory > 0,
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
          )
        ]),
      ),
    );
  }

  _inventoryView() {
    bool sellout = model.inventory <= 0;
    Color priceColor = Color(0xffc70404);
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("券",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: priceColor,
                          fontSize: 5 * 2.sp)),
                  Text("后",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: priceColor,
                          fontSize: 5 * 2.sp)),
                ],
              ),
              Container(
                width: 1,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "¥",
                  style: AppTextStyle.generate(11 * 2.sp,
                      color: priceColor, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text:
                      "${(model.price - model.price.toInt()) > 0 ? model.price.toStringAsFixed(1) : model.price.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: 15 * 2.sp,
                      color: priceColor,
                      fontWeight: FontWeight.w500),
                ),
              ])),
              Container(
                width: 3,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "¥",
                  style: AppTextStyle.generate(9 * 2.sp,
                      color: Color(0xff898989), fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: "${model.primePrice.toStringAsFixed(0)}",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Color(0xff898989),
                      fontSize: 13 * 2.sp,
                      color: Color(0xff898989),
                      fontWeight: FontWeight.w500),
                ),
              ])),
              Expanded(child: Container()),
            ],
          ),
          Row(
            children: <Widget>[
              Spacer(),
              UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
                  ? Container()
                  :
                  // model.getPromotionStatus() == PromotionStatus.ready ?
                  //   GestureDetector(
                  //     onTap: (){
                  //       if (shareClick != null) shareClick();
                  //     },
                  //     child: Container(
                  //       margin: EdgeInsets.only(right: 5),
                  //       child: Image.asset("assets/home_page_row_share_icon.png", width: 18, height: 18,),
                  //     ),
                  //   ):
                  GestureDetector(
                      child: CustomImageButton(
                        height: 21,
                        title: "导购",
                        style: TextStyle(
                            fontSize: 13,
                            color: sellout ? Colors.grey : _shareTextColor),
                        padding: EdgeInsets.symmetric(
                            horizontal: rSize(8), vertical: rSize(0)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40)),
                        border: Border.all(
                            color: sellout ? Colors.grey : _shareTextColor,
                            width: 0.5),
                        pureDisplay: true,
                      ),
                      onTap: () {
                        if (shareClick != null) shareClick();
                      },
                    ),
              Container(
                width: 5,
              ),
              GestureDetector(
                child: CustomImageButton(
                  height: 21,
                  title: sellout ? "已售完" : "自购",
                  // title: model.getPromotionStatus() == PromotionStatus.ready ? '即将开始' : sellout ? "已售完" : "自购",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenAdapterUtils.setWidth(
                          UserLevelTool.currentRoleLevelEnum() ==
                                  UserRoleLevel.Vip
                              ? 16
                              : 8),
                      vertical: rSize(0)),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          UserLevelTool.currentRoleLevelEnum() ==
                                  UserRoleLevel.Vip
                              ? 40
                              : 0),
                      bottomLeft: Radius.circular(
                          UserLevelTool.currentRoleLevelEnum() ==
                                  UserRoleLevel.Vip
                              ? 40
                              : 0),
                      topRight: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  backgroundColor:
                      sellout ? AppColor.greyColor : _shareTextColor,
                  pureDisplay: true,
                ),
                onTap: () {
                  if (buyClick != null) buyClick();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _priceView() {
    if (model.getPromotionStatus() == PromotionStatus.ready) {
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
                  text: "${(model.percentage * 100).toStringAsFixed(0)}%",
                  style: TextStyle(color: Color(0xffec294d), fontSize: 11)),
            ]),
          ),
        ),
      ],
    );
  }

  _saleNumberWidget() {
    return Container(
        child: Row(
      children: <Widget>[
        (model.coupon != null && model.coupon != 0)
            ? Container(
                margin: EdgeInsets.only(right: 10),
                child: SmallCouponWidget(
                  height: 35,
                  number: model.coupon,
                ),
              )
            : SizedBox(),
        !AppConfig.getShowCommission()
            ? Container()
            : Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Color(0xffec294d),
                      width: 0.5,
                    )),
                height: 18,
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  "赚${model.commission.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Color(0xffeb0045),
                    fontSize: 11,
                  ),
                ),
              ),
        Spacer(),
        Text(
          model.salesVolumeDesc,
          style: TextStyle(
            color: Color(0xff595757),
            fontSize: 10,
          ),
        ),
      ],
    ));
  }

  _stockWidget() {
    double height = 4;
    double allWidth = 120;
    double proportion = model.percentage;
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
}
