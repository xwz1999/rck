/*
 * ====================================================
 * package   : pages.login
 * author    : Created by nansi.
 * time      : 2019/5/15  1:30 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/daos/user_dao.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/sc_dialog.dart';
import 'package:recook/widgets/text_button.dart' as TButton;
import 'package:recook/widgets/toast.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhoneLoginPageState();
  }
}

class _PhoneLoginPageState extends BaseStoreState<PhoneLoginPage> {
  TextEditingController _phoneController;
  TextEditingController _smsCodeController;
  FocusNode _phoneNode;
  FocusNode _smsCodeNode;

  Timer _timer;
  String _countDownStr = "获取验证码";
  int _countDownNum = 59;
  bool _getCodeEnable = false;
  bool _loginEnable = false;
  String _errorMsg = "";
  bool _cantSelected = false;
  @override
  void initState() {
    super.initState();

    if (AppConfig.debug) {
      _smsCodeController = TextEditingController(text: "0520");
      _phoneController = TextEditingController(text: "18906611076");
      _loginEnable = true;
      _getCodeEnable = true;
    } else {
      _phoneController = TextEditingController();
      _smsCodeController = TextEditingController();
    }

    _phoneNode = FocusNode();
    _smsCodeNode = FocusNode();
  }

  @override
  void dispose() {
    _phoneController?.dispose();
    _smsCodeController?.dispose();
    _phoneNode?.dispose();
    _smsCodeNode?.dispose();

    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "手机登录",
          themeData: AppThemes.themeDataGrey.appBarTheme,
          elevation: 0.2,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: rSize(20),
                  margin: EdgeInsets.only(
                      top: rSize(60), right: rSize(20), left: rSize(20)),
                  child: Text(
                    _errorMsg,
                    style: AppTextStyle.generate(ScreenAdapterUtils.setSp(14),
                        color: Colors.red),
                  ),
                ),
                _phoneText(),
                _smsCode(),
                _bottomOperation(),
                _loginButton(context)
              ],
            ),
          ),
        ));
  }

  Container _phoneText() {
    return Container(
      margin:
          EdgeInsets.only(top: rSize(10), right: rSize(20), left: rSize(20)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500], width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: TextField(
        controller: _phoneController,
        focusNode: _phoneNode,
        keyboardType: TextInputType.number,
        style: TextStyle(
            color: Colors.black, fontSize: ScreenAdapterUtils.setSp(16)),
        inputFormatters: [
          LengthLimitingTextInputFormatter(11),
        ],
        cursorColor: Colors.black,
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
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                left: rSize(10),
                top: rSize(13),
                bottom: _phoneNode.hasFocus ? 0 : rSize(14)),
            border: InputBorder.none,
            hintText: "请输入手机号",
            hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: ScreenAdapterUtils.setSp(15)),
            suffixIcon: _clearButton(_phoneController, _phoneNode)),
      ),
    );
  }

  IconButton _clearButton(TextEditingController controller, FocusNode node) {
    return node.hasFocus
        ? IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              AppIcons.icon_clear,
              size: ScreenAdapterUtils.setSp(17),
              color: Colors.grey[300],
            ),
            onPressed: () {
              controller.clear();
            })
        : null;
  }

  /// 验证码
  Container _smsCode() {
    return Container(
      margin:
          EdgeInsets.only(top: rSize(20), right: rSize(20), left: rSize(20)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[500], width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(3))),
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
              focusNode: _smsCodeNode,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenAdapterUtils.setSp(16)),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: rSize(10),
                      top: rSize(13),
                      bottom: _smsCodeNode.hasFocus ? 0 : rSize(14)),
                  border: InputBorder.none,
                  hintText: "请输入验证码",
                  hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: ScreenAdapterUtils.setSp(14)),
                  suffixIcon: _clearButton(_smsCodeController, _smsCodeNode)),
            ),
          ),
          TButton.TextButton(
            title: _countDownStr,
            width: rSize(120),
            textColor: Colors.grey[700],
            enable: _getCodeEnable,
            font: ScreenAdapterUtils.setSp(15),
            unableTextColor: Colors.grey[400],
            highlightTextColor: Colors.grey[400],
            border: Border(left: BorderSide(color: Colors.grey[500])),
            onTap: () {
              if (!TextUtils.verifyPhone(_phoneController.text)) {
                showError("手机号码格式不正确!");
                return;
              }
              if (_cantSelected) return;
              _cantSelected = true;
              Future.delayed(Duration(seconds: 2), () {
                _cantSelected = false;
              });
              GSDialog.of(context).showLoadingDialog(context, "正在发送..");
              _getSmsCode(context);
            },
          ),
        ],
      ),
    );
  }

  Container _bottomOperation() {
    return Container(
      margin: EdgeInsets.only(
          top: rSize(15), left: rSize(15), right: rSize(8), bottom: rSize(100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // TextButton(
          //   title: "如何注册？",
          //   textColor: Colors.grey[500],
          //   font: ScreenAdapterUtils.setSp(14),
          //   highlightTextColor: Colors.grey[400],
          //   onTap: () {},
          // ),
          TButton.TextButton(
            title: "收不到验证码？",
            font: ScreenAdapterUtils.setSp(14),
            textColor: Colors.grey[500],
            highlightTextColor: Colors.grey[400],
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// 登录按钮
  TButton.TextButton _loginButton(BuildContext context) {
    return TButton.TextButton(
      height: 45,
      title: "登录",
      textColor: Colors.white,
      unableBackgroundColor: Colors.grey[300],
      font: ScreenAdapterUtils.setSp(17),
      enable: _loginEnable,
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: rSize(7)),
      radius: BorderRadius.all(Radius.circular(5)),
      backgroundColor: Theme.of(context).primaryColor,
      onTap: () {
        GSDialog.of(context).showLoadingDialog(context, "正在登录...");
        _phoneLogin(context);
      },
    );
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

  _verifyLoginEnable() {
    if (!TextUtils.verifyPhone(_phoneController.text)) {
      setState(() {
        _errorMsg = "手机号格式不正确,请检查";
      });
      return false;
    }
    return _smsCodeController.text.length == 4;
  }

  /*
    获取验证码
   */
  _getSmsCode(_content) {
    UserDao.sendSmsCode(_phoneController.text, success: (data, code, msg) {
      GSDialog.of(_content).dismiss(_content);
      Toast.showSuccess("验证码发送成功，请注意查收");
      _beginCountDown();
      FocusScope.of(_content).requestFocus(_smsCodeNode);
    }, failure: (code, error) {
      GSDialog.of(_content).dismiss(_content);
      Toast.showError(error);
    });
  }

  /*
    手机登录
   */
  _phoneLogin(BuildContext context) {
    UserDao.phoneLogin(_phoneController.text, _smsCodeController.text,
        success: (data, code, msg) {
      GSDialog.of(context).dismiss(context);
      if (data.status == 0) {
        _phoneRegister(context);
        return;
        // AppRouter.push(context, RouteName.INPUT_INVITATION, arguments: InvitationCodePage.setArgs(mobile: _phoneController.text));
      } else {
        // DPrint.printf(" 转化的json ---- " + json.encode(data.toJson()));
        // AppRouter.pushAndRemoveUntil(context, RouteName.TAB_BAR);
        AppRouter.fadeAndRemoveUntil(context, RouteName.TAB_BAR);
        UserManager.updateUser(data, getStore());
      }
    }, failure: (code, msg) {
      GSDialog.of(context).dismiss(context);
      Toast.showError(msg);
    });
  }

  _phoneRegister(BuildContext context) {
    GSDialog.of(context).showLoadingDialog(context, "正在登录...");
    UserDao.phoneRegister(_phoneController.text, "000000",
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
