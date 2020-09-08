import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/utils/versionInfo/version_info_model.dart';
import 'package:recook/widgets/alert.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionTool {
  static checkVersionInfo(context) async {
    ResultData resultData = await HttpManager.post(UserApi.version_info, {});
    if (!resultData.result) {
      return;
    }
    VersionInfoModel model = VersionInfoModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      return;
    }
    _showUpDateAlert(context, model);
  }

  static _showUpDateAlert(context,VersionInfoModel model) async {
    VersionInfo versionInfo = model.data.versionInfo;
    // VersionInfo versionInfo = getStore().state.userBrief.versionInfo;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (versionInfo==null) {
      return;
    }
    //当前版本小于服务器版本
    if (int.parse(packageInfo.buildNumber) < versionInfo.build) {
      Alert.show(
        context, 
        NormalTextDialog(
          title: "发现新版本",
          content: "${versionInfo.desc}",
          items: ["确认","取消"],
          listener: (int index) async {
            Alert.dismiss(context);
              if (index == 0) {
                String _url = WebApi.androidUrl;
                if (Platform.isIOS) _url = WebApi.iOSUrl;
                if (await canLaunch(_url)){
                  launch(_url);
                  if (Theme.of(context).platform == TargetPlatform.iOS) {
                    Future.delayed(const Duration(seconds: 3), () => closeWebView());
                  }
                }
              }
            },
          )
      );
    }
  }

}