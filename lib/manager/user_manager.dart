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

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:flutter/material.dart';
import 'package:recook/base/http_result_model.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/home_weather_model.dart';
import 'package:recook/models/user_brief_info_model.dart';
import 'package:recook/models/user_model.dart';
import 'package:recook/pages/home/model/king_coin_list_model.dart';
import 'package:recook/pages/user/functions/user_func.dart';
import 'package:recook/pages/user/mvp/user_presenter_impl.dart';
import 'package:recook/redux/recook_state.dart';
import 'package:recook/redux/user_brief_redux.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:recook/widgets/toast.dart';
import 'package:redux/redux.dart';

class UserManager {

  ///是否领取过7天体验卡
  static Future<int?> getGrayMode() async {

    ResultData result = await HttpManager.post(APIV2.userAPI.isGrayMode, {});

    if (result.data != null) {
      if (result.data['data'] != null) {
        return result.data['data']['condole'];
      }else
        return 0;
    }else
      return 0;
  }


  ValueNotifier<bool> getGray = ValueNotifier(false);

  static bool shouldRefresh = false;
  late User user;
  UserBrief? userBrief;
  bool getLoggerData = false;
  ///是否领取过七天体验卡
  bool? getSeven = false;
  // 天气数据
  HomeWeatherModel? homeWeatherModel;

  int goodsId = 0;

  num messageNum = 0;


  ValueNotifier<bool> refreshMessageNumber = ValueNotifier(false);

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


  ValueNotifier<bool> refreshHomeBottomTabbar = ValueNotifier(false);

  ValueNotifier<bool> openInstallLive = ValueNotifier(false);
  int? selectTabbarIndex;

  List<KingCoinListModel>? kingCoinListModelList;

  bool get haveLogin => login.value;

  String? _identifier = "";
  String? get indentifier => _identifier;
  String jpushRid = '';


  bool isWholesale = false;


  factory UserManager() => _getInstance()!;
  static UserManager? get instance => _getInstance();
  static UserManager? _instance;
  UserManager._internal() {
    // 初始化
  }
  static UserManager? _getInstance() {
    if (_instance == null) {
      _instance = new UserManager._internal();
      _instance!.user = User.empty();
      _instance!.selectTabbarIndex = 0;
      _instance!.userBrief = UserBrief.empty();
    }
    return _instance;
  }

  static Future<bool> updateUser(User user, Store<RecookState> store) async {
    instance!.user = user;
    instance!.login.value = true;
    UserManager.instance!.activePeople();
    String jsonStr = json.encode(user.toJson());
    // await SharePreferenceUtils.setString(AppStrings.key_user, jsonStr);
    // store.dispatch(UpdateUserAction(user));
    HiveStore.appBox!.put('key_user', jsonStr);
    UserManager.instance!.updateUserBriefInfo(store);
    BytedeskKefu.updateNickname(UserManager.instance?.user.info?.nickname??'');

    await  UserFunc.activeJpush(Platform.isIOS?2:1,UserManager.instance!.jpushRid);




    return true;
  }

  static updateUserInfo(Store<RecookState> store) async {
    String jsonStr = json.encode(instance!.user.toJson());
    // await SharePreferenceUtils.setString(AppStrings.key_user, jsonStr);
    // store.dispatch(UpdateUserAction(instance.user));
    HiveStore.appBox!.put('key_user', jsonStr);
  }

  static logout() async {
    DPrint.printf("退出登录了 -- ${instance!.login.value}");
    instance!.user = User.empty();
    instance!.login.value = false;
    HiveStore.appBox!.delete('key_user');
    // await SharePreferenceUtils.remove(AppStrings.key_user);
//    store.dispatch(UpdateUserAction(User.empty()));
  }

  Future<bool> updateUserBriefInfo(Store<RecookState> store) async {
    UserPresenterImpl presenterImpl = UserPresenterImpl();
    HttpResultModel<UserBrief?> model =
        await presenterImpl.getUserBriefInfo(instance!.user.info!.id);
    if (!model.result) {
      Toast.showInfo(model.msg);
      return false;
    }
    _identifier = model.data == null ? '' : model.data!.identifier;
    if(model.data!=null){
      _instance!.userBrief = model.data;
      store.dispatch(UpdateUserBriefAction(model.data));
    }

    // if(UserLevelTool.currentRoleLevelEnum() ==
    //     UserRoleLevel.subsidiary||UserLevelTool.currentRoleLevelEnum() ==
    //     UserRoleLevel.physical){
    //   UserManager.instance.isWholesale = true;
    // }else{
    //   UserManager.instance.isWholesale = false;
    // }


    return true;
  }

  Future<bool?> activePeople() async {
    ResultData result = await HttpManager.post(APIV2.userAPI.activePeople, {
      'id': UserManager.instance!.user.info!.id,
    });
    print('更新活跃人数');
    print(result);
    return null;
  }
}
