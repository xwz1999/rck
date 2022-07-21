import 'dart:async';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/functions/user_func.dart';
import 'package:recook/pages/welcome/welcome_widget.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:package_info/package_info.dart';
import 'package:power_logger/power_logger.dart';

import 'launch_privacy_dialog.dart';

List<CameraDescription>? cameras;

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
    //初始化日志工具
    PowerLogger.start(context, debug:true);//AppConfig.debug!  在正式服数据下进行调试\

    WidgetsBinding.instance!.addPostFrameCallback((callback) async {
      await Future.delayed(Duration(milliseconds: 2450));
      if (HiveStore.appBox!.get('privacy_init') == null) {
        // if (true) {
        bool agreeResult = (await launchPrivacyDialog(context)) ?? false;
        if (!agreeResult) {
          //第1次不同意`
          bool secondAgree =
              (await (launchPrivacySecondDialog(context) )) ?? false;
          //第2次不同意
          if (!secondAgree)
            SystemNavigator.pop();
          else{
            HiveStore.appBox!.put('privacy_init', true);
            Future.delayed(Duration.zero, () async {
              UserManager.instance!.kingCoinListModelList =
              await UserFunc.getKingCoinList();
            });

            AMapFlutterLocation.setApiKey(
                'adf1ae7949103ce6a255ffe6e1f7eb77', '6e719eb22b154c557105a592d568f452');

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
          HiveStore.appBox!.put('privacy_init', true);
          Future.delayed(Duration.zero, () async {
            UserManager.instance!.kingCoinListModelList =
            await UserFunc.getKingCoinList();
          });
          AMapFlutterLocation.setApiKey(
              'adf1ae7949103ce6a255ffe6e1f7eb77', '6e719eb22b154c557105a592d568f452');
          //初始化
          cameras = await availableCameras();
          //高德地图隐私协议 在用户同意隐私协议后更新
          AMapFlutterLocation.updatePrivacyShow(true, true);
          AMapFlutterLocation.updatePrivacyAgree(true);
          //获取apk包的信息(版本)
          PackageInfo _packageInfo = await PackageInfo.fromPlatform();
          AppConfig.versionNumber = _packageInfo.buildNumber;
          Get.offAll(() => WelcomeWidget());
        }
      }else{
        Future.delayed(Duration.zero, () async {
          UserManager.instance!.kingCoinListModelList =
          await UserFunc.getKingCoinList();
        });
        AMapFlutterLocation.setApiKey(
            'adf1ae7949103ce6a255ffe6e1f7eb77', '6e719eb22b154c557105a592d568f452');
        //初始化
        cameras = await availableCameras();
        //高德地图隐私协议 在用户同意隐私协议后更新
        AMapFlutterLocation.updatePrivacyShow(true, true);
        AMapFlutterLocation.updatePrivacyAgree(true);
        //获取apk包的信息(版本)
        PackageInfo _packageInfo = await PackageInfo.fromPlatform();
        AppConfig.versionNumber = _packageInfo.buildNumber;
        Get.offAll(() => WelcomeWidget());
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
        margin: EdgeInsets.only(top: 200.rw),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.rw),
              child: Image.asset(
                  Assets.icon.icLauncherPlaystore.path,
                  width: 120.rw,
                  height: 120.rw,
                  fit: BoxFit.fill,
              ),
            ),
            50.hb,

            Text(
                '数字化批发零售服务平台',
              style: TextStyle(
                color: Color(0xFF7f7f7f),
                fontSize: 50.sp
              ),
            )
          ],
        ),
      ),
    );
  }
}
