import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/styles.dart';
import 'CustomJPasswordFieldWidget.dart';
import 'keyboard_widget.dart';
import 'pay_password.dart';

class BottomKeyBoardController{
  Function clearPassWord;
}

class BottomKeyBoardWidget extends StatefulWidget{
  final BottomKeyBoardController controller;
  final Function(String) passwordReturn;
  final Function close;
  final Function forgetPassword;

  const BottomKeyBoardWidget({Key key, this.controller, this.passwordReturn, this.close, this.forgetPassword,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomKeyBoardWidgetState();
  }
  
}

class _BottomKeyBoardWidgetState extends State<BottomKeyBoardWidget>{
  
  String _pwdData = '';
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (widget.controller!=null) {
      widget.controller.clearPassWord = (){
        if (mounted) {
          _pwdData = "";
          setState(() {});
        }
      };
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.frenchColor,
      height: 220.0+190.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildTopWidget(),
          Container(
            height: 220,
            child: MyKeyboard(_onKeyDown, isShowTips: false, needCommit: false,),
          ),
        ],
      ),
    );
  }
  
  /// 密码键盘 确认按钮 事件
  void onAffirmButton() {

  }

  void _onKeyDown(KeyEvent data){
    if (data.isDelete()) {
      if (_pwdData.length > 0) {
        _pwdData = _pwdData.substring(0, _pwdData.length - 1);
        setState(() {});
      }
    } else if (data.isCommit()) {
      if (_pwdData.length != 6) {
//        Fluttertoast.showToast(msg: "密码不足6位，请重试", gravity: ToastGravity.CENTER);
        return;
      }
      onAffirmButton();
    } else {
      if (_pwdData.length < 6) {
        _pwdData += data.key;
        if (_pwdData.length == 6 && widget.passwordReturn!=null) {
          widget.passwordReturn(_pwdData);
        }
      }
      setState(() {});
    }
  }
  
  Widget _buildPwd(var pwd) {
    return new GestureDetector(
      child: new Container(
        width: MediaQuery.of(context).size.width-40,
        height:50.0,
//      color: Colors.white,
        child: CustomJPasswordField(pwd),
      ),
      onTap: () {
        // _showBottomSheetCallback();
      },
    );
  }

  _buildTopWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 190.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 55,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if (widget.close!=null) {
                      widget.close();
                    }
                  },
                  child: Container(
                    width: 50,
                    child: Icon(Icons.close, color: Color(0xff9e9e9e),size: 30, ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("请输入支付密码", style: TextStyle(color: Colors.black, fontSize: 20),),
                  ),
                ),
                Container(width: 50,),
              ],
            ),
          ),
          Container(
            height: 0.2, color: Color(0xff9e9e9e),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: _buildPwd(_pwdData),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 20),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: (){
                if (widget.forgetPassword != null) {
                  widget.forgetPassword();
                }
              },
              child: Text('忘记密码?', style: TextStyle(color: Colors.red),),
            )
          )
        ],
      ),
    );
  }

}
