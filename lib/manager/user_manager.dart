/*
 * ====================================================
 * package   :
 * author    : Created by nansi.
 * time      : 2019/6/27  3:04 PM
 * remark    :
 * ====================================================
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/http_result_model.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/models/home_weather_model.dart';
import 'package:jingyaoyun/models/user_brief_info_model.dart';
import 'package:jingyaoyun/models/user_model.dart';
import 'package:jingyaoyun/pages/home/model/king_coin_list_model.dart';
import 'package:jingyaoyun/pages/user/mvp/user_presenter_impl.dart';
import 'package:jingyaoyun/redux/recook_state.dart';
import 'package:jingyaoyun/redux/user_brief_redux.dart';
import 'package:jingyaoyun/utils/print_util.dart';
import 'package:jingyaoyun/utils/storage/hive_store.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:redux/redux.dart';

class UserManager {
  static bool shouldRefresh = false;
  User user;
  UserBrief userBrief;
  bool getLoggerData = false;
  ///是否领取过七天体验卡
  bool getSeven = false;
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

  ValueNotifier<bool> openInstallLive = ValueNotifier(false);
  int selectTabbarIndex;

  List<KingCoin> kingCoinListModelList;

  bool get haveLogin => login.value;

  String _identifier = "";
  String get indentifier => _identifier;
  String jpushRid = '';

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
      _instance.userBrief = UserBrief.empty();
    }
    return _instance;
  }

  static Future<bool> updateUser(User user, Store<RecookState> store) async {
    instance.user = user;
    instance.login.value = true;
    UserManager.instance.activePeople();
    String jsonStr = json.encode(user.toJson());
    // await SharePreferenceUtils.setString(AppStrings.key_user, jsonStr);
    // store.dispatch(UpdateUserAction(user));
    HiveStore.appBox.put('key_user', jsonStr);
    UserManager.instance.updateUserBriefInfo(store);
    int type;
    if (Platform.isIOS) {
      type = 2;
    } else if (Platform.isAndroid) {
      type = 1;
    }
    // String code =
    //     await UserManager.updateJId(UserManager.instance.jpushRid, type);
    // print(code);

    return true;
  }

  static updateUserInfo(Store<RecookState> store) async {
    String jsonStr = json.encode(instance.user.toJson());
    // await SharePreferenceUtils.setString(AppStrings.key_user, jsonStr);
    // store.dispatch(UpdateUserAction(instance.user));
    HiveStore.appBox.put('key_user', jsonStr);
  }

  static logout() async {
    DPrint.printf("退出登录了 -- ${instance.login.value}");
    instance.user = User.empty();
    instance.login.value = false;
    HiveStore.appBox.delete('key_user');
    // await SharePreferenceUtils.remove(AppStrings.key_user);
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
    if(model.data!=null){
      _instance.userBrief = model.data;
      store.dispatch(UpdateUserBriefAction(model.data));
    }
    return true;
  }

  Future<bool> activePeople() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.activePeople, {
      'id': UserManager.instance.user.info.id,
    });
  }
}
