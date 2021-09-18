/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/3  1:49 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/manager/meiqia_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/seckill_activity/model/SeckillModel.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/goods_item.dart';

typedef VoidListener = Function();
typedef FavoriteListener = Function(bool favorite);

class DetailBottomBar extends StatefulWidget {
  DetailBottomBar({
    this.addToShopCartListener,
    this.collectListener,
    this.buyListener,
    this.shareListener,
    this.collected = true,
    this.shopCartNum = "",
    this.controller,
    this.goodsDetail,
    this.isLive = false,
    this.liveId = 0, this.seckillout,
  });

  final VoidListener addToShopCartListener;
  final FavoriteListener collectListener;
  final VoidListener buyListener;
  final VoidListener shareListener;
  final bool collected;
  final String shopCartNum;
  final BottomBarController controller;
  // final String commission;
  final GoodsDetailModel goodsDetail;

  final bool isLive;
  final int liveId;
  final bool seckillout;

  @override
  State<StatefulWidget> createState() {
    return _DetailBottomBarState();
  }
}

class _DetailBottomBarState extends State<DetailBottomBar> {
  bool _collected;
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    _collected = widget.collected;

    widget.controller.hidden?.addListener(() {
      if (widget.controller.bottomBarHidden == _hidden) {
        return;
      }
      _hidden = widget.controller.bottomBarHidden;
      setState(() {});
    });

    widget.controller.favorite.addListener(() {
      _collected = widget.controller.favorite.value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("改变了");
    return AnimatedOpacity(
      // If the Widget should be visible, animate to 1.0 (fully visible). If
      // the Widget should be hidden, animate to 0.0 (invisible).
      opacity: !widget.controller.bottomBarHidden ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      // The green box needs to be the child of the AnimatedOpacity
      child: Offstage(
        offstage: widget.controller.bottomBarHidden,
        child: _bottomBar(),
      ),
    );
    // return Offstage(
    //   offstage: widget.controller.bottomBarHidden,
    //   child: _bottomBar(),
    // );
  }

  _bottomBar() {
    SafeArea safeArea = SafeArea(
      bottom: true,
      top: false,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey[300], width: 0.3),
              // bottom: BorderSide(color: Colors.grey[300], width: 0.3)
            )),
        child: Row(
          children: <Widget>[
            Container(
              width: 5,
            ),
            CustomImageButton(
              dotSize: 13,
              dotFontSize: 10,
              dotPosition: DotPosition(right: rSize(0), top: 0),
              dotNum: widget.shopCartNum,
              dotColor: AppColor.themeColor,
              padding: EdgeInsets.symmetric(horizontal: 6),
              title: "购物车",
              contentSpacing: 0,
              icon: Icon(
                AppIcons.icon_shopcart,
                size: rSize(30),
              ),
              fontSize: 10,
              onPressed: widget.addToShopCartListener,
            ),
            CustomImageButton(
              title: "收藏",
              padding: EdgeInsets.only(left: 6, top: 5, right: 5),
              contentSpacing: 3,
              icon: Icon(
                _collected
                    ? AppIcons.icon_favorite_selected
                    : AppIcons.icon_favorite,
                color: _collected ? Colors.red : Colors.grey[900],
                size: rSize(22),
              ),
              fontSize: 10,
              onPressed: () {
                widget.collectListener(!_collected);
              },
            ),
            //1.10x新增客服按钮
            CustomImageButton(
              title: "客服",
              padding: EdgeInsets.only(left: 5, bottom: 2, right: 5),
              contentSpacing: 0,
              icon: Icon(
                AppIcons.icon_message,
                size: rSize(30),
              ),
              fontSize: 10,
              onPressed: () {
                MQManager.goToChat(
                  userId: UserManager.instance.user.info.id.toString(),
                  userInfo: <String, String>{
                    "name": UserManager.instance.user.info.nickname ?? "",
                    "gender": UserManager.instance.user.info.gender == 1
                        ? "男"
                        : "女",
                    "mobile": UserManager.instance.user.info.mobile ?? ""

                  },
                  goodsName: widget.goodsDetail.data.goodsName??"",
                  goodsUrl: Api.getImgUrl(widget.goodsDetail.data.mainPhotos.first.url),
                  );

              },
            ),

            Container(
              width: 10,
            ),
            widget.seckillout?_oneButtonRow():
            widget.goodsDetail == null || widget.goodsDetail.data.inventory > 0
                ? AppConfig.getShowCommission()
                    ? _twoButtonRow()
                    : _vipTwoButtonRow()
                : _oneButtonRow(),
            Container(
              width: 10,
            ),
          ],
        ),
      ),
    );

    return safeArea;
  }

  _oneButtonRow() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          CustomImageButton(
            height: rSize(40),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            backgroundColor: AppColor.pinkColor,
            fontSize: 15 * 2.sp,
            onPressed: () {},
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: GestureDetector(
                // onTap: widget.shareListener,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "抱歉!当前商品已售罄",
                  style: TextStyle(
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w300,
                      fontSize: 13 * 2.sp,
                      color: Colors.black),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  _vipTwoButtonRow() {
    String commission = widget.goodsDetail == null
        ? null
        : widget.goodsDetail.data.price.min.commission.toStringAsFixed(2);
    return Expanded(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/goodsdetail_bottom_bar_red.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  right: 0,
                  left: 0,
                  top: (55 - rSize(40)) / 2,
                  bottom: (55 - rSize(40)) / 2,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: widget.buyListener,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/goodsdetail_bottom_share_white.png',
                              width: rSize(13),
                              height: 13 * 2.h,
                            ),
                            Container(
                              width: 2,
                            ),
                            Text(
                              "领券购买",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14 * 2.sp,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        TextUtils.isEmpty(commission) ||
                                UserLevelTool.currentRoleLevelEnum() ==
                                    UserRoleLevel.Vip
                            ? Container(
                                height: 0,
                              )
                            : Text(
                                "省￥" + commission,
                                style: TextStyle(
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 9 * 2.sp,
                                    color: Colors.white),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _twoButtonRow() {
    String commission = '';
    if(widget.goodsDetail != null){
      commission = widget.goodsDetail == null
          ? null
          : widget.goodsDetail.data.price.min.commission.toStringAsFixed(2);
      if(widget.goodsDetail.data.seckill!=null){
        if( widget.goodsDetail.data.seckill.seckill_status==1){
          commission = widget.goodsDetail.data.seckill.seckillCommission.toStringAsFixed(2);
        }

      }

    }



    return Expanded(
      child: Row(
        children: <Widget>[
          Platform.isAndroid ||
                  !(UserLevelTool.currentRoleLevelEnum() ==
                          UserRoleLevel.None &&
                      UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip)
              ? Expanded(
                  child: Stack(
                  children: <Widget>[
                    CustomImageButton(
                      padding: EdgeInsets.all(0),
                      child: ClipRRect(
                        child: Image.asset(
                            'assets/goodsdetail_bottom_bar_grey.png'),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                      ),
                      height: rSize(40),
                      fontSize: 15 * 2.sp,
                      onPressed: widget.shareListener,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: GestureDetector(
                          onTap: widget.shareListener,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/goodsdetail_bottom_share_red.png',
                                    width: rSize(13),
                                    height: 13 * 2.h,
                                  ),
                                  Container(
                                    width: 2,
                                  ),
                                  Text(
                                    UserLevelTool.currentRoleLevelEnum() ==
                                                UserRoleLevel.Vip ||
                                            UserLevelTool
                                                        .currentRoleLevelEnum() ==
                                                    UserRoleLevel.None &&
                                                !AppConfig.showExtraCommission
                                        ? "邀请升级"
                                        : "导购",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14 * 2.sp,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              UserLevelTool.currentRoleLevelEnum() ==
                                          UserRoleLevel.Vip ||
                                      UserLevelTool.currentRoleLevelEnum() ==
                                          UserRoleLevel.None ||
                                      TextUtils.isEmpty(commission)
                                  ? Container(
                                      height: 0,
                                    )
                                  : Text(
                                      "赚￥" + commission,
                                      style: TextStyle(
                                          letterSpacing: -0.5,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 9 * 2.sp,
                                          color: Colors.white),
                                    ),
                            ],
                          )),
                    ),
                  ],
                ))
              : SizedBox(),
          Container(
            width: 1,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: CustomImageButton(
                    padding: EdgeInsets.all(0),
                    child: ClipRRect(
                      child: Image.asset(
                          'assets/goodsdetail_bottom_bar_red.png',
                          fit: BoxFit.cover,
                          width: double.infinity),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(30),
                        left: Platform.isAndroid ||
                                !(UserLevelTool.currentRoleLevelEnum() ==
                                        UserRoleLevel.None &&
                                    UserLevelTool.currentRoleLevelEnum() ==
                                        UserRoleLevel.Vip)
                            ? Radius.zero
                            : Radius.circular(30),
                      ),
                    ),
                    width: double.infinity,
                    height: rSize(40),
                    fontSize: 15 * 2.sp,
                    onPressed: widget.buyListener,
                  ),
                  right: 0,
                  left: 0,
                  top: (55 - rSize(40)) / 2,
                  bottom: (55 - rSize(40)) / 2,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: widget.buyListener,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/goodsdetail_bottom_share_white.png',
                              width: rSize(13),
                              height: 13 * 2.h,
                            ),
                            Container(
                              width: 2,
                            ),
                            Text(
                              "领券购买",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14 * 2.sp,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        TextUtils.isEmpty(commission) ||
                                UserLevelTool.currentRoleLevelEnum() ==
                                    UserRoleLevel.Vip
                            ? Container(
                                height: 0,
                              )
                            : Text(
                                "省￥" + commission,
                                style: TextStyle(
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 9 * 2.sp,
                                    color: Colors.white),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBarController {
  ValueNotifier<bool> hidden = ValueNotifier(false);
  ValueNotifier<bool> favorite = ValueNotifier(false);

  get bottomBarHidden => hidden?.value;

  setFavorite(bool isFavorite) {
    favorite.value = isFavorite;
  }

  void dispose() {
    hidden?.dispose();
    favorite?.dispose();
  }
}
