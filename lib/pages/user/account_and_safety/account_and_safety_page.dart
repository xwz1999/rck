import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/user_model.dart';
import 'package:jingyaoyun/pages/user/functions/user_func.dart';
import 'package:jingyaoyun/third_party/wechat/wechat_utils.dart';
import 'package:jingyaoyun/utils/storage/hive_store.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/sc_tile.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountAndSafetyPage extends StatefulWidget {
  AccountAndSafetyPage({Key key}) : super(key: key);

  @override
  _AccountAndSafetyPageState createState() => _AccountAndSafetyPageState();
}

class _AccountAndSafetyPageState extends BaseStoreState<AccountAndSafetyPage> {
  bool secureValue = false;
  bool _weChatLoginLoading = false;
  String _backgroundUrl;
  int _goodsId = 0;
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
          '???????????????',
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
          SCTile.normalTile("??????????????????", needDivide: true, listener: () {
            // push(RouteName.USER_SET_PASSWORD);
            AppRouter.push(context, RouteName.USER_SET_PASSWORD_VARCODE);
          }),
          SCTile.normalTile("????????????", needDivide: true, listener: () {
            AppRouter.push(context, RouteName.USER_DELETE_ACCOUNT_PAGE);
          }),
          SCTile.normalTile(
              TextUtils.isEmpty(UserManager.instance.user.info.wxUnionId)
                  ? "????????????"
                  : "????????????",
              value: TextUtils.isEmpty(UserManager.instance.user.info.wxUnionId)
                  ? ''
                  : UserManager.instance.user.info.nickname, listener: () {
            TextUtils.isEmpty(UserManager.instance.user.info.wxUnionId)
                ? _wechatBindinghandle()
                : _wechatUnboundhandle();
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
                    '?????????????????????'.text.black.size(15.rsp).make(),
                    '???????????????????????????????????????????????????'
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

  _wechatBindinghandle() {
    DPrint.printf("????????????");
    if (!WeChatUtils.isInstall) {
      showError("???????????????????????????????????????");
      return;
    }
    GSDialog.of(context).showLoadingDialog(context, "??????????????????...");
    WeChatUtils.wxLogin((WXLoginResult result) {
      if (result.errCode == -2) {
        Toast.showInfo('??????????????????');
        GSDialog.of(context).dismiss(context);
      } else if (result.errCode != 0) {
        GSDialog.of(context).dismiss(context);
        Toast.showInfo(result.errStr);
      } else {
        if (!_weChatLoginLoading) {
          _weChatLoginLoading = true;
          print(result.code);
          _weChatLogin(result.code);
        }
      }
    });
    GSDialog.of(context).dismiss(context);
  }

  _wechatUnboundhandle() async {
    DPrint.printf("????????????");
    if (!WeChatUtils.isInstall) {
      showError("???????????????????????????????????????");
      return;
    }
    Alert.show(
        context,
        NormalTextDialog(
          title: '????????????',
          type: NormalTextDialogType.delete,
          content: "??????????????????????????????",
          items: ["??????"],
          listener: (index) {
            Alert.dismiss(context);
          },
          deleteItem: "??????",
          deleteListener: () async {
            Alert.dismiss(context);
            String code = await UserFunc.wechatUnboundhandle();
            if (code == 'SUCCESS') {
              ReToast.success(text: '????????????');
              //??????????????????
              UserManager.instance.user.info.wxUnionId = '';
              UserManager.instance.user.info.wxOpenId = '';
              String jsonStr = json.encode(UserManager.instance.user.toJson());
              HiveStore.appBox.put('key_user', jsonStr);
              //_getLaunchInfo();
              setState(() {});
            } else {
              ReToast.err(text: '????????????');
            }
          },
        ));
  }

  _weChatLogin(String code) async {
    GSDialog.of(context).showLoadingDialog(context, "?????????...");
    ResultData resultData = await HttpManager.post(UserApi.wx_binding,
        {'userId': UserManager.instance.user.info.id, 'code': code});
    GSDialog.of(context).dismiss(context);

    _weChatLoginLoading = false;
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    UserModel model = UserModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    UserManager.updateUser(model.data, getStore());
    setState(() {});
    showSuccess('????????????!');
  }

  _updateSwitchState() async {
    final cancel = ReToast.loading(text: '?????????');
    secureValue = !secureValue;
    await HttpManager.post(
      APIV2.userAPI.securePhone,
      {'secret': secureValue ? 1 : 0},
    );
    await updateProfile();
    cancel();
    ReToast.success(text: secureValue ? '?????????' : '?????????');
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
