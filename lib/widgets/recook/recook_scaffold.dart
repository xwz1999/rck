import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';

class RecookScaffold extends StatefulWidget {
  ///标题
  final dynamic title;

  ///红色背景
  final bool red;
  final bool whiteBg;
  final List<Widget> actions;
  final Widget body;
  final Widget bottomNavi;
  final PreferredSizeWidget appBarBottom;
  RecookScaffold({
    Key key,
    @required this.title,
    this.red = false,
    this.actions,
    this.body,
    this.bottomNavi,
    this.appBarBottom,
    this.whiteBg = false,
  }) : super(key: key);

  @override
  _RecookScaffoldState createState() => _RecookScaffoldState();
}

class _RecookScaffoldState extends State<RecookScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.whiteBg ? Colors.white : Color(0xFFF9F9FB),
      appBar: CustomAppBar(
        bottom: widget.appBarBottom,
        elevation: 0,
        themeData: AppBarTheme(
          brightness: widget.red ? Brightness.dark : Brightness.light,
        ),
        title: widget.title is String
            ? Text(
                widget.title,
                style: TextStyle(
                  color: widget.red ? Colors.white : AppColor.blackColor,
                ),
              )
            : widget.title,
        leading: RecookBackButton(
          white: widget.red,
        ),
        appBackground: widget.red
            ? Color(0xFFE02020)
            : widget.whiteBg ? Colors.white : Color(0xFFF9F9FB),
        actions: widget.actions,
      ),
      body: widget.body,
      bottomNavigationBar: widget.bottomNavi,
    );
  }
}
