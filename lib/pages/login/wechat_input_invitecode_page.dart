
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/daos/user_dao.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/text_button.dart' as TButton;
import 'package:recook/widgets/toast.dart';

class WeChatInputInviteCodePage extends StatefulWidget {
  static const String KEY_wxUnionId = "wxUnionId";
  final Map argument;
  WeChatInputInviteCodePage({this.argument})
      : assert(argument != null, "argument 不能为空");
  static setArgument(a) {
    return {KEY_wxUnionId: a};
  }

  @override
  State<StatefulWidget> createState() {
    return _WeChatInputInviteCodePageState();
  }
}

class _WeChatInputInviteCodePageState
    extends BaseStoreState<WeChatInputInviteCodePage> {
  double _fontSize = ScreenAdapterUtils.setSp(15);

  FocusNode _inviteCodeFocusNode;
  TextEditingController _inviteCodeController;

  bool _loginEnable = true;
  @override
  void initState() {
    super.initState();
    _inviteCodeFocusNode = FocusNode();

    _inviteCodeController = TextEditingController();
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
                  _inviteWidget(),
                  Container(
                    height: ScreenAdapterUtils.setHeight(50),
                  ),
                  _loginBtnWidget(),
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
        '填写邀请码',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: ScreenAdapterUtils.setSp(25)),
      ),
    );
  }

  _inviteWidget() {
    return Container(
      height: ScreenAdapterUtils.setHeight(40),
      margin: EdgeInsets.symmetric(horizontal: rSize(20)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  '邀请码',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: _fontSize,
                      color: Colors.black),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: _inviteInputWidget(),
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
    return _inviteCodeController.text.length == 6;
  }

  _inviteInputWidget() {
    String bindString = getStore().state.openinstall.code;
    // String bindString = 'aaaaaa';
    if (bindString != null &&
        (bindString.length == 6 || bindString.length == 8)) {
      _inviteCodeController.text = bindString;
      return Text(
        bindString,
        style: TextStyle(
            color: Colors.black,
            fontSize: _fontSize,
            fontWeight: FontWeight.w300),
      );
    } else {
      return CupertinoTextField(
        onChanged: (String phone) {},
        controller: _inviteCodeController,
        focusNode: _inviteCodeFocusNode,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.black, fontSize: _fontSize),
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
        ],
        cursorColor: Colors.black,
        placeholder: "填写邀请码",
        placeholderStyle: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.grey[400],
            fontSize: _fontSize),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white.withAlpha(0))),
      );
    }
  }

  _loginBtnWidget() {
    return Container(
      child: TButton.TextButton(
        title: '登录',
        textColor: Colors.white,
        unableBackgroundColor: Colors.grey[300],
        font: ScreenAdapterUtils.setSp(17),
        enable: _loginEnable,
        // height: ScreenAdapterUtils.setHeight(35),
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

  _bottomLineWidget() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.1),
    );
  }

  _weChatRegister(BuildContext context) {
    String bindData = getStore().state.openinstall.code;
    if (bindData.length <= 0) {
      bindData = _inviteCodeController.text.toUpperCase();
    }
    UserDao.weChatInvitation(
        widget.argument[WeChatInputInviteCodePage.KEY_wxUnionId], bindData,
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
