/*
 * ====================================================
 * package   : constants
 * author    : Created by nansi.
 * time      : 2019/5/16  10:02 AM 
 * remark    : 
 * ====================================================
 */

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';

class AppConfig {
  static String versionNumber;
  static bool debug;
  static bool needEncrypt;
  static bool showCommission;

  ///后台控制显示
  static bool showExtraCommission = false;
  static const String WX_APP_ID = "wx737af52b2ad6d518";
  static const String WX_APP_SECRET = "ac7c99f7d7c33a430714613ecb49baa2";
  static const String WX_APP_MINIPRO_USERNAME = "gh_75059c6578e0";

  static initial({
    bool dev = true,
    bool useEncrypt = true,
    bool canShowCommission = true,
  }) {
    debug = dev;
    needEncrypt = useEncrypt;
    showCommission = canShowCommission;
    Api.toggleEnvironment(debug);
  }

  static setDebug(bool isDebug) {
    if (debug == isDebug) {
      return;
    }
    debug = isDebug;
    Api.toggleEnvironment(debug);
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
  static bool getShowCommission() {
    // return true;
    if (showExtraCommission) {
      return true;
    } else {
      if ((!UserManager.instance.haveLogin ||
          UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip ||
          UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None)) {
        return false;
      }
    }

    return showCommission;
  }

  static bool get commissionByRoleLevel {
    if ((!UserManager.instance.haveLogin ||
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip ||
        UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None)) {
      return false;
    } else
      return true;
  }
}
