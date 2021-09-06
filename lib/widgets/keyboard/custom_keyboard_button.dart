import 'package:flutter/material.dart';

///  自定义 键盘 按钮

class CustomKbBtn extends StatefulWidget {

  final String text;
  final Widget child;
   CustomKbBtn({Key key, this.text, this.child, this.callback}) : super(key: key);
  final callback;

  @override
  State<StatefulWidget> createState() {
    return ButtonState();
  }
}

class ButtonState extends State<CustomKbBtn> {
  ///回调函数执行体
  var backMethod;

  void back() {
    if (widget.callback != null) {
      widget.callback('$backMethod');
    }
  }

  @override
  Widget build(BuildContext context) {

    MediaQueryData mediaQuery = MediaQuery.of(context);
    var _screenWidth = mediaQuery.size.width;

    return new Container(
        height:50.0,
        width: _screenWidth / 3,
        child:
        new OutlinedButton(
          style: OutlinedButton.styleFrom(
            // 直角
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            // 边框颜色
            side: new BorderSide(color: Color(0x10333333)),
          ),
          child: widget.child!=null?
            widget.child
            :Text(
              widget.text,
              style: new TextStyle(color: Color(0xff333333), fontSize: 25.0),
            ),
          onPressed: back,
        )


    );
  }
}
