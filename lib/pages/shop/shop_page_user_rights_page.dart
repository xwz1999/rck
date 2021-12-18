import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/webView.dart';

class ShopPageUserRightsPage extends StatefulWidget {
  ShopPageUserRightsPage({Key key}) : super(key: key);

  @override
  _ShopPageUserRightsPageState createState() => _ShopPageUserRightsPageState();
}

class _ShopPageUserRightsPageState
    extends BaseStoreState<ShopPageUserRightsPage> {
  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.tableViewGrayColor,
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  child: _contextWidget(),
                                )
                              ],
                            ),
                            Positioned(
                              top: 40.rw + ScreenUtil().statusBarHeight,
                              left: 0,
                              child: _userInfo(),
                              //child: Image.asset("assets/shop_page_user_rights_bg.png", width: width, height: bgHeight, fit: BoxFit.fill, ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: _appBar("左家右厨8大权益"),
                              //child: Image.asset("assets/shop_page_user_rights_bg.png", width: width, height: bgHeight, fit: BoxFit.fill, ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _userInfo() {
    String nickname = UserManager.instance.user.info.nickname;
    if (TextUtils.isEmpty(nickname, whiteSpace: true)) {
      String mobile = UserManager.instance.user.info.mobile;
      nickname = "用户${mobile.substring(mobile.length - 4)}";
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomCacheImage(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              fit: BoxFit.cover,
              width: 60,
              height: 60,
              imageUrl: TextUtils.isEmpty(
                      UserManager.instance.user.info.headImgUrl)
                  ? ""
                  : Api.getImgUrl(UserManager.instance.user.info.headImgUrl),
            ),
            Container(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      nickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.generate(18 * 2.sp,
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  _roleLevelWidget()
                ],
              ),
            )
          ],
        ));
  }

  _roleLevelWidget({String level}) {
    return CustomImageButton(
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      backgroundColor: Colors.white,
      fontSize: 7 * 2.sp,
      color: Colors.black,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      direction: Direction.horizontal,
      contentSpacing: 2,
      icon: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.modulate),
        child: Image.asset(
          UserLevelTool.currentUserLevelIcon(),
          width: 13,
          height: 13,
        ),
      ),
      title:
          TextUtils.isEmpty(level) ? UserLevelTool.currentRoleLevel() : level,
    );
  }

  _appBar(title) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
      width: MediaQuery.of(context).size.width,
      height: 40.rw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 60,
            child: IconButton(
                icon: Icon(
                  AppIcons.icon_back,
                  size: 17,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.maybePop(context);
                }),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(fontSize: rSize(18)),
              ),
            ),
          ),
          Container(
            width: 60,
          )
        ],
      ),
    );
  }

  _masterLevel23() {
    return Container(
      child: Image.asset(
        R.ASSETS_SHOP_PAGE_USER_RIGHTS_MASTER_JPG,
        fit: BoxFit.fill,
      ),
    );
  }

  _masterLevel4() {
    return Container(
      child: Image.asset(
        R.ASSETS_SHOP_PAGE_USER_RIGHTS_MASTER_JPG,
        fit: BoxFit.fill,
      ),
    );
  }

  _vip23() {
    return Container(
      child: Image.asset(
        R.ASSETS_SHOP_PAGE_USER_RIGHTS_VIP_JPG,
        fit: BoxFit.fill,
      ),
    );
  }

  _vip4() {
    return Container(
      child: Image.asset(
        R.ASSETS_SHOP_PAGE_USER_RIGHTS_VIP_JPG,
        fit: BoxFit.fill,
      ),
    );
  }

  _silver() {
    return Container(
      child: Image.asset(
        R.ASSETS_SHOP_PAGE_USER_RIGHTS_SILVER_JPG,
        fit: BoxFit.fill,
      ),
    );
  }

  _gold() {
    return Container(
      child: Image.asset(
        R.ASSETS_SHOP_PAGE_USER_RIGHTS_GOLD_JPG,
        fit: BoxFit.fill,
      ),
    );
  }

  _diamond() {
    return Container(
      child: Image.asset(
        R.ASSETS_SHOP_PAGE_USER_RIGHTS_DIAMOND_JPG,
        fit: BoxFit.fill,
      ),
    );
  }

  // _roleButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       AppRouter.push(
  //         context,
  //         RouteName.WEB_VIEW_PAGE,
  //         arguments: WebViewPage.setArguments(
  //             appBarTheme: AppThemes.themeDataGrey.appBarTheme,
  //             url:
  //                 "https://cdn.reecook.cn/website/www/rule/${_webViewUrl()}.html",
  //             title: "规则",
  //             hideBar: false),
  //       );
  //     },
  //     child: Container(
  //       width: 57,
  //       height: 61,
  //       child: Image.asset("assets/shop_page_user_rights_role_button.png",
  //           fit: BoxFit.fill),
  //     ),
  //   );
  // }

  _webViewUrl() {
    if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_1 &&
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_2 &&
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_3) {
      return "r1";
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Gold) {
      return "r2";
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Silver) {
      return "r3";
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip &&
        (UserLevelTool.currentUserLevelEnum() == UserLevel.Second ||
            UserLevelTool.currentUserLevelEnum() == UserLevel.First)) {
      return "r6";
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip &&
        (UserLevelTool.currentUserLevelEnum() == UserLevel.Others)) {
      return "r7";
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Master &&
        (UserLevelTool.currentUserLevelEnum() == UserLevel.Others)) {
      return "r5";
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Master &&
        ((UserLevelTool.currentUserLevelEnum() == UserLevel.Second ||
            UserLevelTool.currentUserLevelEnum() == UserLevel.First))) {
      return "r4";
    }
    return "r7";
  }

  _contextWidget() {
    if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_1 ||
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_2 ||
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_3) {
      return _diamond();
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Gold) {
      return _gold();
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Silver) {
      return _silver();
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip &&
        (UserLevelTool.currentUserLevelEnum() == UserLevel.Second ||
            UserLevelTool.currentUserLevelEnum() == UserLevel.First)) {
      return _vip23();
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip &&
        (UserLevelTool.currentUserLevelEnum() == UserLevel.Others)) {
      // 绿色的vip
      return _vip4();
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Master &&
        (UserLevelTool.currentUserLevelEnum() == UserLevel.Others)) {
      return _masterLevel4();
    } else if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Master &&
        ((UserLevelTool.currentUserLevelEnum() == UserLevel.Second ||
            UserLevelTool.currentUserLevelEnum() == UserLevel.First))) {
      return _masterLevel23();
    }
    return Container();
  }
}
