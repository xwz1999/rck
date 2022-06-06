import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/widget/calendar_view.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/widgets/calendar/perpetual_calendar_model.dart';
import 'package:velocity_x/velocity_x.dart';

import 'calendar_weekbar_widget.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late CalendarController _calendarController;
  PerpetualCalendarModel? _perpetualCalendarModel;
  Set<DateTime> _dates = Set<DateTime>();

  final DateTime dateNow = DateTime.now();
  int? _year = DateTime.now().year;
  int? _month = DateTime.now().month;
  @override
  void initState() {
    super.initState();
    DateTime dateNow = DateTime.now();
    _calendarController = CalendarController(
      maxYear: dateNow.year + 10,
      maxYearMonth: 12,
      nowYear: dateNow.year,
      nowMonth: dateNow.month,
      showMode: CalendarConstants.MODE_SHOW_ONLY_MONTH,
      selectedDateTimeList: _dates,
      selectMode: CalendarSelectedMode.singleSelect,
      offset: 0,
    )
      ..addMonthChangeListener((year, month) {
        setState(() {
          _year = year;
          _month = month;
        });
      })
      ..addOnCalendarSelectListener((dateModel) {
        _getPerpetual(
            DateUtil.formatDate(dateModel!.getDateTime(), format: 'yyyy-MM-dd'));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            54.wb,
            GestureDetector(
              onTap: () {
                _calendarController.moveToPreviousYear();
              },
              child: Icon(
                Icons.chevron_left_outlined,
                size: 16.rw,
                color: Color(0xFFA5A5A5),
              ),
            ),
            80.wb,
            GestureDetector(
              onTap: () {
                _calendarController.moveToPreviousMonth();
              },
              child: Icon(
                Icons.chevron_left_outlined,
                size: 16.rw,
                color: Color(0xFFA5A5A5),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 22.rw,
              child: Text(
                _year.toString() + '年' + _month.toString() + '月',
                style: TextStyle(color: Color(0xFF181818), fontSize: 16.rsp),
              ),
            ).expand(),
            GestureDetector(
              onTap: () {
                _calendarController.moveToNextMonth();
              },
              child: Icon(
                Icons.chevron_right_outlined,
                size: 16.rw,
                color: Color(0xFFA5A5A5),
              ),
            ),
            80.wb,
            GestureDetector(
              onTap: () {
                _calendarController.moveToNextYear();
              },
              child: Icon(
                Icons.chevron_right_outlined,
                size: 16.rw,
                color: Color(0xFFA5A5A5),
              ),
            ),
            54.wb,
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          child: CalendarViewWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.rw),
            weekBarItemWidgetBuilder: () {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalendarWeekBarWidget(),
                  Divider(
                    height: 1.rw,
                    color: Color(0xFFDDDDDD),
                  )
                ],
              );
            },
            calendarController: _calendarController,
            dayWidgetBuilder: (dateModel) {
              // bool isSevenDay() {
              //   int sevenDay =
              //       dateNow.millisecondsSinceEpoch + 7 * 24 * 60 * 60 * 1000;
              //   int nowDay =
              //       DateTime(dateModel.year, dateModel.month, dateModel.day, 12)
              //           .millisecondsSinceEpoch;
              //   int currentDay =
              //       DateTime(dateNow.year, dateNow.month, dateNow.day, 0)
              //           .millisecondsSinceEpoch;
              //   if (currentDay < nowDay && nowDay < sevenDay) {
              //     return true;
              //   } else {
              //     return false;
              //   }
              // }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.rw,
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.rw,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.rw)),
                      color: Colors.white,
                      border: dateModel.isCurrentDay
                          ? Border.all(color: Color(0xFFDB2D2D), width: 1.rw)
                          : dateModel.isSelected!
                              ? Border.all(
                                  color: Color(0xFF007BFF), width: 1.rw)
                              : null),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Text(
                        dateModel.day.toString(),
                        textScaleFactor: 1,
                        style: AppTextStyle.generate(
                          12.rsp,
                          fontWeight: FontWeight.w500,
                          color: dateModel.isCurrentMonth!
                              ? AppColor.textMainColor
                              : Color(0xFF999999),
                        ),
                      ),
                      Text(
                        dateModel.lunarString,
                        style: TextStyle(
                          fontSize: 12.rsp,
                          color: dateModel.traditionFestival.isNotEmpty ||
                                  dateModel.solarTerm.isNotEmpty ||
                                  dateModel.gregorianFestival.isNotEmpty
                              ? Color(0xFFDB2D2D)
                              : dateModel.isCurrentMonth!
                                  ? AppColor.textMainColor
                                  : Color(0xFF999999),
                        ),
                      ),
                      Expanded(child: Row()),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ));
  }

  _getPerpetual(String time) async {
    String url =
        "http://v.juhe.cn/laohuangli/d?date=$time&key=edfd263c72451fd0b50c348259445879";
    Response? res = await HttpManager.netFetchNormal(url, null, null, null);
    Map map = json.decode(res.toString());
    _perpetualCalendarModel = PerpetualCalendarModel.fromJson(map as Map<String, dynamic>);

    setState(() {
          
        });
    //_homeWeatherModel = HomeWeatherModel.fromJson(map);
  }
}
