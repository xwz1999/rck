/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-15  17:26 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/input_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SCTile {
  static TextStyle _titleStyle =
      AppTextStyle.generate(15 * 2.sp, fontWeight: FontWeight.w400);
  static TextStyle _subtitleStyle = AppTextStyle.generate(14 * 2.sp,
      color: Colors.grey[600], fontWeight: FontWeight.w400);

  static normalTile(String title,
      {VoidCallback listener,
      String value,
      Color backgroundColor = Colors.white,
      EdgeInsets padding =
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      EdgeInsets margin = const EdgeInsets.all(0),
      EdgeInsets divideMargin = const EdgeInsets.only(left: 10),
      TextStyle titleStyle,
      TextStyle subtitleStyle,
      Widget trailing,
      bool needDivide = false,
      bool needArrow = true}) {
    return Container(
      margin: margin,
      child: Column(
        children: <Widget>[
          CustomImageButton(
            onPressed: listener,
            greyWhenTapped: true,
            pureDisplay: listener == null,
            backgroundColor: backgroundColor,
            child: Container(
              padding: padding,
              child: Row(
                children: <Widget>[
                  Container(
                      width: rSize(160),
                      child: Text(
                        title,
                        style: titleStyle ?? _titleStyle,
                      )),
                  Spacer(),
                  trailing ??
                      (value == null
                          ? Container()
                          : Text(
                              value,
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: subtitleStyle ?? _subtitleStyle,
                            )),
                  SizedBox(
                    width: rSize(5),
                  ),
                  Offstage(
                      offstage: !needArrow,
                      child: Icon(
                        AppIcons.icon_next,
                        size: rSize(14),
                        color: Colors.grey,
                      ))
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !needDivide,
            child: Container(
              margin: divideMargin,
              color: Colors.grey[300],
              height: 0.8 * 2.w,
            ),
          )
        ],
      ),
    );
  }

  static editTile(TextEditingController controller, String title, String value,
      {String hint = "",
      TextStyle titleStyle,
      TextStyle subtitleStyle,
      TextStyle hintStyle,
      TextAlign textAlign = TextAlign.end,
      Widget trailing}) {
    assert(controller != null, "editTile controller 不能为空");

    return Container(
      margin: EdgeInsets.symmetric(vertical: rSize(8)),
      child: Row(
        children: <Widget>[
          Container(
              width: rSize(80),
              child: Text(
                title,
                style: titleStyle ?? _titleStyle,
              )),
          Expanded(
            child: InputView(
              padding: EdgeInsets.zero,
              controller: controller,
              textStyle: subtitleStyle ?? _subtitleStyle,
              showClear: false,
              hintStyle: hintStyle ??
                  AppTextStyle.generate(14 * 2.sp, color: Colors.grey[300]),
              hint: hint,
              textAlign: textAlign,
            ),
          ),
          trailing ?? Container()
        ],
      ),
    );
  }

  static listTile(
    String title,
    Widget mid, {
    Widget suffix,
    Color backgroundColor,
    VoidCallback onPressed,
    bool inNeed = false,
  }) {
    Widget child = Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 16 * 2.sp,
          ),
        ),
        Text(
          '*',
          style: TextStyle(
            color: inNeed ? AppColor.redColor : Colors.transparent,
          ),
        ),
        SizedBox(
          width: rSize(16),
        ),
        Expanded(child: mid),
        suffix ?? SizedBox(),
      ],
    );
    return onPressed == null
        ? Container(
            color: backgroundColor ?? Colors.white,
            child: child,
            padding: EdgeInsets.symmetric(
              horizontal: rSize(16),
              vertical: rSize(12),
            ),
          )
        : CustomImageButton(
            backgroundColor: backgroundColor ?? Colors.white,
            onPressed: onPressed,
            padding: EdgeInsets.symmetric(
              horizontal: rSize(16),
              vertical: rSize(12),
            ),
            child: child,
          );
  }
}
