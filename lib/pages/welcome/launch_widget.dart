import 'dart:async';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/config.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/functions/user_func.dart';
import 'package:jingyaoyun/pages/welcome/welcome_widget.dart';
import 'package:jingyaoyun/utils/storage/hive_store.dart';
import 'package:package_info/package_info.dart';
import 'package:power_logger/power_logger.dart';

import 'launch_privacy_dialog.dart';

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

    //初始化AMap  给android和ios


    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await Future.delayed(Duration(milliseconds: 2450));
      if (HiveStore.appBox.get('privacy_init') == null) {
        // if (true) {
        bool agreeResult = (await launchPrivacyDialog(context)) ?? false;
        if (!agreeResult) {
          //第1次不同意`
          bool secondAgree =
              (await launchPrivacySecondDialog(context)) ?? false;
          //第2次不同意
          if (!secondAgree)
            SystemNavigator.pop();
          else{
            HiveStore.appBox.put('privacy_init', true);
            Future.delayed(Duration.zero, () async {
              UserManager.instance.kingCoinListModelList =
              await UserFunc.getKingCoinList();
            });
            AMapFlutterLocation.setApiKey(
                'cd71676364972b01d9803249f7112bc0', 'a165543d6e2be75f4ac1b6b81ce0dae2');
            //初始化日志工具
            PowerLogger.start(context, debug: AppConfig.debug);//AppConfig.debug  在正式服数据下进行调试
            //初始化
            cameras = await availableCameras();
            //高德地图隐私协议 在用户同意隐私协议后更新
            AMapFlutterLocation.updatePrivacyShow(true, true);
            AMapFlutterLocation.updatePrivacyAgree(true);
            //获取apk包的信息(版本)
            PackageInfo _packageInfo = await PackageInfo.fromPlatform();
            AppConfig.versionNumber = _packageInfo.buildNumber;
            Get.offAll(WelcomeWidget());
          }

        } else{
          HiveStore.appBox.put('privacy_init', true);
          Future.delayed(Duration.zero, () async {
            UserManager.instance.kingCoinListModelList =
            await UserFunc.getKingCoinList();
          });
          AMapFlutterLocation.setApiKey(
              'cd71676364972b01d9803249f7112bc0', 'a165543d6e2be75f4ac1b6b81ce0dae2');
          //初始化日志工具
          PowerLogger.start(context, debug: AppConfig.debug);//AppConfig.debug  在正式服数据下进行调试
          //初始化
          cameras = await availableCameras();
          //高德地图隐私协议 在用户同意隐私协议后更新
          AMapFlutterLocation.updatePrivacyShow(true, true);
          AMapFlutterLocation.updatePrivacyAgree(true);
          //获取apk包的信息(版本)
          PackageInfo _packageInfo = await PackageInfo.fromPlatform();
          AppConfig.versionNumber = _packageInfo.buildNumber;
          Get.offAll(WelcomeWidget());
        }
      }else{
        Future.delayed(Duration.zero, () async {
          UserManager.instance.kingCoinListModelList =
          await UserFunc.getKingCoinList();
        });
        AMapFlutterLocation.setApiKey(
            'cd71676364972b01d9803249f7112bc0', 'a165543d6e2be75f4ac1b6b81ce0dae2');
        //初始化日志工具
        PowerLogger.start(context, debug: AppConfig.debug);//AppConfig.debug  在正式服数据下进行调试
        //初始化
        cameras = await availableCameras();
        //高德地图隐私协议 在用户同意隐私协议后更新
        AMapFlutterLocation.updatePrivacyShow(true, true);
        AMapFlutterLocation.updatePrivacyAgree(true);
        //获取apk包的信息(版本)
        PackageInfo _packageInfo = await PackageInfo.fromPlatform();
        AppConfig.versionNumber = _packageInfo.buildNumber;
        Get.offAll(WelcomeWidget());
      }
    });
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    Constants.initial(context);
    return Scaffold(
      body:  Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(top: 150.rw),
        alignment: Alignment.topCenter,
        child: Image.asset(
            R.ASSETS_RECOOK_LAUNCH_IMAGE_RECOOK_SPLASH_PNG,
            width: 200.rw,
            height: 200.rw,
            fit: BoxFit.fill,
        ),
      ),
    );
  }
}
