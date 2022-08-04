import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/user_set_password_again.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/keyboard/CustomBoxPasswordFieldWidget.dart';
import 'package:recook/widgets/keyboard/keyboard_widget.dart';
import 'package:recook/widgets/keyboard/pay_password.dart';
import 'package:recook/widgets/toast.dart';

class UserSetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserSetPasswordState();
  }
}

class _UserSetPasswordState extends BaseStoreState<UserSetPassword> {
  String pwdData = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late VoidCallback _showBottomSheetCallback;
  @override
  void initState() {
    super.initState();
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
        title: "设置支付密码",
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
    // TextStyle redStyle = TextStyle(color: AppColor.themeColor, fontSize: 15*2.sp);
    // TextStyle greyStyle = TextStyle(color: Color(0xff777777), fontSize: 15*2.sp);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 36),
            alignment: Alignment.center,
            child: Text(
              "请设置您的支付密码",
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: 17 * 2.sp,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: GestureDetector(
                child: CustomBoxPasswordFieldWidget(
                  pwdData,
                  width: 45,
                  boxCount: 6,
                  margin: 4,
                ),
                onTap: () {
                  _showBottomSheetCallback();
                },
              )),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 30),
              height: 47,
              child: FlatButton(
                onPressed: pwdData.length == 6
                    ? () {
                        AppRouter.push(
                            context, RouteName.USER_SET_PASSWORD_AGAIN,
                            arguments:
                                UserSetPasswordAgain.setArguments(pwdData));
                      }
                    : null,
                textColor: Colors.white,
                disabledTextColor: Colors.white,
                color: AppColor.themeColor,
                disabledColor: Color(0xffd7d7d7),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Text(
                    '下一步',
                    style: TextStyle(fontSize: 17 * 2.sp, color: Colors.white),
                  ),
                ),
              ),
              // child: Container(
              //   alignment: Alignment.center,
              //   child: Text('下一步', style: TextStyle(fontSize: 17*2.sp,color: Colors.white ),),
              // ),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }

  /// 底部弹出 自定义键盘  下滑消失
  void _showBottomSheet() {
    _scaffoldKey.currentState!
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
                      Navigator.pop(_scaffoldKey.currentContext!);
                    },
                  ),
                ),
                MyKeyboard(
                  _onKeyDown,
                  isShowTips: true,
                ),
              ],
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // re-enable the button
              _showBottomSheetCallback = _showBottomSheet;
            });
          }
        });
  }

  void _onKeyDown(KeyEventR data) {
    if (data.isDelete()) {
      if (pwdData.length > 0) {
        pwdData = pwdData.substring(0, pwdData.length - 1);
        setState(() {});
      }
    } else if (data.isCommit()) {
      if (pwdData.length < 6) {
        //  Fluttertoast.showToast(msg: "密码不足6位，请重试", gravity: ToastGravity.CENTER);
        Toast.showError("验证码不足6位,请重试");
        return;
      }
      // onAffirmButton();
    } else {
      if (pwdData.length < 6) {
        pwdData += data.key;
      }
      setState(() {});
    }
  }
}
