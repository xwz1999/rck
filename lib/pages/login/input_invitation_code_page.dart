/*
 * ====================================================
 * package   : pages.login
 * author    : Created by nansi.
 * time      : 2019/5/16  9:52 AM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/daos/user_dao.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/text_button.dart' as TButton;
import 'package:recook/widgets/toast.dart';

class InvitationCodePage extends StatefulWidget {
  static const String KEY_MODE = "mode";

  static const String KEY_MOBILE = "mobile";

  static const String KEY_USER_ID = "userID";
  static const String KEY_NICKNAME = "nickname";

  final Map argument;

  InvitationCodePage({required this.argument});

  // mode == 0 : 手机登录需要注册
  // mode == 1 : 微信登录需要注册
  static setArgs(
      {int mode = 0, String? mobile, String nickName = "用户", int? userID}) {
    if (mode == 0) {
      return {KEY_MODE: 0, KEY_MOBILE: mobile};
    }

    return {
      KEY_MODE: 1,
      KEY_USER_ID: userID,
      KEY_NICKNAME: nickName,
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _InvitationCodePageState();
  }
}

class _InvitationCodePageState extends BaseStoreState<InvitationCodePage> {
  TextEditingController? _controller;

  bool _loginEnable = false;

  @override
  void initState() {
    super.initState();
    print("InvitationCodePage --- ${widget.argument}");
    _controller = TextEditingController();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    bool phoneLogin = widget.argument[InvitationCodePage.KEY_MODE] == 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "绑定登录",
        elevation: 0.2,
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Text(
                  "亲爱的${phoneLogin ? "手机" : "微信"}用户: ${phoneLogin ? widget.argument[InvitationCodePage.KEY_MOBILE] : widget.argument[InvitationCodePage.KEY_NICKNAME]}",
                  style: AppTextStyle.generate(16, color: Colors.grey[700]),
                )),
            Container(
                margin: EdgeInsets.only(top: 8, left: 20, right: 20),
                child: getStore().state.openinstall!.code!.length > 0
                    ? Container()
                    : Text(
                        "检测到您是第一次登录，请输入邀请码",
                        style:
                            AppTextStyle.generate(16, color: Colors.grey[700]),
                      )),
            _invitationInput(context),
            TButton.TextButton(
              title: "登录",
              textColor: Colors.white,
              unableBackgroundColor: Colors.grey[300],
              enable: _loginEnable,
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 10),
              radius: BorderRadius.all(Radius.circular(5)),
              backgroundColor: Theme.of(context).primaryColor,
              onTap: () {
                GSDialog.of(context).showLoadingDialog(context, "");
                if (phoneLogin) {
                  _phoneRegister(context);
                } else {
                  // _weChatRegister(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Container _invitationInput(BuildContext context) {
    String bindData = getStore().state.openinstall!.code!;
    if (bindData.length > 0) {
      setState(() {
        _loginEnable = true;
      });
    }
    return Container(
      margin: EdgeInsets.only(top: 28, left: 20, right: 20, bottom: 150),
      child: Theme(
        data: ThemeData(primaryColor: Theme.of(context).primaryColor),
        // child: _invitationTF(),
        child:
            bindData.length > 0 ? _invitationText(bindData) : _invitationTF(),
      ),
    );
  }

  Text _invitationText(bindData) {
    return Text(
      "邀请码: $bindData",
      style: AppTextStyle.generate(30, color: Colors.black),
      maxLines: 1,
    );
  }

  TextField _invitationTF() {
    return TextField(
      enableInteractiveSelection: true,
      maxLength: 8,
      controller: _controller,
      // keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        LengthLimitingTextInputFormatter(8),
      ],
      textCapitalization: TextCapitalization.characters,
      onChanged: (text) {
        // _controller.text = text.toUpperCase();
        if (text.length >= 6) {
          setState(() {
            _loginEnable = true;
          });
        } else {
          setState(() {
            _loginEnable = false;
          });
        }
      },
      textAlign: TextAlign.center,
      cursorColor: Colors.grey[400],
      style: AppTextStyle.generate(30,
          fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
          hintText: "请输入邀请码",
          hintStyle: AppTextStyle.generate(30, color: Colors.grey[400])),
    );
  }

  _phoneRegister(BuildContext context) {
    String bindData = getStore().state.openinstall!.code!;
    if (bindData.length <= 0) {
      bindData = _controller!.text.toUpperCase();
    }
    UserDao.phoneRegister(widget.argument["mobile"], bindData,
        success: (data, code, msg) {
      GSDialog.of(context).dismiss(context);
      AppRouter.pushAndRemoveUntil(context, RouteName.TAB_BAR);
      UserManager.updateUser(data!, getStore());
    }, failure: (code, msg) {
      GSDialog.of(context).dismiss(context);
      Toast.showError(msg);
    });
  }

  // _weChatRegister(BuildContext context) {
  //   String bindData = getStore().state.openinstall.code;
  //   if (bindData.length <= 0){
  //     bindData = _controller.text.toUpperCase();
  //   }
  //   UserDao.weChatRegister(
  //                 widget.argument[InvitationCodePage.KEY_USER_ID],
  //                 bindData,
  //                 success: (data, code, msg) {
  //               GSDialog.of(context).dismiss(context);
  //               AppRouter.pushAndRemoveUntil(context, RouteName.TAB_BAR);
  //               UserManager.updateUser(data, getStore());
  //             }, failure: (code, msg) {
  //               GSDialog.of(context).dismiss(context);
  //               Toast.showError(msg);
  //             });
  // }
}
