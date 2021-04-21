/*
 * ====================================================
 * package   : widgets
 * author    : Created by nansi.
 * time      : 2019/3/27  4:09 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/utils/text_utils.dart';

// ignore: must_be_immutable
class LoadingDialog extends Dialog {
  String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.transparent,
        child: WillPopScope(
          onWillPop: () => new Future.value(false),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: ScreenAdapterUtils.setWidth(100.0),
                constraints: BoxConstraints(
                    minWidth: ScreenAdapterUtils.setWidth(100.0)),
                padding: new EdgeInsets.only(
                    top: rSize(5),
                    bottom: rSize(5),
                    left: rSize(13),
                    right: rSize(13)),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  //用一个BoxDecoration装饰器提供背景图片
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        child: SpinKitWave(
                      color: AppColor.themeColor,
                      duration: Duration(milliseconds: 800),
                      size: rSize(25),
                      type: SpinKitWaveType.start,
                    )),
                    Offstage(
                        offstage: TextUtils.isEmpty(text),
                        child: new Container(height: rSize(15))),
                    Offstage(
                      offstage: TextUtils.isEmpty(text),
                      child: new Container(
                          child: new Text(text,
                              style: AppTextStyle.generate(14 * 2.sp,
                                  color: Colors.black))),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ));
  }
}

enum Status { success, error, warning }

// ignore: must_be_immutable
class StatusDialog extends Dialog {
  String text;
  Status status;

  StatusDialog({Key key, @required this.text, this.status = Status.success})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.transparent,
        child: WillPopScope(
          onWillPop: () => new Future.value(false),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
//                height: rSize(100),
                constraints: BoxConstraints(
                  minWidth: rSize(100),
                ),
                padding: new EdgeInsets.only(
                    top: rSize(10),
                    bottom: rSize(10),
                    left: rSize(13),
                    right: rSize(13)),
                decoration: new BoxDecoration(
                  color: Colors.black87,
                  //用一个BoxDecoration装饰器提供背景图片
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(child: _getIcon()),
                    Offstage(
                        offstage: TextUtils.isEmpty(text),
                        child: new Container(height: rSize(10))),
                    Offstage(
                      offstage: TextUtils.isEmpty(text),
                      child: Container(
                        child: new Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: new Text(text,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.generate(15 * 2.sp,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ));
  }

  _getIcon() {
    Widget icon;
    switch (status) {
      case Status.success:
        icon = Image.asset(
          AppImageName.progress_status_success,
          width: rSize(32),
          height: rSize(32),
        );
        break;
      case Status.error:
        icon = Image.asset(
          AppImageName.progress_status_error,
          width: rSize(32),
          height: rSize(32),
        );
        break;
      case Status.warning:
        icon = Image.asset(
          AppImageName.progress_status_warning,
          width: rSize(32),
          height: rSize(32),
        );
        break;
    }
    return icon;
  }
}
