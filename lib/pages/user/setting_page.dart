import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/sc_tile.dart';
import 'package:recook/widgets/webView.dart';

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

class _SettingItemListViewState extends BaseStoreState<SettingItemListView> {
  PackageInfo _packageInfo;
  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
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
                        push(RouteName.USER_INFO_PAGE);
                      }),
                      SCTile.normalTile('账户与安全',
                          needDivide: true, needArrow: true, listener: () {
                        push(RouteName.ACCOUNT_AND_SAFETY_PAGE);
                      }),
                      getEmptyBox(),
                      // SCTile.normalTile("清除缓存", needDivide: true, listener: () {}),
                      // SCTile.normalTile("意见反馈", needDivide: true, listener: () {
                      //   AppRouter.push(
                      //           context, RouteName.WEB_VIEW_PAGE, arguments: WebViewPage.setArguments(url: WebApi.feedback, title: "意见反馈"), );
                      // }),
                      SCTile.normalTile("关于我们", needDivide: true, listener: () {
                        AppRouter.push(context, RouteName.ABOUT_US_PAGE);
                        // AppRouter.push(
                        // context, RouteName.WEB_VIEW_PAGE, arguments: WebViewPage.setArguments(url: WebApi.aboutUs, title: "关于我们"), );
                      }),
                      SCTile.normalTile("隐私政策", listener: () {
                        AppRouter.push(
                          context,
                          RouteName.WEB_VIEW_PAGE,
                          arguments: WebViewPage.setArguments(
                              url: WebApi.privacy, title: "隐私政策"),
                        );
                      }),
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
