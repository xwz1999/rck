/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/5  4:28 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class ModifyInfoPage extends StatefulWidget {
  final Map arguments;
  final Function(String result) callback;

  const ModifyInfoPage({Key key, this.arguments, this.callback})
      : assert(arguments != null, "参数不能为空");

  static Map setArguments(String title, String origin, {int maxLength: 0}) {
    return {"title": title, "origin": origin, "maxLength": maxLength};
  }

  @override
  _ModifyInfoPageState createState() => _ModifyInfoPageState();
}

class _ModifyInfoPageState extends State<ModifyInfoPage> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.arguments["origin"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        title: "${widget.arguments["title"]}",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        actions: <Widget>[
          CustomImageButton(
            padding: EdgeInsets.symmetric(horizontal: 10),
            fontSize: 15 * 2.sp,
            title: "确定",
            onPressed: () {
              Navigator.pop(context, _controller.text);
            },
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 80,
          color: Colors.white,
          child: Center(
            child: TextField(
              maxLength: widget.arguments["maxLength"],
              textAlign: TextAlign.start,
              style: AppTextStyle.generate(15 * 2.sp),
              controller: _controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      AppIcons.icon_clear,
                      color: Colors.grey[400],
                      size: 18 * 2.sp,
                    ),
                    onPressed: () {
                      _controller.text = "";
                    },
                  )),
            ),
          )),
    );
  }
}
