/*
 * ====================================================
 * package   : constants
 * author    : Created by nansi.
 * time      : 2019/5/6  9:13 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

class AppColor {
  static const Color themeColor = Color.fromARGB(255, 206, 38, 40);
//  static const Color themeColor = Color(0xFFFF2F10);
  static const Color pinkColor = Color.fromARGB(255, 254, 201, 198);
  
  static const Color greenColor = Color.fromARGB(255, 37, 186, 114);
  
  // 浅灰色
  static const Color frenchColor = Color(0xFFF8F7F8);
  static const Color blackColor = Color(0xff16182b);
  static const Color greyColor = Color.fromARGB(255, 204, 204, 204);
  static const Color tableViewGrayColor = Color.fromARGB(255, 237, 239, 240);

  static const Color appBarGrey = Color(0xFFFBFBFB);

  static const Color priceColor = Color(0xffff6d00);
  static const Color redColor = Color(0xffd5101a);

  static rgbColor(int r, int g, int b, {int a = 255}) {
    return Color.fromARGB(a, r, g, b);
  }
}

class AppTextStyle {
  static const appBarTextStyle = TextStyle(color: Colors.white);
  static const appBarItemTextStyle = TextStyle(color: Colors.white, fontSize: 13);

  static TextStyle generate(double fontSize,{FontWeight fontWeight, Color color = Colors.black, TextDecoration decoration,Paint background}) {
    return TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight,decoration: decoration ,background: background);
  }
}

class AppThemes {
  static const appBarIconThemeData = IconThemeData(color: Colors.white);

  static final ThemeData themeDataGrey = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.light,
    // 使用 bottomSheet 时， 修改背景色为透明时使用
    canvasColor: Colors.transparent,
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.grey[400]),
        color: AppColor.appBarGrey,
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.grey[900], fontSize: 17, fontWeight: FontWeight.w500))),
    scaffoldBackgroundColor: Colors.white,
  );

  /// 主题色
  static final ThemeData themeDataMain = ThemeData(
    primaryColor: AppColor.themeColor,
    brightness: Brightness.dark,
    // 使用 bottomSheet 时， 修改背景色为透明时使用
    canvasColor: Colors.transparent,
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        color: AppColor.themeColor,
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500))),
    iconTheme: IconThemeData(color: AppColor.themeColor),
//    textTheme: TextTheme(title: TextStyle(color: Colors.black)),
    scaffoldBackgroundColor: Colors.white,
  );

}