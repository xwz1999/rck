import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
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

  static _showUpDateAlert(context, VersionInfoModel model) async {
    VersionInfo? versionInfo = model.data!.versionInfo;
    // VersionInfo versionInfo = getStore().state.userBrief.versionInfo;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String _appStoreURL = '';

    if (versionInfo == null) {
      return;
    }
    if (Platform.isAndroid) _appStoreURL = WebApi.androidUrl;
    if (Platform.isIOS) _appStoreURL = WebApi.iOSUrl;
    //当前版本小于服务器版本
    if (int.parse(packageInfo.buildNumber) < versionInfo.build!) {
      Alert.show(
          context,
          NormalTextDialog(
            title: "发现新版本",
            content: "${versionInfo.desc}",
            items: ["取消", "确认"],
            listener: (int index) async {
              Alert.dismiss(context);
              if (index == 1) {
                if(Platform.isAndroid){
                  LaunchReview.launch(androidAppId: "com.akuhome.recook", iOSAppId: '1601169177');
                }else{
                  if (await canLaunch(_appStoreURL)) {

                    launch(_appStoreURL);
                    if (Theme.of(context).platform == TargetPlatform.iOS) {
                      Future.delayed(
                          const Duration(seconds: 3), () => closeWebView());
                    }
                  }
                }


                // if (await canLaunch(_appStoreURL)) {
                //
                //   launch(_appStoreURL);
                //   if (Theme.of(context).platform == TargetPlatform.iOS) {
                //     Future.delayed(
                //         const Duration(seconds: 3), () => closeWebView());
                //   }
                // }
              }
            },
          ));
    }
  }


  // static Future<String> _getAndroidURL() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //   String brand = androidInfo.brand.toLowerCase();
  //   print(brand);
  //   bool safeMarket = ['xiaomi', 'oneplus', 'oppo', 'vivo', 'huawei']
  //       .any((element) => brand.contains(element));
  //   if (safeMarket)
  //     return 'market://details?id=com.akuhome.jingyaoyun';
  //   else
  //     return WebApi.androidUrl;
  // }
}
