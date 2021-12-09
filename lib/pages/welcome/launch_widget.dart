/*
 * ====================================================
 * package   : pages.welcome
 * author    : Created by nansi.
 * time      : 2019/5/5  4:47 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info/package_info.dart';

import 'package:power_logger/power_logger.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/config.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/functions/user_func.dart';
import 'package:recook/pages/welcome/launch_privacy_dialog.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:recook/utils/test.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_live_fluttify/tencent_live_fluttify.dart';
List<CameraDescription> cameras;
class LaunchWidget extends StatefulWidget {
  @override
  _LaunchWidgetState createState() => _LaunchWidgetState();
}

class _LaunchWidgetState extends BaseStoreState<LaunchWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await Future.delayed(Duration(milliseconds: 2450));
      // if (HiveStore.appBox.get('privacy_init') == null) {
      //   // if (true) {
      //   bool agreeResult = (await launchPrivacyDialog(context)) ?? false;
      //   if (!agreeResult) {
      //     //第1次不同意
      //     bool secondAgree =
      //         (await launchPrivacySecondDialog(context)) ?? false;
      //     //第2次不同意
      //     if (!secondAgree)
      //       SystemNavigator.pop();
      //     else
      //       HiveStore.appBox.put('privacy_init', true);
      //   } else
      //     HiveStore.appBox.put('privacy_init', true);
      // }
      Future.delayed(Duration.zero, () async {
        UserManager.instance.kingCoinListModelList =
        await UserFunc.getKingCoinList();
        setState(() {

        });
      });
      PowerLogger.start(context, debug: true);//AppConfig.debug  在正式服数据下进行调试
      cameras = await availableCameras();
      PackageInfo _packageInfo = await PackageInfo.fromPlatform();
      AppConfig.versionNumber = _packageInfo.buildNumber;

      TencentImPlugin.init(appid: '1400435566');
      HttpManager.post(LiveAPI.liveLicense, {}).then((resultData) {
        String key = resultData.data['data']['key'];
        String licenseURL = resultData.data['data']['licenseUrl'];
        //初始化腾讯直播
        TencentLive.instance.init(
          licenseUrl: licenseURL,
          licenseKey: key,
        );
      });


      AppRouter.fadeAndReplaced(globalContext, RouteName.WELCOME_PAGE);
    });
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    Constants.initial(context);
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Image.asset(
        R.ASSETS_RECOOK_LAUNCH_IMAGE_RECOOK_SPLASH_WEBP,
        fit: BoxFit.cover,
      ),
      // body: Container(
      //   child: ImagesAnimation(
      //       w: width,
      //       h: height,
      //       milliseconds: 2000,
      //       entry: ImagesAnimationEntry(0, 70,
      //           "assets/recook_launch_image/recook_launch_image_%s.png")),
      // ),
    );
  }
}
