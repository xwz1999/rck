import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:recook/constants/header.dart';

class CalendarWeekBarWidget extends BaseWeekBar {
  final List<String> weekList = ["一", "二", "三", "四", "五", "六", "日"];
  @override
  Widget getWeekBarItem(int index) {
    return Container(
      alignment: Alignment.center,
      height: 40.rw,
      child: Text(
        weekList[index],
        style: TextStyle(
          fontSize: 14.rsp,
          fontWeight: FontWeight.bold,
          color: Color(0xFF181818),
        ),
      ),
    );
  }
}
