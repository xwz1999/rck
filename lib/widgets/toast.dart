/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/5/20  9:49 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/header.dart';


enum Gravity {
  TOP,
  CENTER,
  BOTTOM
}

class Toast {
  static showError(msg, {int millisecond = 2500, offset = 0.0 }) {
    showToast(
        msg,
        textStyle: TextStyle(fontSize: ScreenAdapterUtils.setSp(14)),
        textPadding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: millisecond),
        position: ToastPosition(align: Alignment.bottomCenter, offset: offset),
        dismissOtherToast: true
    );
  }

  static showSuccess(msg, {Color color = const Color(0xFF2E7D32)}) {
    showToast(
        msg,
        textStyle: TextStyle(fontSize: ScreenAdapterUtils.setSp(14)),
        textPadding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        backgroundColor: color,
        position: ToastPosition(align: Alignment.bottomCenter),
        dismissOtherToast: true
    );
  }

  static showCustomSuccess(msg, {TextStyle textStyle ,ToastPosition position , Color color = Colors.black, Duration delayedDuration}) {
    Future.delayed(
      delayedDuration!=null? delayedDuration : Duration(seconds: 1), 
      (){
        showToast(
          msg,
          textStyle:textStyle!=null? textStyle : TextStyle(fontSize: ScreenAdapterUtils.setSp(14), color: Colors.white),
          textPadding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          backgroundColor: color,
          position:position!=null? position : ToastPosition(align: Alignment.center),
          dismissOtherToast: true
        );
      }
    );
  }


  static showInfo(msg,
      {Color color, Gravity gravity = Gravity.CENTER, int duration}) {
    if (color == null) {
      color = Colors.black87;
    }

    showToast(
        msg,
        textStyle: TextStyle(fontSize: ScreenAdapterUtils.setSp(14), color: Colors.white),
        textPadding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        backgroundColor: color,
        position: _transformGravity(gravity),
        dismissOtherToast: true
    );
  }


  static _transformGravity(Gravity gravity) {
    switch (gravity) {
      case Gravity.TOP :
        {
          return ToastPosition(align: Alignment.topCenter);
        }
      case Gravity.CENTER :
        {
          return ToastPosition(align: Alignment.center, offset: 20);
        }
      case Gravity.BOTTOM :
        {
          return ToastPosition(align: Alignment.bottomCenter);
        }
    }
  }

}