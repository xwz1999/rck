/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/5  2:11 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class BottomTextFieldDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomTextFieldDialogState();
  }
}

class _BottomTextFieldDialogState extends State<BottomTextFieldDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          height: 600,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: SafeArea(
            bottom: true,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: <Widget>[
                  Expanded(child: Container(color: Colors.transparent,)),
                  TextField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomImageButton(
                        title: "取消",
                        onPressed: () {},
                      ),
                      CustomImageButton(
                        title: "确定",
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            )
          )),
    );
  }
}

class TextFieldDialog {
  static show(BuildContext context) {
    showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomTextFieldDialog();
        });
  }

  static dismiss(BuildContext context) {
    Navigator.maybePop(context);
  }
}
