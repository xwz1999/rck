import 'dart:async';
import 'dart:io';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/message/message_ceter_page.dart';
import 'package:recook/pages/user/functions/user_func.dart';
import 'package:recook/pages/welcome/welcome_widget.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:power_logger/power_logger.dart';
import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'launch_privacy_dialog.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

List<CameraDescription>? cameras;

class LaunchWidget extends StatefulWidget {
  @override
  _LaunchWidgetState createState() => _LaunchWidgetState();
}

class _LaunchWidgetState extends BaseStoreState<LaunchWidget>
    with SingleTickerProviderStateMixin {
  final JPush jpush = new JPush();
  String? debugLable = 'Unknown';
  @override
  void initState() {
    super.initState();

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

      UserManager.instance!.kingCoinListModelList =
      await UserFunc.getKingCoinList();
      PowerLogger.start(context, debug:AppConfig.debug!);//AppConfig.debug!  在正式服数据下进行调试\
      Get.offAll(WelcomeWidget());
  }

  initAgreeDate(){
    AMapFlutterLocation.setApiKey(
        AppConfig.MAP_ANDROID_KEY,  AppConfig.MAP_IOS_KEY);
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    //初始化日志工具
    initPlatformState();

    BytedeskKefu.init(Platform.isAndroid?AppConfig.LBS_ANDROID_KEY:AppConfig.LBS_ANDROID_KEY,AppConfig.LBS_SUBDOMAIN);
  }

  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {


            print("jpush: $message");
            // setState(() {
            //   debugLable = "flutter onReceiveNotification: $message";
            // });

          }, onOpenNotification: (Map<String, dynamic> message) async {

        print("jpush: $message");


        Get.to(() => MessageCenterPage(canback: true,));

        // print("flutter onOpenNotification: $message");
        // setState(() {
        //   debugLable = "flutter onOpenNotification: $message";
        // });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
          (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "2dba4439e97b3c0b78146fab", //你自己应用的 AppKey
      channel: "developer-default",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
    jpush.getRegistrationID().then((rid)  {
      print("flutter get registration id : $rid");
      UserManager.instance!.jpushRid = rid;

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
