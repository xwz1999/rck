import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/user_info_page.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/bussiness_cooperation_page.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/sc_tile.dart';
import 'package:jingyaoyun/widgets/webView.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account_and_safety/account_and_safety_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "设置",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: SettingItemListView(),
    );
  }
}

class SettingItemListView extends StatefulWidget {
  @override
  _SettingItemListViewState createState() => _SettingItemListViewState();
}

class _SettingItemListViewState extends State<SettingItemListView> {
  PackageInfo _packageInfo;
  String perText = '';
  @override
  void initState() {
    super.initState();
  //   JPush().isNotificationEnabled().then((bool value) {
  //     if (value)
  //       perText = '已开启';
  //     else
  //       perText = '已关闭';
  //   }).catchError((onError) {
  //     print(onError);
  //   });
    getPackageInfo();
  }

  @override
  void onResume() {
    // // Implement your code inside here
    // Future.delayed(Duration(milliseconds: 300), () {
    //   JPush().isNotificationEnabled().then((bool value) {
    //     if (value)
    //       perText = '已开启';
    //     else
    //       perText = '已关闭';
    //   }).catchError((onError) {
    //     print(onError);
    //   });
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColor.frenchColor,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      getEmptyBox(),
                      SCTile.normalTile("个人资料", needDivide: true, listener: () {
                        Get.to(UserInfoPage());
                        //push(RouteName.USER_INFO_PAGE);
                      }),
                      SCTile.normalTile('账户与安全', needDivide: true,
                          listener: () {
                        Get.to(AccountAndSafetyPage());

                        //push(RouteName.ACCOUNT_AND_SAFETY_PAGE);
                      }),

                      // SCTile.normalTile('接收推送通知',
                      //     needArrow: true, value: perText, listener: () async {
                      //   JPush().openSettingsForNotification();
                      //   //bool result = await openAppSettings();
                      //
                      //   JPush().isNotificationEnabled().then((bool value) {
                      //     if (value)
                      //       perText = '已开启';
                      //     else
                      //       perText = '已关闭';
                      //   }).catchError((onError) {
                      //     print(onError);
                      //   });
                      //   setState(() {});
                      // }),
                      getEmptyBox(),
                      // SCTile.normalTile("清除缓存", needDivide: true, listener: () {}),
                      // SCTile.normalTile("意见反馈", needDivide: true, listener: () {
                      //   AppRouter.push(
                      //           context, RouteName.WEB_VIEW_PAGE, arguments: WebViewPage.setArguments(url: WebApi.feedback, title: "意见反馈"), );
                      // }),
                      SCTile.normalTile("隐私政策", needDivide: true, listener: () {
                        AppRouter.push(
                          context,
                          RouteName.WEB_VIEW_PAGE,
                          arguments: WebViewPage.setArguments(
                              url: WebApi.privacy,
                              title: "隐私政策",
                              hideBar: true),
                        );
                        //CRoute.push(context, PrivacyPageV2());
                      }),
                      SCTile.normalTile("联系我们", value: '400-889-4489', needDivide: true, listener: () {
                        launch("tel:400-889-4489");
                      }),


                      //助力临时入口
                      // SCTile.normalTile("助力(临时)", listener: () async {
                      //
                      //
                      //     Get.to(() => BooStingActivityPage());
                      //
                      //
                      //   //CRoute.push(context, PrivacyPageV2());
                      // }),

                      // SCTile.normalTile("秒杀(临时)", listener: () async {
                      //
                      //
                      //   Get.to(() => SeckillActivityPage());
                      //
                      //
                      //   //CRoute.push(context, PrivacyPageV2());
                      // }),

                      getEmptyBox(),
                      SCTile.normalTile("退出登录", listener: () {
                        _loginOut(context);
                      }),
                    ],
                  ),
                ),
              ),
              Container(
                  child: SafeArea(
                bottom: true,
                child: Text(
                  "当前版本: ${_packageInfo?.version ?? ""}",
                  style: TextStyle(color: Colors.black),
                ),
              ))
            ],
          ),
        ));
  }

  getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  _loginOut(BuildContext context) {
    Alert.show(
        context,
        NormalTextDialog(
          title: "退出登录",
          content: "退出后将清空您的个人信息，确定要退出吗？",
          items: ["确认退出", "取消"],
          listener: (int index) {
            Alert.dismiss(context);
            if (index == 0) {
              UserManager.logout();
            }
          },
        ));
  }

  Widget getEmptyBox({double height = 16}) {
    return SizedBox(
      width: double.infinity,
      height: ScreenAdapterUtils.setWidth(height),
    );
  }
}
