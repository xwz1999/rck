import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/sc_tile.dart';

class AccountAndSafetyPage extends StatefulWidget {
  AccountAndSafetyPage({Key key}) : super(key: key);

  @override
  _AccountAndSafetyPageState createState() => _AccountAndSafetyPageState();
}

class _AccountAndSafetyPageState extends State<AccountAndSafetyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        title: Text(
          '账户与安全',
          style: TextStyle(
            color: AppColor.blackColor,
          ),
        ),
        themeData: AppBarTheme(brightness: Brightness.light),
        leading: _backButton(context),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: rSize(16)),
        children: [
          SCTile.normalTile("支付密码设置", listener: () {
            // push(RouteName.USER_SET_PASSWORD);
            AppRouter.push(context, RouteName.USER_SET_PASSWORD_VARCODE);
          }),
          SCTile.normalTile("注销账户", listener: () {
            // push(RouteName.USER_SET_PASSWORD);
            AppRouter.push(context, RouteName.USER_DELETE_ACCOUNT_PAGE);
          }),
        ],
      ),
    );
  }

  _backButton(context) {
    if (Navigator.canPop(context)) {
      return IconButton(
          icon: Icon(
            AppIcons.icon_back,
            size: 17,
            color: AppColor.blackColor,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          });
    } else
      return SizedBox();
  }
}
