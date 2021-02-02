import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class CustomBoxPasswordFieldWidget extends StatelessWidget {
  final String data;
  final int boxCount;
  final bool showString;
  final double width;
  final Function click;
  final double margin;

  CustomBoxPasswordFieldWidget(
    this.data, {
    this.boxCount: 6,
    this.showString: false,
    this.width: 58,
    this.click,
    this.margin: 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: _rowWidget(),
      ),
    );
    // return GestureDetector(
    //   child: Container(
    //     child: Row(
    //       children: _rowWidget(),
    //     ),
    //   ),
    //   onTap: (){
    //     if (click!=null) {
    //       click();
    //     }
    //   },
    // );
  }

  _rowWidget() {
    List<Widget> listWidget = [];
    listWidget.add(Spacer());
    for (var i = 0; i < boxCount; i++) {
      if (data.length < i + 1) {
        listWidget.add(_boxWidget(""));
      } else {
        listWidget.add(_boxWidget(data.substring(i, i + 1)));
      }
    }
    listWidget.add(Spacer());
    return listWidget;
  }

  _boxWidget(String str) {
    return Container(
      width: width,
      height: width,
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xffaaaaaa), width: 1),
      ),
      child: Center(
        child: str.isEmpty
            ? Container()
            : showString
                ? Text(
                    str,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenAdapterUtils.setSp(20),
                    ),
                  )
                : Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black),
                  ),
      ),
    );
  }
}
