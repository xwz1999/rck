import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
// import 'package:android_intent_plus/android_intent.dart';
import 'package:recook/pages/user/user_info_page.dart';
import 'package:recook/utils/android_back_desktop.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/sc_tile.dart';
import 'package:recook/widgets/webView.dart';
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

class _SettingItemListViewState extends State<SettingItemListView> with WidgetsBindingObserver {
  PackageInfo? _packageInfo;
  String perText = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    JPush().isNotificationEnabled().then((bool value) {
      if (value)
        perText = '已开启';
      else
        perText = '已关闭';
    }).catchError((onError) {
      print(onError);
    });
    getPackageInfo();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
    //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:

          JPush().isNotificationEnabled().then((bool value) {
            if (value)
              perText = '已开启';
            else
              perText = '已关闭';

            setState(() {});
          }).catchError((onError) {
            print(onError);
          });

        print("应用进入前台======");
        break;
    //应用状态处于闲置状态，并且没有用户的输入事件，
    // 注意：这个状态切换到 前后台 会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        print("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        break;
    //当前页面即将退出
      case AppLifecycleState.detached:
        print("当前页面即将退出======");
        break;
    // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        print("应用处于不可见状态 后台======");
        break;
    }
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
                      SCTile.normalTile("个人资料", needDivide: true, listener: () async {
                        Get.to(UserInfoPage());
                      }),
                      SCTile.normalTile('账户与安全', needDivide: true,
                          listener: () {
                        Get.to(AccountAndSafetyPage());

                      }),

                      SCTile.normalTile('接收推送通知',
                          needArrow: true, value: perText, listener: () async {
                        JPush().openSettingsForNotification();
                        //bool result = await openAppSettings();

                        // JPush().isNotificationEnabled().then((bool value) {
                        //   if (value)
                        //     perText = '已开启';
                        //   else
                        //     perText = '已关闭';
                        //
                        //   setState(() {});
                        // }).catchError((onError) {
                        //   print(onError);
                        // });

                      }),
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
                      SCTile.normalTile("联系我们", value: '400-861-0321', needDivide: true, listener: () {
                        launchUrl(Uri(path: "tel:400-861-0321"));
                        //launch("tel:400-861-0321");
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
      height: height,
    );
  }
}
