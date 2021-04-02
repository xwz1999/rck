import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/sc_tile.dart';

class AccountAndSafetyPage extends StatefulWidget {
  AccountAndSafetyPage({Key key}) : super(key: key);

  @override
  _AccountAndSafetyPageState createState() => _AccountAndSafetyPageState();
}

class _AccountAndSafetyPageState extends State<AccountAndSafetyPage> {
  bool secureValue = false;
  @override
  void initState() {
    super.initState();
    //TODO 初始化手机号显示开关数值
  }

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
          SCTile.normalTile("支付密码设置", needDivide: true, listener: () {
            // push(RouteName.USER_SET_PASSWORD);
            AppRouter.push(context, RouteName.USER_SET_PASSWORD_VARCODE);
          }),
          SCTile.normalTile("注销账户", listener: () {
            AppRouter.push(context, RouteName.USER_DELETE_ACCOUNT_PAGE);
          }),
          16.hb,
          MaterialButton(
            color: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.w),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () async {
              await _updateSwitchState();
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '手机号显示开关'.text.black.size(15.sp).make(),
                    '关闭后，其他人将无法看到您的手机号'
                        .text
                        .size(12.sp)
                        .color(Color(0xFF666666))
                        .make(),
                  ],
                ).expand(),
                CupertinoSwitch(
                  value: secureValue,
                  trackColor: Color(0xFFDB2D2D),
                  onChanged: (state) async {
                    await _updateSwitchState();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _updateSwitchState() async {
    final cancel = ReToast.loading(text: '修改中');
    secureValue = !secureValue;
    await HttpManager.post(
      APIV2.userAPI.securePhone,
      {'secure': secureValue ? 1 : 0},
    );
    cancel();
    ReToast.success(text: '修改成功');
    setState(() {});
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
