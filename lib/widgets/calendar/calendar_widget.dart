import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/widget/calendar_view.dart';
import 'package:recook/constants/header.dart';

import 'calendar_weekbar_widget.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarController _calendarController;
  Set<DateTime> _dates = Set<DateTime>();
  final DateTime dateNow = DateTime.now();
  @override
  void initState() {
    super.initState();
    DateTime dateNow = DateTime.now();
    _calendarController = CalendarController(
      minYear: dateNow.year,
      minYearMonth: dateNow.month,
      maxYear: dateNow.year + 5,
      maxYearMonth: 12,
      showMode: CalendarConstants.MODE_SHOW_ONLY_MONTH,
      selectedDateTimeList: _dates,
      selectMode: CalendarSelectedMode.singleSelect,
      offset: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        child: CalendarViewWidget(
          padding: EdgeInsets.symmetric(horizontal: 16.rw),
          weekBarItemWidgetBuilder: () => CalendarWeekBarWidget(),
          calendarController: _calendarController,
          dayWidgetBuilder: (dateModel) {
            bool isSevenDay() {
              int sevenDay =
                  dateNow.millisecondsSinceEpoch + 7 * 24 * 60 * 60 * 1000;
              int nowDay =
                  DateTime(dateModel.year, dateModel.month, dateModel.day, 12)
                      .millisecondsSinceEpoch;
              int currentDay =
                  DateTime(dateNow.year, dateNow.month, dateNow.day, 0)
                      .millisecondsSinceEpoch;
              if (currentDay < nowDay && nowDay < sevenDay) {
                return true;
              } else {
                return false;
              }
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 2.rw,
              ),
              child: Container(
                alignment: Alignment.center,
                height: 64.rw,
                decoration: BoxDecoration(
                  color: dateModel.isSelected
                      ? AppColor.primaryColor
                      : AppColor.backgroundColor,
                  border: isSevenDay()
                      ? Border.all(width: 1, color: AppColor.secondColor)
                      : null,
                ),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      dateModel.isCurrentDay ? '今天' : dateModel.day.toString(),
                      textScaleFactor: 1,
                      style: AppTextStyle.generate(
                        18.rsp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textMainColor,
                      ),
                    ),
                    Text(
                      dateModel.lunarString,
                      style: TextStyle(
                        fontSize: 8.rsp,
                        color: AppColor.textSubColor,
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
    );
  }
}
