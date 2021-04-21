/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/5  10:02 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/promotion_goods_list_model.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';

class ColumnGoodsItem extends StatelessWidget {
  final PromotionGoodsModel model;
  final VoidCallback shareClick;
  final VoidCallback buyClick;

  const ColumnGoodsItem({Key key, this.model, this.shareClick, this.buyClick})
      : super(key: key);
  static Color _shareTextColor = Color.fromARGB(255, 224, 27, 27);
  @override
  Widget build(BuildContext context) {
    return _buildContainer();
  }

  Container _buildContainer() {
    return Container(
      padding: EdgeInsets.only(bottom: rSize(2)),
      margin: EdgeInsets.symmetric(horizontal: rSize(10), vertical: rSize(6)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.18)),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(rSize(10)))),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              color: Colors.white,
            ),
            onTap: () {
              buyClick();
            },
          ),
          GestureDetector(
            onTap: () {
              buyClick();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _addGestureDetectorForWidget(_img(), buyClick),
                Container(
                  height: 4,
                ),
                _title(),
                _des(),
                Container(
                  height: 0,
                ),
                _price(),
                Container(
                  height: 2,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _title() {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 1),
      // margin: EdgeInsets.symmetric(
      //     vertical: rSize(5),
      //     horizontal: rSize(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              model.goodsName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14 * 2.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ),
          Container(
            width: 10,
          ),
          _priceView(),
        ],
      ),
      // child: Text(
      //   model.title,
      //   maxLines: 1,
      //   overflow: TextOverflow.ellipsis,
      //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
      // ),
    );
  }

  Container _des() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            model.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.generate(13,
                color: Colors.grey[600], fontWeight: FontWeight.w400),
          )),
          // Text(
          //   "库存 ${model.inventory}",
          //   style: AppTextStyle.generate(13,
          //       color: Colors.grey[600], fontWeight: FontWeight.w300),
          // ),
          Container(
            width: 4,
          ),
        ],
      ),
    );
  }

  _stockWidget() {
    if (model.getPromotionStatus() == PromotionStatus.ready) {
      return Container(
        width: 150,
        height: 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          color: AppColor.greenColor,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            model.totalInventoryDesc,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10 * 2.sp,
            ),
          ),
        ),
      );
    }
    double proportion = model.percentage;
    double width =
        150 * proportion < 14 && 150 * proportion > 0 ? 14 : 150 * proportion;
    return Container(
      width: 150,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        color: AppColor.pinkColor,
      ),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: AppColor.themeColor,
            ),
            width: width,
            height: 14,
          ),
          _stockInfoWidget(proportion),
        ],
      ),
    );
  }

  _stockInfoWidget(double proportion) {
    if (0.9 < proportion && proportion < 1) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          model.salesVolumeDesc,
          style: TextStyle(
            color: Colors.white,
            fontSize: 9 * 2.sp,
          ),
        ),
      );
    } else if (proportion == 1) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          model.salesVolumeDesc,
          style: TextStyle(
            color: Colors.white,
            fontSize: 9 * 2.sp,
          ),
        ),
      );
    } else {
      return Row(
        children: <Widget>[
          Text(
            '   ' + model.salesVolumeDesc,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9 * 2.sp,
            ),
          ),
          Spacer(),
          Text(
            model.percentageDesc + '   ',
            style: TextStyle(
              color: proportion > 0.7 ? Colors.white : AppColor.themeColor,
              fontSize: 9 * 2.sp,
            ),
          ),
        ],
      );
    }
  }

  Container _price() {
    bool sellout = model.inventory <= 0;
    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(5), horizontal: rSize(5)),
      child: Row(
        children: <Widget>[
          // _priceView(),
          _stockWidget(),
          Expanded(child: Container()),
          UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip
              ? Container()
              : GestureDetector(
                  child: CustomImageButton(
                    title: "分享得",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:
                            model.getPromotionStatus() == PromotionStatus.ready
                                ? AppColor.greenColor
                                : sellout
                                    ? Colors.grey
                                    : _shareTextColor),
                    pureDisplay: true,
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                        color:
                            model.getPromotionStatus() == PromotionStatus.ready
                                ? AppColor.greenColor
                                : sellout
                                    ? Colors.grey
                                    : _shareTextColor,
                        width: 0.5),
                  ),
                  onTap: () {
                    if (shareClick != null) shareClick();
                  },
                ),
          Container(
            width: 10,
          ),
          GestureDetector(
            child: CustomImageButton(
              title: model.getPromotionStatus() == PromotionStatus.ready
                  ? '未开始'
                  : sellout
                      ? "已抢完"
                      : "省钱购",
              color: Colors.white,
              pureDisplay: true,
              backgroundColor:
                  model.getPromotionStatus() == PromotionStatus.ready
                      ? AppColor.greenColor
                      : sellout
                          ? AppColor.pinkColor
                          : AppColor.themeColor,
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            onTap: () {
              if (buyClick != null) buyClick();
            },
          ),
          Container(
            width: 4,
          ),
        ],
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

  _img() {
    double cir = rSize(8);
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cir), topRight: Radius.circular(cir)),
        // borderRadius:
        //     BorderRadius.all(Radius.circular(rSize(8))),
        child: Stack(children: [
          AspectRatio(
            aspectRatio: 2.5,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(rSize(10))),
              child: CustomCacheImage(
                  fit: BoxFit.cover,
                  imageUrl: Api.getResizeImgUrl(
                      model.picture.url, DeviceInfo.screenWidth.toInt() * 2)),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Offstage(
              // offstage: model.inventory > 0,
              offstage: model.inventory > 0,
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Image.asset(
                    'assets/sellout_bg.png',
                    width: rSize(100),
                    height: rSize(100),
                  ),
                ),
              ),
            ),
          )
        ]));
  }

  _priceView() {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: "${model.priceDesc}",
        style: AppTextStyle.generate(15 * 2.sp, fontWeight: FontWeight.w400),
      ),
      TextSpan(
        text: AppConfig.showCommission ? "  " : "",
        style: AppTextStyle.generate(14 * 2.sp),
      ),
      TextSpan(
        text: AppConfig.showCommission ? model.commissionDesc : "",
        style: AppTextStyle.generate(13 * 2.sp,
            fontWeight: FontWeight.w400, color: AppColor.themeColor),
      ),
    ]));
  }
}

// class ColumnGoodsModel {
//   final int isProcessing; // == 0 即将开始  == 1 抢购中 ==2 已结束
//   final int salesVolume; //销量
//   final String imgUrl;
//   final String title;
//   final String des;
//   final double price;
//   final double commission;
//   final int inventory;

//   ColumnGoodsModel({
//     @required this.isProcessing,
//     @required this.salesVolume,
//     @required this.imgUrl,
//     @required this.title,
//     @required this.des,
//     @required this.price,
//     @required this.commission,
//     @required this.inventory});
// }
