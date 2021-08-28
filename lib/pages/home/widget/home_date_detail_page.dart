import 'dart:convert';
import 'package:flustars/flustars.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/calendar_view.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/home_weather_model.dart';
import 'package:recook/widgets/calendar/calendar_weekbar_widget.dart';
import 'package:recook/widgets/calendar/perpetual_calendar_model.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeDateDetailPage extends StatefulWidget {
  final HomeWeatherModel homeWeatherModel;
  HomeDateDetailPage({
    Key key,
    this.homeWeatherModel,
  }) : super(key: key);

  @override
  _HomeDateDetailPageState createState() => _HomeDateDetailPageState();
}

class _HomeDateDetailPageState extends State<HomeDateDetailPage> {
  CalendarController _calendarController;
  PerpetualCalendarModel _perpetualCalendarModel;
  Set<DateTime> _dates = Set<DateTime>();
  DateModel _dateModel;

  final DateTime dateNow = DateTime.now();
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  @override
  void initState() {
    super.initState();
    DateTime dateNow = DateTime.now();
    _getPerpetual(DateUtil.formatDate(dateNow, format: 'yyyy-MM-dd'));
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
        _dateModel = dateModel;
        _getPerpetual(
            DateUtil.formatDate(dateModel.getDateTime(), format: 'yyyy-MM-dd'));
        print(dateModel.lunar);
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F8),
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text(
          "日历",
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18.rsp,
          ),
        ),
      ),
      body: Container(
        child: _bodyWidget(),
      ),
    );
  }

  _bodyWidget() {
    return ListView(
      children: [
        _dateWidget(),
        _perpetualCalendarModel != null ? _nongli() : SizedBox(),
      ],
    );
  }

  _dateWidget() {
    return Container(
        color: Colors.white,
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
                    style:
                        TextStyle(color: Color(0xFF181818), fontSize: 16.rsp),
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
                              ? Border.all(
                                  color: Color(0xFFDB2D2D), width: 1.rw)
                              : dateModel.isSelected
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
                              color: dateModel.isCurrentMonth
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
                                  : dateModel.isCurrentMonth
                                      ? AppColor.textMainColor
                                      : Color(0xFF999999),
                            ),
                          ),
                          Spacer(),
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

  _nongli() {
    return Container(
      width: double.infinity,
      //color: Color(0xFFFFF8F8),
      child: Column(
        children: [
          40.hb,
          Row(
            children: [
              40.wb,
              Text(
                _perpetualCalendarModel.result.yangli,
                style: TextStyle(color: Color(0xFF181818), fontSize: 16.rsp),
              ),
              Spacer(),
              Text(
                _perpetualCalendarModel.result.yinli,
                style: TextStyle(color: Color(0xFF181818), fontSize: 16.rsp),
              ),
              40.wb
            ],
          ),
          20.hb,
          Row(
            children: [
              40.wb,
              Text(
                '"xx节"',
                style: TextStyle(color: Color(0xFF181818), fontSize: 16.rsp),
              ),
              Spacer(),
            ],
          ),
          40.hb,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.wb,
              Column(
                children: [
                  8.hb,
                  Container(
                      width: 30.rw,
                      height: 30.rw,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFF007AFF),
                          borderRadius:
                              BorderRadius.all(Radius.circular(4.rw))),
                      child: Text(
                        '宜',
                        style: TextStyle(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 20.rsp,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              40.wb,
              Container(
                child: Text(
                    '搬家、装修、结婚、入宅、领证、出行、 旅游、入学、求嗣、修坟、赴任、修造、 祈福、祭祀、纳财、启钻、嫁娶、移徙、 立券、求医、栽种、招赘、开仓',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Color(0xFF333333), fontSize: 14.rsp)),
              ).expand(),
              100.wb
            ],
          ),
          40.hb,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.wb,
              Column(
                children: [
                  8.hb,
                  Container(
                      width: 30.rw,
                      height: 30.rw,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFFCE4242),
                          borderRadius:
                              BorderRadius.all(Radius.circular(4.rw))),
                      child: Text(
                        '忌',
                        style: TextStyle(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 20.rsp,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              40.wb,
              Container(
                child: Text(
                    '开业、开工、动土、安门、安床、订婚、安葬、上梁、开张、作灶、破土、开市、纳畜、纳采、伐木、盖屋、竖柱、求财',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Color(0xFF333333), fontSize: 14.rsp)),
              ).expand(),
              100.wb
            ],
          ),
        ],
      ),
    );
  }

  _getPerpetual(String time) async {
    String url =
        "http://v.juhe.cn/laohuangli/d?date=$time&key=edfd263c72451fd0b50c348259445879";
    Response res = await HttpManager.netFetchNormal(url, null, null, null);
    Map map = json.decode(res.toString());
    _perpetualCalendarModel = PerpetualCalendarModel.fromJson(map);
    setState(() {});
    //_homeWeatherModel = HomeWeatherModel.fromJson(map);
  }
}
