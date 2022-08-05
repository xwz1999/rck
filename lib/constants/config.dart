/*
 * ====================================================
 * package   : constants
 * author    : Created by nansi.
 * time      : 2019/5/16  10:02 AM 
 * remark    : 
 * ====================================================
 */

import 'package:recook/constants/api.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/utils/user_level_tool.dart';

class AppConfig {
  static String? versionNumber;
  static bool? debug;
  static bool? needEncrypt;
  static bool? showCommission;

  ///后台控制显示
  static bool showExtraCommission = false;
  static const String WX_APP_ID = "wx21724a42aebe20cc";
  static const String WX_APP_SECRET = "83f8932eb742257316e3168ba9e920dc";
  static const String WX_APP_MINIPRO_USERNAME = "gh_530bd0866836";

  static const String MAP_ANDROID_KEY = "adf1ae7949103ce6a255ffe6e1f7eb77";
  static const String MAP_IOS_KEY = "6e719eb22b154c557105a592d568f452";

  static const String LBS_ANDROID_KEY = "6891e275-61d4-4866-96ae-476d1479fc60";
  static const String LBS_IOS_KEY = "4d853603-836d-4cfa-838d-f25e47169821";
  static const String LBS_SUBDOMAIN = "202104201749561";
  static const String WORK_GROUP_WID = "2021042017495732a907d876a3d41d580bb50d7b6a1ccf1";



  static initial({
    bool dev = true,
    bool useEncrypt = true,
    bool canShowCommission = true,
  }) {
    debug = dev;
    needEncrypt = useEncrypt;
    showCommission = canShowCommission;
    Api.toggleEnvironment(debug!);
  }

  static setDebug(bool isDebug) {
    if (debug == isDebug) {
      return;
    }
    debug = isDebug;
    Api.toggleEnvironment(debug!);
  }

  static setEncrypt(bool isEncrypt) {
    if (needEncrypt == isEncrypt) {
      return;
    }
    needEncrypt = isEncrypt;
  }

  // static setShowCommission(bool canShowCommission) {
  //   if (showCommission == canShowCommission) {
  //     return;
  //   }
  //   showCommission = canShowCommission;
  // }

  ///佣金控制显示
  ///
  ///首先判断showExtraCommission，该值由后台控制显示
  ///
  ///其次未登陆和一般会员用户无法显示该值
  static bool? getShowCommission() {
    // return true;
    if (showExtraCommission) {
      return true;
    } else {
      if ((!UserManager.instance!.haveLogin ||
          UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip ||
          UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None)) {
        return false;
      }
    }

    return showCommission;
  }

  static bool get commissionByRoleLevel {
    if ((!UserManager.instance!.haveLogin ||
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip ||
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None)) {
      return false;
    } else
      return true;
  }
}
