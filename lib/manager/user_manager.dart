/*
 * ====================================================
 * package   :
 * author    : Created by nansi.
 * time      : 2019/6/27  3:04 PM
 * remark    :
 * ====================================================
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recook/base/http_result_model.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/models/home_weather_model.dart';
import 'package:recook/models/user_brief_info_model.dart';
import 'package:recook/models/user_model.dart';
import 'package:recook/pages/user/mvp/user_presenter_impl.dart';
import 'package:recook/redux/user_brief_redux.dart';
import 'package:recook/redux/user_redux.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/utils/share_preference.dart';
import 'package:recook/redux/recook_state.dart';
import 'package:recook/widgets/toast.dart';
import 'package:redux/redux.dart';

class UserManager {
  static bool shouldRefresh = false;
  User user;
  // 天气数据
  HomeWeatherModel homeWeatherModel;
  ValueNotifier<bool> login = ValueNotifier(false);
  ValueNotifier<bool> refreshShoppingCart = ValueNotifier(false);
  ValueNotifier<bool> refreshShoppingCartNumber = ValueNotifier(false);
  ValueNotifier<bool> refreshShoppingCartNumberWithPage = ValueNotifier(false);
  ValueNotifier<bool> refreshGoodsDetailPromotionState = ValueNotifier(false);
  ValueNotifier<bool> refreshUserRole = ValueNotifier(false);
  // 刷新店铺界面
  ValueNotifier<bool> refreshShopPage = ValueNotifier(false);
  // 刷新我的界面
  ValueNotifier<bool> refreshUserPage = ValueNotifier(false);
  //支付密码状态改变
  ValueNotifier<bool> setPassword = ValueNotifier(false);
  //tabbar 点击状态更改 selectTabbarIndex点击的位置
  ValueNotifier<bool> selectTabbar = ValueNotifier(false);
  //从webview扫描返回通知
  ValueNotifier<bool> openInstallGoodsId = ValueNotifier(false);
  int selectTabbarIndex;

  bool get haveLogin => login.value;

  String _identifier = "";
  String get indentifier => _identifier;

  factory UserManager() => _getInstance();
  static UserManager get instance => _getInstance();
  static UserManager _instance;
  UserManager._internal() {
    // 初始化
  }
  static UserManager _getInstance() {
    if (_instance == null) {
      _instance = new UserManager._internal();
      _instance.user = User.empty();
      _instance.selectTabbarIndex = 0;
    }
    return _instance;
  }

  static Future<bool> updateUser(User user, Store<RecookState> store) async {
    instance.user = user;
    instance.login.value = true;
    String jsonStr = json.encode(user.toJson());
    await SharePreferenceUtils.setString(AppStrings.key_user, jsonStr);
    store.dispatch(UpdateUserAction(user));

    UserManager.instance.updateUserBriefInfo(store);
    return true;
  }

  static updateUserInfo(Store<RecookState> store) async {
    String jsonStr = json.encode(instance.user.toJson());
    await SharePreferenceUtils.setString(AppStrings.key_user, jsonStr);
    store.dispatch(UpdateUserAction(instance.user));
  }

  static logout() async {
    DPrint.printf("退出登录了 -- ${instance.login.value}");
    instance.user = User.empty();
    instance.login.value = false;
    await SharePreferenceUtils.remove(AppStrings.key_user);
//    store.dispatch(UpdateUserAction(User.empty()));
  }

  Future<bool> updateUserBriefInfo(Store<RecookState> store) async {
    UserPresenterImpl presenterImpl = UserPresenterImpl();
    HttpResultModel<UserBrief> model =
        await presenterImpl.getUserBriefInfo(instance.user.info.id);
    if (!model.result) {
      Toast.showInfo(model.msg);
      return false;
    }
    _identifier = model.data == null ? '' : model.data.identifier;

    store.dispatch(UpdateUserBriefAction(model.data));
    return true;
  }
}
