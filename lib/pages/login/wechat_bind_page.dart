import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/daos/user_dao.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/login/wechat_input_invitecode_page.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/text_button.dart' as TButton;
import 'package:jingyaoyun/widgets/toast.dart';

class WeChatBindPage extends StatefulWidget {
  static const String KEY_wxUnionId = "wxUnionId";
  final Map argument;
  WeChatBindPage({this.argument}) : assert(argument != null, "argument 不能为空");
  static setArgument(a) {
    return {KEY_wxUnionId: a};
  }

  @override
  State<StatefulWidget> createState() {
    return _WeChatBindPageState();
  }
}

class _WeChatBindPageState extends BaseStoreState<WeChatBindPage> {
  double _fontSize = 15 * 2.sp;

  FocusNode _phoneFocusNode;
  FocusNode _smsCodeFocusNode;
  // FocusNode _inviteCodeFocusNode;
  TextEditingController _phoneController;
  TextEditingController _smsCodeController;
  TextEditingController _inviteCodeController;

  bool _loginEnable = false;
  bool _cantSelected = false;
  bool _getCodeEnable = false;
  Timer _timer;
  String _countDownStr = "获取验证码";
  int _countDownNum = 59;

  String _errorMsg = "";

  @override
  void initState() {
    super.initState();
    _phoneFocusNode = FocusNode();
    _smsCodeFocusNode = FocusNode();
    // _inviteCodeFocusNode = FocusNode();

    _phoneController = TextEditingController();
    _smsCodeController = TextEditingController();
    // _inviteCodeController = TextEditingController();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              primary: true,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  _titleWidget(),
                  _phoneTFWidget(),
                  _smsCodeWidget(),
                  // _inviteWidget(),
                  Container(
                    height: 50 * 2.h,
                  ),
                  _loginBtnWidget(),
                  _messageWidget(),
                ],
              ),
            )),
      ),
    );
  }

  _titleWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      height: 80,
      child: Text(
        '手机号绑定',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 25 * 2.sp),
      ),
    );
  }

  _phoneTFWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: rSize(20)),
      height: 40 * 2.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "+86",
                  style: TextStyle(
                      fontSize: _fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black54,
                  size: 22,
                ),
                Container(
                  width: 7,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (String phone) {
                      setState(() {
                        if (phone.length >= 11) {
                          _getCodeEnable = true;
                          _loginEnable = _verifyLoginEnable();
                        } else {
                          _errorMsg = "";
                          _getCodeEnable = false;
                          _loginEnable = false;
                        }
                      });
                    },
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black, fontSize: _fontSize),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                    ],
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(
                      //     left: rSize(10), top: rSize(13)),
                      border: InputBorder.none,
                      hintText: "请输入手机号",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[400],
                          fontSize: _fontSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _bottomLineWidget(),
        ],
      ),
    );
  }

  _verifyLoginEnable() {
    if (!TextUtils.verifyPhone(_phoneController.text)) {
      setState(() {
        _errorMsg = "手机号格式不正确,请检查";
      });
      return false;
    }
    return _smsCodeController.text.length == 4;
  }

  _smsCodeWidget() {
    return Container(
      height: 40 * 2.h,
      margin: EdgeInsets.symmetric(horizontal: rSize(20)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                    ],
                    onChanged: (text) {
                      setState(() {
                        _loginEnable = _verifyLoginEnable();
                      });
                    },
                    controller: _smsCodeController,
                    // focusNode: _smsCodeNode,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w300),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "请输入验证码",
                      hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: _fontSize,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                TButton.TextButton(
                  title: _countDownStr,
                  // title: '获取验证码',
                  // width: rSize(120),
                  textColor: Colors.black,
                  enable: _getCodeEnable,
                  font: 13 * 2.sp,
                  fontWeight: FontWeight.w300,
                  unableTextColor: Colors.grey,
                  highlightTextColor: Colors.black,
                  onTap: () {
                    if (_cantSelected) return;
                    _cantSelected = true;
                    Future.delayed(Duration(seconds: 2), () {
                      _cantSelected = false;
                    });
                    GSDialog.of(context).showLoadingDialog(context, "正在发送..");
                    _getSmsCode();
                  },
                ),
              ],
            ),
          ),
          _bottomLineWidget(),
        ],
      ),
    );
  }

  /*
    获取验证码
   */
  _getSmsCode() {
    UserDao.sendSmsCode(_phoneController.text, success: (data, code, msg) {
      GSDialog.of(context).dismiss(context);
      Toast.showSuccess("验证码发送成功，请注意查收");
      _beginCountDown();
      FocusScope.of(context).requestFocus(_smsCodeFocusNode);
    }, failure: (code, error) {
      GSDialog.of(context).dismiss(context);
      Toast.showError(error);
    });
  }

  _beginCountDown() {
    setState(() {
      _getCodeEnable = false;
      _countDownStr = "重新获取($_countDownNum)";
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timer == null || !mounted) {
        return;
      }
      setState(() {
        if (_countDownNum == 0) {
          _countDownNum = 59;
          _countDownStr = "获取验证码";
          _getCodeEnable = true;
          _timer.cancel();
          _timer = null;
          return;
        }
        _countDownStr = "重新获取(${_countDownNum--})";
      });
    });
  }

  // _inviteWidget() {
  //   return Container(
  //     height: 40 * 2.h,
  //     margin: EdgeInsets.symmetric(horizontal: rSize(20)),
  //     child: Column(
  //       children: <Widget>[
  //         Expanded(
  //           child: Row(
  //             children: <Widget>[
  //               Expanded(
  //                 child: _inviteInputWidget(),
  //               ),
  //             ],
  //           ),
  //         ),
  //         _bottomLineWidget(),
  //       ],
  //     ),
  //   );
  // }

  // _inviteInputWidget() {
  //     return TextField(
  //       onChanged: (String phone) {
  //         setState(() {
  //           _loginEnable = _verifyLoginEnable();
  //         });
  //       },
  //       controller: _inviteCodeController,
  //       focusNode: _inviteCodeFocusNode,
  //       keyboardType: TextInputType.emailAddress,
  //       style: TextStyle(color: Colors.black, fontSize: _fontSize),
  //       inputFormatters: [
  //         LengthLimitingTextInputFormatter(8),
  //       ],
  //       cursorColor: Colors.black,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: "邀请码（选填）",
  //         hintStyle: TextStyle(
  //             fontWeight: FontWeight.w300,
  //             color: Colors.grey[400],
  //             fontSize: _fontSize),
  //       ),
  //     );
  //
  // }

  _loginBtnWidget() {
    return Container(
      child: TButton.TextButton(
        title: '登录',
        textColor: Colors.white,
        unableBackgroundColor: Colors.grey[300],
        font: 16 * 2.sp,
        enable: _loginEnable,
        // height: 35*2.h,
        margin: EdgeInsets.symmetric(horizontal: rSize(20)),
        padding: EdgeInsets.symmetric(vertical: rSize(7)),
        radius: BorderRadius.all(Radius.circular(3)),
        backgroundColor: Theme.of(context).primaryColor,
        onTap: () {
          GSDialog.of(context).showLoadingDialog(context, "正在登录...");
          _weChatRegister(context);
        },
      ),
    );
  }

  _messageWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: rSize(20), vertical: 12 * 2.h),
      child: Text(
        '根据《中华人民共和国网络安全法》要求,使用信息发布、即时通讯等互联网服务需进行身份信息验证。为保障您的使用体验,建议您尽快完成手机号绑定验证,感谢您的支持和理解。',
        style: TextStyle(
            color: Colors.black.withOpacity(0.6), fontSize: 13 * 2.sp),
      ),
    );
  }

  _bottomLineWidget() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.1),
    );
  }

  _weChatRegister(BuildContext context) {
    String bindData = getStore().state.openinstall.code;
    // if (bindData.length <= 0) {
    //   bindData = _inviteCodeController.text.toUpperCase();
    // }
    UserDao.weChatRegister(
        widget.argument[WeChatBindPage.KEY_wxUnionId],
        _phoneController.text,
        _smsCodeController.text, success: (data, code, msg) {
      GSDialog.of(context).dismiss(context);
      if (data.status == 0) {
        _weChatRegisterWithInviteCode(context);
        // AppRouter.push(context,
        //   RouteName.WECHAT_INPUT_INVITATION,
        //   arguments: WeChatInputInviteCodePage.setArgument(widget.argument[WeChatBindPage.KEY_wxUnionId]));
      } else {
        AppRouter.pushAndRemoveUntil(context, RouteName.TAB_BAR);
        UserManager.updateUser(data, getStore());
      }
    }, failure: (code, msg) {
      GSDialog.of(context).dismiss(context);
      Toast.showError(msg);
    });
  }

  _weChatRegisterWithInviteCode(BuildContext context) {
    GSDialog.of(context).showLoadingDialog(context, "正在登录...");
    String bindData = getStore().state.openinstall.code;
    UserDao.weChatInvitation(
        widget.argument[WeChatInputInviteCodePage.KEY_wxUnionId], '',
        success: (data, code, msg) {
      GSDialog.of(context).dismiss(context);
      AppRouter.pushAndRemoveUntil(context, RouteName.TAB_BAR);
      UserManager.updateUser(data, getStore());
    }, failure: (code, msg) {
      GSDialog.of(context).dismiss(context);
      Toast.showError(msg);
    });
  }
}
