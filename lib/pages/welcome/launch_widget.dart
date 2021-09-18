/*
 * ====================================================
 * package   : pages.welcome
 * author    : Created by nansi.
 * time      : 2019/5/5  4:47 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:power_logger/power_logger.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/config.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/welcome/launch_privacy_dialog.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/storage/hive_store.dart';

class LaunchWidget extends StatefulWidget {
  @override
  _LaunchWidgetState createState() => _LaunchWidgetState();
}

class _LaunchWidgetState extends BaseStoreState<LaunchWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    PowerLogger.start(context, debug: true);//京东测试
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await Future.delayed(Duration(milliseconds: 2450));
      if (HiveStore.appBox.get('privacy_init') == null) {
        // if (true) {
        bool agreeResult = (await launchPrivacyDialog(context)) ?? false;
        if (!agreeResult) {
          //第1次不同意
          bool secondAgree =
              (await launchPrivacySecondDialog(context)) ?? false;
          //第2次不同意
          if (!secondAgree)
            SystemNavigator.pop();
          else
            HiveStore.appBox.put('privacy_init', true);
        } else
          HiveStore.appBox.put('privacy_init', true);
      }
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
