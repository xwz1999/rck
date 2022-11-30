import 'dart:async';
import 'dart:io';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/functions/user_func.dart';
import 'package:recook/pages/welcome/welcome_widget.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:power_logger/power_logger.dart';
import 'package:bytedesk_kefu/bytedesk_kefu.dart';
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
    Future.delayed(Duration.zero, () async {
      UserManager.instance!.kingCoinListModelList =
      await UserFunc.getKingCoinList();
    });
    //初始化日志工具
    PowerLogger.start(context, debug:AppConfig.debug!);//AppConfig.debug!  在正式服数据下进行调试\

    WidgetsBinding.instance?.addPostFrameCallback((callback) async {
      await Future.delayed(Duration(milliseconds: 2450));
      if (HiveStore.appBox!.get('privacy_init') == null) {
        bool agreeResult = (await launchPrivacyDialog(context)) ?? false;
        if (!agreeResult) {
          //第1次不同意`
          bool secondAgree =
              (await (launchPrivacySecondDialog(context) )) ?? false;
          //第2次不同意
          if (!secondAgree)
            initDate();
          else{
            HiveStore.appBox!.put('privacy_init', true);
            initAgreeDate();
            initDate();
          }
        } else{
          HiveStore.appBox!.put('privacy_init', true);
          initAgreeDate();
          initDate();
        }
      }else{
        initDate();
      }
    });
  }

  initDate()async{
    BytedeskKefu.init(Platform.isAndroid?AppConfig.LBS_ANDROID_KEY:AppConfig.LBS_ANDROID_KEY,AppConfig.LBS_SUBDOMAIN);
    Get.offAll(WelcomeWidget());
  }

  initAgreeDate(){
    AMapFlutterLocation.setApiKey(
        AppConfig.MAP_ANDROID_KEY,  AppConfig.MAP_IOS_KEY);
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
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
