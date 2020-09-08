/*
 * ====================================================
 * package   : utils
 * author    : Created by nansi.
 * time      : 2019/5/6  10:27 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtils {
  ///替换
  static Future pushReplacement(BuildContext context, String routeName, {@required arguments}) {
    return Navigator.pushReplacementNamed(
        context, routeName, arguments: arguments);
  }

  /// 返回并跳转新界面
  static Future popAndPushNamed(BuildContext context, String routeName, {@required arguments}) {
    return Navigator.popAndPushNamed(
        context, routeName, arguments: arguments);
  }

  /// 返回并跳转新界面
  static Future pushNamedAndRemoveUntil(BuildContext context, String routeName, {@required arguments}) {
    return Navigator.pushNamedAndRemoveUntil(
        context, routeName, (route) => route == null, arguments: arguments);
  }


  /// ios系统push
  static Future iosPush(BuildContext context, Widget widget) {
    return Navigator.push(
        context, new CupertinoPageRoute(builder: (context) => widget));
  }

  static Future<T> modelRoute<T extends Object>(BuildContext context, String routeName, {@required arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

}
