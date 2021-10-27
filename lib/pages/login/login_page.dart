/*
 * ====================================================
 * package   : pages
 * author    : Created by nansi.
 * time      : 2019/5/14  4:26 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/daos/user_dao.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/login/wechat_bind_page.dart';
import 'package:recook/third_party/wechat/wechat_utils.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/progress/sc_dialog.dart';
import 'package:recook/widgets/toast.dart';
import 'package:recook/widgets/webView.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends BaseStoreState<LoginPage> {
  BuildContext _context;
  bool _weChatLoginLoading = false;
  bool _hasInstallWeChat = false;
  bool _chooseAgreement = false;
  String debugLable = 'Unknown';
  @override
  initState() {
    super.initState();
    if (WeChatUtils.isInstall) {
      _hasInstallWeChat = true;
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    if (_context == null) _context = context;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Positioned(
                left: 10,
                top: ScreenUtil().statusBarHeight + 10,
                child: GestureDetector(
                  onTap: () {
                    AppRouter.fadeAndReplaced(globalContext, RouteName.TAB_BAR);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.chevron_left,
                        size: 22,
                        color: Colors.black.withOpacity(0.45),
                      ),
                      Text(
                        '跳过,看好货',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.55),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                right: 10,
                top: ScreenUtil().statusBarHeight + 10,
                child: GestureDetector(
                  onTap: () {
                    AppRouter.push(context, RouteName.PHONE_LOGIN);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '手机号登录',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.55),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )),
            _buildBody(context),
          ],
        ));
  }

  SafeArea _buildBody(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: rSize(70),
            height: rSize(70),
            margin: EdgeInsets.only(top: rSize(120)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 1.0 / 1.0,
                child:
                    Image.asset(AppImageName.recook_icon_120, fit: BoxFit.fill),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "享受指尖的购物乐趣",
                style:
                    AppTextStyle.generate(15 * 2.sp, color: Colors.grey[700]),
              )),
          Expanded(child: Container()),

          ///
          // _buildPhoneLogin(context),

          ///


          GestureDetector(
            onTap: () {
              _chooseAgreement = !_chooseAgreement;
              setState(() {});
            },
            child: Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 50.w,
                    height: 50.w,
                    padding: EdgeInsets.only(top: 6.w, right: 5.w),
                    child: !_chooseAgreement
                        ? Icon(CupertinoIcons.circle,
                            size: 18, color:Color(0xFFdddddd))
                        : Icon(CupertinoIcons.checkmark_circle,
                            size: 18, color: Colors.red)),
                RichText(
                    text: TextSpan(
                        text: "您已阅读并同意",
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 12 * 2.sp),
                        children: [
                      new TextSpan(
                          text: '《用户服务协议》',
                          style: new TextStyle(
                              color: Colors.black, fontSize: 12 * 2.sp),
                          recognizer: _recognizer(context, 2)),
                      TextSpan(
                        text: "和",
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 12 * 2.sp),
                      ),
                      new TextSpan(
                          text: '《用户隐私政策》',
                          style: new TextStyle(
                              color: Colors.black, fontSize: 12 * 2.sp),
                          recognizer: _recognizer(context, 1)),
                    ])),
              ],
            ),
          ),
          _buildWeChatLogin(),
          ///
          Container(
            height: 20,
          ),
        ],
      ),
    );
  }

  Container _buildWeChatLogin() {
    if (!_hasInstallWeChat) {
      return Container(height: 20);
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: rSize(44),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(rSize(44) / 2),
      ),
      child: MaterialButton(
        onPressed: () {
          if (_chooseAgreement) {
            DPrint.printf("微信登录");
            WeChatUtils.wxLogin((WXLoginResult result) {
              print(result);
              if (result.errCode == -2) {
                Toast.showInfo('用户取消登录');
              } else if (result.errCode != 0) {
                GSDialog.of(context).dismiss(_context);
                Toast.showInfo(result.errStr);
              } else {
                if (!_weChatLoginLoading) {
                  _weChatLoginLoading = true;
                  _weChatLogin(result.code);
                }
              }
            });
          } else {
            Alert.show(
                context,
                NormalContentDialog(
                  type: NormalTextDialogType.remind,
                  title: null,
                  content: Text(
                    '请您先阅读并同意《用户服务协议》和《用户隐私政策》',
                    style: TextStyle(color: Colors.black),
                  ),
                  items: ["确认"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                ));
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              AppIcons.icon_login_wechat,
              size: 25,
              color: Colors.white,
            ),
            Container(
              width: 5,
            ),
            Text(
              "微信登录",
              style: AppTextStyle.generate(17 * 2.sp,
                  fontWeight: FontWeight.w500, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Container _buildPhoneLogin(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: rSize(40),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[700], width: 0.7),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: MaterialButton(
        onPressed: () {
          AppRouter.push(context, RouteName.PHONE_LOGIN);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              AppIcons.icon_login_phone,
              size: 20,
              color: Colors.grey[700],
            ),
            Container(
              width: 5,
            ),
            Text(
              "手机登录",
              style: AppTextStyle.generate(15 * 2.sp, color: Colors.grey[700]),
            )
          ],
        ),
      ),
    );
  }

  _recognizer(context, int type) {
    final TapGestureRecognizer recognizer = new TapGestureRecognizer();
    recognizer.onTap = () {
      print("点击协议了");
      AppRouter.push(
        context,
        RouteName.WEB_VIEW_PAGE,
        arguments: WebViewPage.setArguments(
            url: type == 1 ? WebApi.privacy : WebApi.agreement,
            title: type == 1 ? "用户隐私政策" : "用户服务协议",
            hideBar: true),
      );
      //CRoute.push(context, PrivacyPageV2());
    };
    return recognizer;
  }

  _weChatLogin(String code) {
    GSDialog.of(context).showLoadingDialog(context, "登录中...");
    UserDao.weChatLogin(code, success: (user, code, msg) {
      GSDialog.of(context).dismiss(context);
      DPrint.printf("user.status ----------------- ${user.status}");
      _weChatLoginLoading = false;
      if (user.status == 0) {
        AppRouter.push(context, RouteName.WECHAT_BIND,
            arguments: WeChatBindPage.setArgument(user.info.wxUnionId));
        // AppRouter.push(context, RouteName.INPUT_INVITATION,
        //     arguments: InvitationCodePage.setArgs(
        //         mode: 1, userID: user.info.id, nickName: user.info.nickname));
      } else {
        AppRouter.pushAndRemoveUntil(context, RouteName.TAB_BAR);
        UserManager.updateUser(user, getStore());
      }
    }, failure: (code, msg) {
      GSDialog.of(context).dismiss(context);
      _weChatLoginLoading = false;
      // Toast.showError(msg);
    });
  }
}
