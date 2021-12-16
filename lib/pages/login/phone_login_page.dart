/*
 * ====================================================
 * package   : pages.login
 * author    : Created by nansi.
 * time      : 2019/5/15  1:30 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/daos/user_dao.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/welcome/privacy_page_v2.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/progress/sc_dialog.dart';
import 'package:recook/widgets/text_button.dart' as TButton;
import 'package:recook/widgets/toast.dart';
import 'package:recook/widgets/webView.dart';

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

  bool _chooseAgreement = false;
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
      _smsCodeController = TextEditingController(text: "0716");
      _phoneController = TextEditingController(text: "18906611076");
      _loginEnable = true;
      _getCodeEnable = true;
    } else {
      _phoneController = TextEditingController();
      _smsCodeController = TextEditingController();
      _smsCodeController = TextEditingController(text: "0716");
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: rSize(20),
                  margin: EdgeInsets.only(
                      top: rSize(60), right: rSize(20), left: rSize(20)),
                  child: Text(
                    _errorMsg,
                    style: AppTextStyle.generate(14 * 2.sp, color: Colors.red),
                  ),
                ),
                _phoneText(),
                _smsCode(),
                _bottomOperation(),
                120.hb,
                // GestureDetector(
                //   onTap: () {
                //     _chooseAgreement = !_chooseAgreement;
                //     setState(() {});
                //   },
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //           width: 50.w,
                //           height: 50.w,
                //           padding: EdgeInsets.only(top: 6.w, right: 5.w),
                //           child: !_chooseAgreement
                //               ? Icon(CupertinoIcons.circle,
                //               size: 18, color: Color(0xFFdddddd))
                //               : Icon(CupertinoIcons.checkmark_circle,
                //               size: 18 , color: Colors.red)),
                //       RichText(
                //           text: TextSpan(
                //               text: "您已阅读并同意",
                //               style: TextStyle(
                //                   color: Colors.grey[500], fontSize: 12 * 2.sp),
                //               children: [
                //                 new TextSpan(
                //                     text: '《用户服务协议》',
                //                     style: new TextStyle(
                //                         color: Colors.black, fontSize: 12 * 2.sp),
                //                     recognizer: _recognizer(context, 2)),
                //                 TextSpan(
                //                   text: "和",
                //                   style: TextStyle(
                //                       color: Colors.grey[500], fontSize: 12 * 2.sp),
                //                 ),
                //                 new TextSpan(
                //                     text: '《用户隐私政策》',
                //                     style: new TextStyle(
                //                         color: Colors.black, fontSize: 12 * 2.sp),
                //                     recognizer: _recognizer(context, 1)),
                //               ])),
                //     ],
                //   ),
                // ),
                40.hb,
                _loginButton(context),


              ],
            ),
          ),
        ));
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
        style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
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
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15 * 2.sp),
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
              size: 17 * 2.sp,
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
              style: TextStyle(color: Colors.black, fontSize: 16 * 2.sp),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: rSize(10),
                      top: rSize(13),
                      bottom: _smsCodeNode.hasFocus ? 0 : rSize(14)),
                  border: InputBorder.none,
                  hintText: "请输入验证码",
                  hintStyle:
                      TextStyle(color: Colors.grey[400], fontSize: 14 * 2.sp),
                  suffixIcon: _clearButton(_smsCodeController, _smsCodeNode)),
            ),
          ),
          TButton.TextButton(
            title: _countDownStr,
            width: rSize(120),
            textColor: Colors.grey[700],
            enable: _getCodeEnable,
            font: 15 * 2.sp,
            unableTextColor: Colors.grey[400],
            highlightTextColor: Colors.grey[400],
            border: Border(left: BorderSide(color: Colors.grey[500])),
            onTap: () {
              // if (!_chooseAgreement) {
              //   if (!TextUtils.verifyPhone(_phoneController.text)) {
              //     showError("手机号码格式不正确!");
              //     return;
              //   }
              //   if (_cantSelected) return;
              //   _cantSelected = true;
              //   Future.delayed(Duration(seconds: 2), () {
              //     _cantSelected = false;
              //   });
              //   GSDialog.of(context).showLoadingDialog(context, "正在发送..");
              //   _getSmsCode(context);
              // } else {
              //   Alert.show(
              //       context,
              //       NormalContentDialog(
              //         type: NormalTextDialogType.remind,
              //         title: null,
              //         content: Text(
              //           '请您先阅读并同意《用户协议》和《隐私政策》',
              //           style: TextStyle(color: Colors.black),
              //         ),
              //         items: ["确认"],
              //         listener: (index) {
              //           Alert.dismiss(context);
              //         },
              //       ));
              //}
            },
          ),
        ],
      ),
    );
  }

  Container _bottomOperation() {
    return Container(
      margin: EdgeInsets.only(
          top: rSize(10), left: rSize(15), right: rSize(8), bottom: rSize(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // TextButton(
          //   title: "如何注册？",
          //   textColor: Colors.grey[500],
          //   font: 14*2.sp,
          //   highlightTextColor: Colors.grey[400],
          //   onTap: () {},
          // ),
          TButton.TextButton(
            title: "收不到验证码？",
            font: 14.rsp,
            textColor: Colors.grey[400],
            highlightTextColor: Colors.grey[400],
            onTap: () {
              Alert.show(
                  context,
                  NormalContentDialog(
                    type: NormalTextDialogType.remind,
                    title: '收不到验证码',
                    content: Container(
                      padding: EdgeInsets.only(top: 10.rw,left: 10.rw,right: 10.rw),
                      child:
                      Column(
                        children: [
                          Text(
                            '如果没有手机验证吗，建议您进行以下操作：',
                            style: TextStyle(color: Color(0xFF333333),fontSize: 13.rsp),
                          ),
                          10.hb,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 2.rw),
                                width: 10.rw,
                                height: 10.rw,
                                decoration: BoxDecoration(
                                    color: Color(0xFFD5101A),
                                    borderRadius: BorderRadius.all(Radius.circular(5.rw))
                                ),
                              ),
                              10.wb,
                              Text(
                                '检查您的手机是否停机或无网络',
                                style: TextStyle(color: Color(0xFF333333),fontSize: 13.rsp),
                              ),
                            ],
                          ),
                          10.hb,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 2.rw),
                                width: 10.rw,
                                height: 10.rw,
                                decoration: BoxDecoration(
                                    color: Color(0xFFD5101A),
                                    borderRadius: BorderRadius.all(Radius.circular(5.rw))
                                ),
                              ),
                              10.wb,
                              Text(
                                '检查您的手机号是否输入正确',
                                style: TextStyle(color: Color(0xFF333333),fontSize: 13.rsp),
                              ),
                            ],
                          ),
                          10.hb,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 2.rw),
                                width: 10.rw,
                                height: 10.rw,
                                decoration: BoxDecoration(
                                  color: Color(0xFFD5101A),
                                  borderRadius: BorderRadius.all(Radius.circular(5.rw))
                                ),
                              ),
                              10.wb,
                              Text(
                                '检查您的验证码短信是否被屏蔽',
                                style: TextStyle(color: Color(0xFF333333),fontSize: 13.rsp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    items: ["确认"],
                    listener: (index) {
                      Alert.dismiss(context);
                    },
                  ));
            },
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
      font: 17 * 2.sp,
      enable: _loginEnable,
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: rSize(7)),
      radius: BorderRadius.all(Radius.circular(5)),
      backgroundColor: Theme.of(context).primaryColor,
      onTap: () {
        if (!_chooseAgreement) {
          GSDialog.of(context).showLoadingDialog(context, "正在登录...");
          _phoneLogin(context);
        } else {
          Alert.show(
              context,
              NormalContentDialog(
                type: NormalTextDialogType.remind,
                title: null,
                content: Text(
                  '请您先阅读并同意《用户协议》和《隐私政策》',
                  style: TextStyle(color: Colors.black),
                ),
                items: ["确认"],
                listener: (index) {
                  Alert.dismiss(context);
                },
              ));
        }
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
