/*
 * ====================================================
 * package   : constants
 * author    : Created by nansi.
 * time      : 2019/5/6  9:12 AM 
 * remark    : 
 * ====================================================
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {
  Constants.initial(BuildContext context) {
    DeviceInfo.initial();
  }
}

extension SeparateExt on List<Widget> {
  List<Widget> sepWidget({Widget separate}) {
    if (this.length <= 1) return this;
    return List.generate(this.length * 2 - 1, (index) {
      if (index.isEven)
        return this[index ~/ 2];
      else
        return separate ?? 10.wb;
    });
  }
}

// 屏幕适配
class ScreenAdapterUtils {

  static double setWidth(double width) {
    return ScreenUtil().setWidth(width * 2);
  }

  static double setHeight(double height) {
    return ScreenUtil().setHeight(height * 2);
  }

  static double setSp(double font) {
    return ScreenUtil().setSp(font * 2);
  }
}

//DESIGN CONSTANT

///DESIGN WIDTH
double rSize(double size) {
  return ScreenAdapterUtils.setWidth(size);
}

///DESIGN SP
double rSP(double size) {
  return ScreenAdapterUtils.setSp(size);
}

/// DESIGN SizedBox with width
Widget rWBox(double size) {
  return SizedBox(width: ScreenAdapterUtils.setWidth(size));
}

/// DESIGN SizedBox with height
Widget rHBox(double size) {
  return SizedBox(height: ScreenAdapterUtils.setWidth(size));
}

class AppStrings {
  static const String key_user = "user_json_save";

  static const String key_province_city_json = "province_city_json";
}

class AppPaths {
  static const String path_province_city_json = "/provinceCityJson.json";
}

class DeviceInfo {
  static double screenHeight;
  static double screenWidth;
  static double statusBarHeight;
  static double bottomBarHeight;
  static double devicePixelRatio;
  static double appBarHeight = 56;

  DeviceInfo.initial() {
    MediaQueryData data = MediaQueryData.fromWindow(window);
    screenHeight = data.size.height;
    screenWidth = data.size.width;
    statusBarHeight = data.padding.top;
    bottomBarHeight = data.padding.bottom;
    devicePixelRatio = data.devicePixelRatio;
  }
}

extension NumExt on num {
  double get rw => ScreenAdapterUtils.setWidth(this + .0);

  double get rsp => ScreenAdapterUtils.setSp(this + .0);

  Widget get hb => SizedBox(height: this.w);

  Widget get wb => SizedBox(width: this.w);
}
