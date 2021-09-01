import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recook/utils/date/date_utils.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';

import 'cut_down_time_widget.dart';

class SeckillActivityPage extends StatefulWidget {
  SeckillActivityPage({
    Key key,
  }) : super(key: key);

  @override
  _SeckillActivityPageState createState() => _SeckillActivityPageState();
}

class _SeckillActivityPageState extends State<SeckillActivityPage> {
  DateTime _dateNow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.transparent,
        flexibleSpace: Container(
          width: double.infinity,
          height: 124.rw,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.only(bottomRight: Radius.circular(104.rw)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFD9332D),
                Color(0xFFE44f37),
              ],
            ),
          ),
        ),
        leading: RecookBackButton(
          white: true,
        ),
        elevation: 0,
        title: Text(
          "限时秒杀",
          style: TextStyle(
              color: Colors.white,
              fontSize: 28.rsp,
              fontWeight: FontWeight.bold),
        ),
        bottom: _bottomWidgt(),
      ),

      // CustomAppBar(
      //   appBackground: Color(0xFFF9F9FB),

      //   elevation: 0,
      //   title: '限时秒杀'.text.bold.size(16.rsp).color(Colors.white).make(),
      //   themeData: AppThemes.themeDataGrey.appBarTheme,
      //   bottom: _bottomWidgt()
      // ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD5101A),
            Color(0x03FE2E39),
          ],
          stops: [0.0, 0.5],
        )),
        child: _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }

  Widget _bottomWidgt() {
    return PreferredSize(
      preferredSize: Size.fromHeight(30.rw),
      child: (Container(
        margin: EdgeInsets.only(bottom: 10.rw),
        width: double.infinity,
        height: 30.rw,
        color: Color(0xFFFCEEED),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '还差',
              style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rw),
            ),
            16.wb,
            CutDownTimeWidget(),
            16.wb,
            Text(
              '活动开始',
              style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rw),
            ),
          ],
        ),
      )),
    );
  }
}
