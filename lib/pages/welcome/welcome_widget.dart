/*
 * ====================================================
 * package   : pages.welcome
 * author    : Created by nansi.
 * time      : 2019/5/5  4:47 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/pages/tabBar/TabbarWidget.dart';
import 'package:package_info/package_info.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/app_image_resources.dart';
import 'package:jingyaoyun/constants/config.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/daos/user_dao.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/user_model.dart';
import 'package:jingyaoyun/utils/print_util.dart';
import 'package:jingyaoyun/utils/share_preference.dart';
import 'package:jingyaoyun/utils/storage/hive_store.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class WelcomeWidget extends StatefulWidget {
  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends BaseStoreState<WelcomeWidget> {
  String debugLable = 'Unknown';
  String _backgroundUrl;
  bool _close = false;
  int _countDownNum = 3;
  int _goodsId = 0;
  Timer _timer;
  @override
  Widget buildContext(BuildContext context, {store}) {
    Constants.initial(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double picHeight = height * 0.80;
    double bottomHeight = height - picHeight;
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _close = true;
                  getStore().state.goodsId = _goodsId;
                  _pushToTabbar();
                },
                child: Container(
                  width: width,
                  height: picHeight,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: _backgroundUrl != null
                        ? ExtendedImage.network(Api.getImgUrl(_backgroundUrl),
                            width: width,
                            alignment: Alignment.center,
                            height: picHeight,
                             fit: BoxFit.fill,
                            //fit: BoxFit.fitHeight,
                            enableLoadState: false)
                        : Container(),
                  ),
                ),
              ),
              Positioned(
                top: ScreenUtil().statusBarHeight + 20.rw,
                right: 30.rw,
                child: GestureDetector(
                  onTap: () {
                    _close = true;
                    _pushToTabbar();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.rw, vertical: 5.rw),
                    alignment: Alignment.center,
                    child: Text(
                      '跳过' +
                          "${_countDownNum > 0 ? " ${_countDownNum.toString()}" : ""}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 15 * 2.sp),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 0.6.rw),
                        borderRadius: BorderRadius.all(Radius.circular(23.rw)),
                        color: Colors.black.withAlpha(60)),
                  ),
                ),
              ),
            ],
          ),
          bottomHeight >= 100 ? _columnBottomWidget() : _rowBottomWidget(),
          // _rowBottomWidget()
          // _columnBottomWidget()
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    _autoLogin();
    _showController();

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _beginCountDown();
      UserManager.instance.updateUserBriefInfo(getStore());
      print(UserManager.instance.userBrief);
      if (UserManager.instance.haveLogin) {
        UserManager.instance.activePeople();
      }
    });

  }

  getPackageInfo() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    AppConfig.versionNumber = _packageInfo.buildNumber;
  }

  Future _showController() async {
    ResultData response = await HttpManager.post(HomeApi.showController, null);
    int result = response.data['data']['show'];
    AppConfig.showExtraCommission = result == 1;
  }

  _rowBottomWidget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double picHeight = height * 0.82;
    double bottomHeight = height - picHeight;
    double bottomPicHeight = (bottomHeight - 10) / 2;
    TextStyle textStyle = TextStyle(
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.w300,
        fontSize: 11 * 2.sp);
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Row(
              children: <Widget>[
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: bottomPicHeight,
                      height: bottomPicHeight,
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 6.0,
                            ),
                          ],
                          borderRadius:
                              BorderRadius.all(Radius.circular(rSize(10)))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1.0 / 1.0,
                          child: Image.asset(AppImageName.recook_icon_300,
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
            Expanded(
              child: Container(
                  height: bottomPicHeight,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Container(height: 10,),
                          Text(
                            "跟着英子去开店",
                            style: textStyle,
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _columnBottomWidget() {
    double height = MediaQuery.of(context).size.height;
    double bottomHeight = height * 0.18;
    double bottomPicHeight = bottomHeight / 2 - 25;
    TextStyle textStyle = TextStyle(
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.w300,
        fontSize: 11 * 2.sp);
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: bottomPicHeight,
                  height: bottomPicHeight,
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius:
                          BorderRadius.all(Radius.circular(10.rw))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.rw),
                    child: AspectRatio(
                      aspectRatio: 1.0 / 1.0,
                      child: Image.asset(AppImageName.recook_icon_300,
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ],
            )),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10.rw),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Container(height: 10,),
                    Text(
                      "跟着英子去开店",
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /*
    手机登录
   */
  _autoLogin() {
    var value = HiveStore.appBox.get('key_user');
    _launch(value);
  }

  _launch(String value) {
    Map<String, dynamic> params = Map();
    User user;
    if (value != null && value is String) {
      user = User.fromJson(json.decode(value));
      if (user.info.id != 0) {
        params.putIfAbsent("userId", () => user.info.id);
      }
    }
    UserDao.launch(params, success: (data, code, msg) {
      Map res = data;
      DPrint.printf('$res');
      if (res.containsKey("backgroundUrl")) {
        _backgroundUrl = res['backgroundUrl'];
        DPrint.printf("_backgroundurl = $_backgroundUrl");
        setState(() {});
      }
      if (res.containsKey('goodsId') && res['goodsId'] > 0) {
        _goodsId = res['goodsId'];
      }
      if (user != null && user.info.id != 0) {
        _userLogin(user);
      } else {
        _touristLogin();
      }
    }, failure: (code, msg) {
      if (code != HttpStatus.UNAUTHORIZED) {
        Toast.showError(msg);
      }
      _touristLogin();
    });
  }

  _userLogin(User user) {
    UserManager.updateUser(user, getStore()).then((login) {});
  }

  _touristLogin() {
    UserManager.logout();
    SharePreferenceUtils.remove(AppStrings.key_user);
  }

  _pushToTabbar() {
    _timer.cancel();
    _timer = null;
    Get.offAll(TabBarWidget());
  }

  _beginCountDown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timer == null || !mounted) {
        return;
      }
      setState(() {
        if (_countDownNum <= 1) {
          _pushToTabbar();
          return;
        }
        _countDownNum--;
      });
    });
  }
}
