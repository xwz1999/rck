import 'package:flutter/material.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';

class LotteryScaffold extends StatefulWidget {
  final dynamic title;
  final bool red;
  final List<Widget> actions;
  final Widget body;
  final Widget bottomNavi;
  LotteryScaffold({
    Key key,
    @required this.title,
    this.red = false,
    this.actions,
    this.body,
    this.bottomNavi,
  }) : super(key: key);

  @override
  _LotteryScaffoldState createState() => _LotteryScaffoldState();
}

class _LotteryScaffoldState extends State<LotteryScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9FB),
      appBar: CustomAppBar(
        elevation: 0,
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
