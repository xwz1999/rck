import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';

class LotteryScaffold extends StatefulWidget {
  final dynamic title;
  final bool red;
  final bool whiteBg;
  final List<Widget> actions;
  final Widget body;
  final Widget bottomNavi;
  final PreferredSizeWidget appBarBottom;
  LotteryScaffold({
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
  _LotteryScaffoldState createState() => _LotteryScaffoldState();
}

class _LotteryScaffoldState extends State<LotteryScaffold> {
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
                style: TextStyle(color: AppColor.blackColor),
              )
            : widget.title,
        leading: RecookBackButton(
          white: widget.red,
        ),
        appBackground: widget.red ? Color(0xFFE02020) : Color(0xFFF9F9FB),
        actions: widget.actions,
      ),
      body: widget.body,
      bottomNavigationBar: widget.bottomNavi,
    );
  }
}
