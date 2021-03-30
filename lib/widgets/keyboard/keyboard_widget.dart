import 'package:flutter/material.dart';

import 'custom_keyboard_button.dart';
import 'pay_password.dart';

/// 自定义密码 键盘

class MyKeyboard extends StatefulWidget {
  final callback;
  final isShowTips;
  final bool needCommit;

  MyKeyboard(this.callback, {this.isShowTips:true, this.needCommit:false});

  @override
  State<StatefulWidget> createState() {
    return new MyKeyboardStat();
  }
}

class MyKeyboardStat extends State<MyKeyboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 定义 确定 按钮 接口  暴露给调用方
  ///回调函数执行体
  var backMethod;
  void onCommitChange() {
    widget.callback(new KeyEvent("commit"));
  }

  void onOneChange(BuildContext cont) {
    widget.callback(new KeyEvent("1"));
  }

  void onTwoChange(BuildContext cont) {
    widget.callback(new KeyEvent("2"));
  }

  void onThreeChange(BuildContext cont) {
    widget.callback(new KeyEvent("3"));
  }

  void onFourChange(BuildContext cont) {
    widget.callback(new KeyEvent("4"));
  }

  void onFiveChange(BuildContext cont) {
    widget.callback(new KeyEvent("5"));
  }

  void onSixChange(BuildContext cont) {
    widget.callback(new KeyEvent("6"));
  }

  void onSevenChange(BuildContext cont) {
    widget.callback(new KeyEvent("7"));
  }

  void onEightChange(BuildContext cont) {
    widget.callback(new KeyEvent("8"));
  }

  void onNineChange(BuildContext cont) {
    widget.callback(new KeyEvent("9"));
  }

  void onZeroChange(BuildContext cont) {
    widget.callback(new KeyEvent("0"));
  }

  /// 点击删除
  void onDeleteChange() {
    widget.callback(new KeyEvent("del"));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: _scaffoldKey,
      width: double.infinity,
      height: widget.isShowTips?250.0:220,
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          widget.isShowTips?
          Container(
            height:30.0,
            color: Colors.white,
            alignment: Alignment.center,
            child: new Text(
              '下滑隐藏',
              style: new TextStyle(fontSize: 12.0, color: Color(0xff999999)),
            ),
          ):
          Container(height: 0,),
          Container(
            height: 220,
            child: new Column(
              children: <Widget>[
                ///  第一行
                new Row(
                  children: <Widget>[
                    CustomKbBtn(
                        text: '1', callback: (val) => onOneChange(context)),
                    CustomKbBtn(
                        text: '2', callback: (val) => onTwoChange(context)),
                    CustomKbBtn(
                        text: '3', callback: (val) => onThreeChange(context)),
                  ],
                ),

                ///  第二行
                new Row(
                  children: <Widget>[
                    CustomKbBtn(
                        text: '4', callback: (val) => onFourChange(context)),
                    CustomKbBtn(
                        text: '5', callback: (val) => onFiveChange(context)),
                    CustomKbBtn(
                        text: '6', callback: (val) => onSixChange(context)),
                  ],
                ),

                ///  第三行
                new Row(
                  children: <Widget>[
                    CustomKbBtn(
                        text: '7', callback: (val) => onSevenChange(context)),
                    CustomKbBtn(
                        text: '8', callback: (val) => onEightChange(context)),
                    CustomKbBtn(
                        text: '9', callback: (val) => onNineChange(context)),
                  ],
                ),

                ///  第四行
                new Row(
                  children: <Widget>[
                    // CustomKbBtn(text: '删除', callback: (val) => onDeleteChange()),
                    widget.needCommit ? 
                    CustomKbBtn(
                      child: Text("确认", style: TextStyle(color: Colors.black, fontSize: 18),),
                      callback: (val) => onCommitChange())
                    :Container(
                      // decoration: BoxDecoration(
                        // border: Border.all(color: Color(0x10333333)
                      // ),),
                      height: 50,
                      width: MediaQuery.of(context).size.width/3,),
                    CustomKbBtn(
                        text: '0', callback: (val) => onZeroChange(context)),
                    CustomKbBtn(
                      child: Image.asset('assets/keyboard_delete_left.png', width: 23,),
                      callback: (val) => onDeleteChange()),
                    // CustomKbBtn(
                    //   child: Icon(Icons.keyboard_backspace, color: Colors.black, size: 22,), 
                    //   callback: (val) => onDeleteChange()),
                  ],
                ),
              ],
            ),
          ),
          ///  键盘主体
          // new Column(
          //   children: <Widget>[
          //     ///  第一行
          //     new Row(
          //       children: <Widget>[
          //         CustomKbBtn(
          //             text: '1', callback: (val) => onOneChange(context)),
          //         CustomKbBtn(
          //             text: '2', callback: (val) => onTwoChange(context)),
          //         CustomKbBtn(
          //             text: '3', callback: (val) => onThreeChange(context)),
          //       ],
          //     ),

          //     ///  第二行
          //     new Row(
          //       children: <Widget>[
          //         CustomKbBtn(
          //             text: '4', callback: (val) => onFourChange(context)),
          //         CustomKbBtn(
          //             text: '5', callback: (val) => onFiveChange(context)),
          //         CustomKbBtn(
          //             text: '6', callback: (val) => onSixChange(context)),
          //       ],
          //     ),

          //     ///  第三行
          //     new Row(
          //       children: <Widget>[
          //         CustomKbBtn(
          //             text: '7', callback: (val) => onSevenChange(context)),
          //         CustomKbBtn(
          //             text: '8', callback: (val) => onEightChange(context)),
          //         CustomKbBtn(
          //             text: '9', callback: (val) => onNineChange(context)),
          //       ],
          //     ),

          //     ///  第四行
          //     new Row(
          //       children: <Widget>[
          //         // CustomKbBtn(text: '删除', callback: (val) => onDeleteChange()),
          //         widget.needCommit ? 
          //         CustomKbBtn(
          //           child: Text("确认", style: TextStyle(color: Colors.black, fontSize: 18),),
          //           callback: (val) => onCommitChange())
          //         :Container(
          //           // decoration: BoxDecoration(
          //             // border: Border.all(color: Color(0x10333333)
          //           // ),),
          //           height: 50,
          //           width: MediaQuery.of(context).size.width/3,),
          //         CustomKbBtn(
          //             text: '0', callback: (val) => onZeroChange(context)),
          //         CustomKbBtn(
          //           child: Image.asset('assets/keyboard_delete_left.png', width: 23,),
          //           callback: (val) => onDeleteChange()),
          //         // CustomKbBtn(
          //         //   child: Icon(Icons.keyboard_backspace, color: Colors.black, size: 22,), 
          //         //   callback: (val) => onDeleteChange()),
          //       ],
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
