import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pin_input_text_field/pin_input_text_field.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/keyboard/keyboard_widget.dart';
import 'package:recook/widgets/keyboard/pay_password.dart';
import 'package:recook/widgets/toast.dart';

class UserSetPasswordVarCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserSetPasswordVarCodeState();
  }
}

class _UserSetPasswordVarCodeState
    extends BaseStoreState<UserSetPasswordVarCode> {
  Timer _timer;
  String _countDownStr = "点击发送验证码";
  bool _getCodeEnable = false;
  int _countDownNum = 60;
  bool _verifySms = false;
  bool _cantSelected = false;
  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _textEditingController?.dispose();
    super.dispose();
  }

  @Deprecated("old data")
  String pwdData = '';
  TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VoidCallback _showBottomSheetCallback;
  @override
  void initState() {
    super.initState();
    _getCodeEnable = true;
    _showBottomSheetCallback = _showBottomSheet;
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: AppColor.frenchColor,
      backgroundColor: Color(0xfff5f5f5),
      appBar: CustomAppBar(
        elevation: 0,
        title: "身份验证",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Container(
      child: _varCodeWidget(),
    );
  }

  _varCodeWidget() {
    TextStyle redStyle = TextStyle(
        color: AppColor.themeColor, fontSize: ScreenAdapterUtils.setSp(15));
    TextStyle greyStyle = TextStyle(
        color: Color(0xff777777), fontSize: ScreenAdapterUtils.setSp(15));
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: Text(
              "请输入短信验证码",
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenAdapterUtils.setSp(25),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            alignment: Alignment.center,
            child: Text(
              "我们已发送短信验证码到你的手机号",
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: ScreenAdapterUtils.setSp(15),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            child: Text(
              UserManager.instance.user.info.mobile.replaceRange(3, 7, "****"),
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: ScreenAdapterUtils.setSp(22),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 36, left: 32, right: 32),
            // child: GestureDetector(
            //   child: CustomBoxPasswordFieldWidget(pwdData, boxCount: 4, showString: true, ),
            //   onTap: (){
            //     _showBottomSheetCallback();
            //   },
            // )
            child: PinInputTextField(
              enableInteractiveSelection: true,
              toolbarOptions: ToolbarOptions(paste: true),
              controller: _textEditingController,
              pinLength: 4,
              onChanged: (_) => setState(() {}),
              decoration: BoxLooseDecoration(
                gapSpace: 12,
                radius: Radius.circular(4),
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
                strokeColorBuilder:
                    PinListenColorBuilder(Colors.grey, Colors.blue),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 15),
              child: FlatButton(
                textColor: AppColor.themeColor,
                disabledTextColor: Color(0xff777777),
                child: Text(
                  _countDownStr,
                  style: TextStyle(fontSize: ScreenAdapterUtils.setSp(15)),
                ),
                onPressed: _getCodeEnable
                    ? () {
                        if (_cantSelected) return;
                        _cantSelected = true;
                        Future.delayed(Duration(seconds: 2), () {
                          _cantSelected = false;
                        });
                        _getVarCode();
                      }
                    : null,
              )),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 30),
              height: 47,
              color: _textEditingController.text.length == 4
                  ? AppColor.themeColor
                  : Color(0xffd7d7d7),
              // pwdData.length == 4 ? AppColor.themeColor : Color(0xffd7d7d7),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '确认',
                  style: TextStyle(
                      fontSize: ScreenAdapterUtils.setSp(17),
                      color: Colors.white),
                ),
              ),
            ),
            onTap: () {
              if (_textEditingController.text.length != 4) return;
              // if (pwdData.length != 4) {
              //   return;
              // }
              _verifySmsCode();
            },
          )
        ],
      ),
    );
  }

  /// 底部弹出 自定义键盘  下滑消失
  void _showBottomSheet() {
    setState(() {
      // disable the button
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: Colors.white.withAlpha(0),
                    ),
                    onTap: () {
                      Navigator.pop(_scaffoldKey.currentContext);
                    },
                  ),
                ),
                MyKeyboard(
                  _onKeyDown,
                  isShowTips: true,
                  needCommit: true,
                ),
              ],
            ),
          );
          // return new MyKeyboard(_onKeyDown, isShowTips: true, needCommit: true,);
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              if (_verifySms) {
                _verifySmsCode();
              }
              _verifySms = false;
              // re-enable the button
              _showBottomSheetCallback = _showBottomSheet;
            });
          }
        });
  }

  void _onKeyDown(KeyEvent data) {
    if (data.isDelete()) {
      if (pwdData.length > 0) {
        pwdData = pwdData.substring(0, pwdData.length - 1);
        setState(() {});
      }
    } else if (data.isCommit()) {
      if (pwdData.length < 4) {
        //  Fluttertoast.showToast(msg: "密码不足6位，请重试", gravity: ToastGravity.CENTER);
        Toast.showError("验证码不足4位,请重试");
        return;
      }
      _verifySms = true;
      Navigator.pop(_scaffoldKey.currentContext);
    } else {
      if (pwdData.length < 4) {
        pwdData += data.key;
      }
      setState(() {});
    }
  }

  _getVarCode() async {
    ResultData resultData = await HttpManager.post(
        UserApi.verify_sms_send, {"userId": UserManager.instance.user.info.id});
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _beginCountDown();
    showSuccess("发送成功!");
  }

  _verifySmsCode() async {
    ResultData resultData = await HttpManager.post(UserApi.verify_sms, {
      "userId": UserManager.instance.user.info.id,
      // "sms": pwdData,
      "sms": _textEditingController.text,
    });

    if (!resultData.result) {
      // pwdData = "";
      _textEditingController?.clear();
      setState(() {});
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      // pwdData = "";
      _textEditingController?.clear();
      setState(() {});
      showError(model.msg);
      return;
    }
    AppRouter.pushAndReplaced(context, RouteName.USER_SET_PASSWORD);
    return;
  }

  _beginCountDown() {
    setState(() {
      _getCodeEnable = false;
      _countDownStr = "$_countDownNum秒后可点此重新发送";
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timer == null || !mounted) {
        return;
      }
      setState(() {
        if (_countDownNum == 0) {
          _countDownNum = 60;
          _countDownStr = "获取验证码";
          _getCodeEnable = true;
          _timer.cancel();
          _timer = null;
          return;
        }
        _countDownStr = "${_countDownNum--}秒后可点此重新发送";
      });
    });
  }
}
