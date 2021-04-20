import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/manager/user_manager.dart';

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

class _AccountAndSafetyPageState extends BaseStoreState<AccountAndSafetyPage> {
  bool secureValue = false;
  @override
  void initState() {
    super.initState();
    secureValue = UserManager.instance.userBrief.secretValue;
  }

  Future updateProfile() async {
    await UserManager.instance.updateUserBriefInfo(getStore()).then((success) {
      if (success) {
        if (UserManager.instance.user.info.roleLevel !=
            getStore().state.userBrief.roleLevel) {
          UserManager.instance.user.info.roleLevel =
              getStore().state.userBrief.roleLevel;
          UserManager.instance.refreshUserRole.value =
              !UserManager.instance.refreshUserRole.value;
          UserManager.updateUserInfo(getStore());
        }
      }
    });
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
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
            padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 6.rw),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () async {
              await _updateSwitchState();
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '手机号显示开关'.text.black.size(15.rsp).make(),
                    '关闭后，其他人将无法看到您的手机号'
                        .text
                        .size(12.rsp)
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
      {'secret': secureValue ? 1 : 0},
    );
    await updateProfile();
    cancel();
    ReToast.success(text: secureValue ? '已开启' : '已关闭');
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
