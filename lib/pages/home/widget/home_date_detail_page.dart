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
import 'package:recook/widgets/calendar/holiday_calendar_model.dart';
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
  HolidayCalendarModel _holidayCalendarModel;
  Set<DateTime> _dates = Set<DateTime>();
  DateModel _dateModel;

  final DateTime dateNow = DateTime.now();
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  String _holiday = '';
  String _workday = '';
  @override
  void initState() {
    super.initState();
    DateTime dateNow = DateTime.now();
    _getPerpetual(DateUtil.formatDate(dateNow, format: 'yyyy-MM-dd'));
    _getholiday(dateNow.year.toString());
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
          if (_year != year) {
            _getholiday(year.toString());
            setState(() {});
          }
          _year = year;
          _month = month;
        });
      })
      ..addOnCalendarSelectListener((dateModel) {
        _dateModel = dateModel;
        // _getPerpetual(
        //     DateUtil.formatDate(dateModel.getDateTime(), format: 'yyyy-MM-dd'));

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
            20.hb,
            Row(
              children: [
                54.wb,
                GestureDetector(
                  onTap: () {
                    _calendarController.moveToPreviousYear();
                  },
                  child: Container(
                      color: Colors.transparent,
                      width: 14.rw,
                      height: 14.rw,
                      alignment: Alignment.center,
                      child: Image.asset(
                        R.ASSETS_LAST_YEAR_ICON_PNG,
                        width: 14.rw,
                        height: 14.rw,
                      )),
                  // Icon(
                  //   Icons.chevron_left_outlined,
                  //   size: 16.rw,
                  //   color: Color(0xFFA5A5A5),
                  // ),
                ),
                80.wb,
                GestureDetector(
                  onTap: () {
                    _calendarController.moveToPreviousMonth();
                  },
                  child: Container(
                      color: Colors.transparent,
                      width: 14.rw,
                      height: 14.rw,
                      alignment: Alignment.center,
                      child: Image.asset(
                        R.ASSETS_LAST_MONTH_ICON_PNG,
                        width: 7.rw,
                        height: 14.rw,
                      )),
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
                    child: Container(
                        color: Colors.transparent,
                        width: 14.rw,
                        height: 14.rw,
                        alignment: Alignment.center,
                        child: Image.asset(
                          R.ASSETS_NEXT_MONTH_ICON_PNG,
                          width: 7.rw,
                          height: 14.rw,
                        ))),
                80.wb,
                GestureDetector(
                    onTap: () {
                      _calendarController.moveToNextYear();
                    },
                    child: Container(
                        color: Colors.transparent,
                        width: 14.rw,
                        height: 14.rw,
                        alignment: Alignment.center,
                        child: Image.asset(
                          R.ASSETS_NEXT_YEAR_ICON_PNG,
                          width: 14.rw,
                          height: 14.rw,
                        ))),
                54.wb,
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: CalendarViewWidget(
                padding: EdgeInsets.symmetric(horizontal: 12.rw),
                weekBarItemWidgetBuilder: () {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CalendarWeekBarWidget(),
                      Divider(
                        height: 1.rw,
                        color: Color(0xFFDDDDDD),
                      ),
                      5.hb,
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
                    child: Opacity(
                      opacity: dateModel.isCurrentMonth ? 1 : 0.3,
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.rw,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.rw)),
                            color: _getColor(DateUtil.formatDate(
                                dateModel.getDateTime(),
                                format:
                                    'yyyy-MM-dd')), // DateUtil.formatDate(dateModel.getDateTime(), format: 'yyyy-MM-dd') Colors.white,
                            border: dateModel.isCurrentDay
                                ? Border.all(
                                    color: Color(0xFFDB2D2D), width: 1.rw)
                                : dateModel.isSelected
                                    ? Border.all(
                                        color: Color(0xFF007BFF), width: 1.rw)
                                    : null),
                        child: Column(
                          children: <Widget>[
                            // Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // _getHOrW(DateUtil.formatDate(
                                //             dateModel.getDateTime(),
                                //             format: 'yyyy-MM-dd')) !=
                                //         3
                                //     ? 20.wb
                                //     : SizedBox(),
                                Container(
                                    width: 37.rw,
                                    height: 25.rw,
                                    //color: Colors.blue,
                                    child: Stack(
                                      //color: Colors.blue,
                                      children: [
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                dateModel.day.toString(),
                                                textScaleFactor: 1,
                                                style: AppTextStyle.generate(
                                                    12.rsp,
                                                    fontWeight: FontWeight.w500,
                                                    color: _getHOrW(DateUtil.formatDate(
                                                                dateModel
                                                                    .getDateTime(),
                                                                format:
                                                                    'yyyy-MM-dd')) ==
                                                            1
                                                        ? Color(0xFFDB2D2D)
                                                        : AppColor
                                                            .textMainColor),
                                              ),
                                            )),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: _getHOrW(DateUtil.formatDate(
                                                        dateModel.getDateTime(),
                                                        format:
                                                            'yyyy-MM-dd')) !=
                                                    3
                                                ? _getText(dateModel)
                                                : SizedBox())
                                      ],

                                      // child: Row(
                                      //   children: [

                                      //   ],
                                      // ),
                                    ))
                              ],
                            ),
                            Text(
                              dateModel.lunarString,
                              style: TextStyle(
                                fontSize: 12.rsp,
                                color: dateModel.traditionFestival.isNotEmpty ||
                                        dateModel.solarTerm.isNotEmpty ||
                                        dateModel
                                            .gregorianFestival.isNotEmpty ||
                                        _getHOrW(DateUtil.formatDate(
                                                dateModel.getDateTime(),
                                                format: 'yyyy-MM-dd')) ==
                                            1
                                    ? Color(0xFFDB2D2D)
                                    : AppColor.textMainColor,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            15.hb,
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
                '农历' +
                    _perpetualCalendarModel.newslist.first.lubarmonth +
                    _perpetualCalendarModel.newslist.first.lunarday,
                style: TextStyle(color: Color(0xFF181818), fontSize: 16.rsp),
              ),
              Spacer(),
              Text(
                _perpetualCalendarModel.newslist.first.tiangandizhiyear +
                    '年 ' +
                    _perpetualCalendarModel.newslist.first.tiangandizhimonth +
                    '月 ' +
                    _perpetualCalendarModel.newslist.first.tiangandizhiday +
                    '日',
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
                _perpetualCalendarModel.newslist.first.festival.isNotEmpty ||
                        _perpetualCalendarModel
                            .newslist.first.lunarFestival.isNotEmpty
                    ? _perpetualCalendarModel.newslist.first.festival.isNotEmpty
                        ? '"${_perpetualCalendarModel.newslist.first.festival}"'
                        : _perpetualCalendarModel
                                .newslist.first.lunarFestival.isNotEmpty
                            ? '"${_perpetualCalendarModel.newslist.first.lunarFestival}"'
                            : ''
                    : '',
                style: TextStyle(color: Color(0xFF181818), fontSize: 16.rsp),
              ),
              Spacer(),
            ],
          ),
          40.hb,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                child: Text(_perpetualCalendarModel.newslist.first.fitness,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                child: Text(_perpetualCalendarModel.newslist.first.taboo,
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
        "http://api.tianapi.com/txapi/lunar/index?key=f2599751017c50b91d6f31261ce6dbc0&date=$time";
    Response res = await HttpManager.netFetchNormal(url, null, null, null);
    Map map = json.decode(res.data.toString());

    _perpetualCalendarModel = PerpetualCalendarModel.fromJson(map);
    print(_perpetualCalendarModel);
    setState(() {});
    //_homeWeatherModel = HomeWeatherModel.fromJson(map);
  }

  _getholiday(String time) async {
    String url =
        "http://api.tianapi.com/txapi/jiejiari/index?key=f2599751017c50b91d6f31261ce6dbc0&date=$time&type=1";
    Response res = await HttpManager.netFetchNormal(url, null, null, null);
    Map map = json.decode(res.data.toString());

    _holidayCalendarModel = HolidayCalendarModel.fromJson(map);
    print(_holidayCalendarModel);
    for (int i = 0; i < _holidayCalendarModel.newslist.length; i++) {
      if (_holiday.isNotEmpty)
        _holiday += _holidayCalendarModel.newslist[i].vacation + '|';
      else
        _holiday += _holidayCalendarModel.newslist[i].vacation;
      if (_workday.isNotEmpty)
        _workday += _holidayCalendarModel.newslist[i].remark + '|';
      else
        _workday += _holidayCalendarModel.newslist[i].vacation;
    }
    // _workday =
    //     '2021-01-01|2021-01-02|2021-01-03|2021-02-07|2021-02-20||2021-04-25|2021-05-08||2021-09-18|2021-09-26|2021-10-09|';
    // _holiday =
    //     '2021-01-01|2021-01-02|2021-01-032021-02-11|2021-02-12|2021-02-13|2021-02-14|2021-02-15|2021-02-16|2021-02-17|2021-04-03|2021-04-04|2021-04-05|2021-05-01|2021-05-02|2021-05-03|2021-05-04|2021-05-05|2021-06-12|2021-06-13|2021-06-14|2021-09-19|2021-09-20|2021-09-21|2021-10-01|2021-10-02|2021-10-03|2021-10-04|2021-10-05|2021-10-06|2021-10-07|';
    // print(_holiday);
    // print(_workday);
    setState(() {});
  }

  _getColor(String time) {
    Color color;
    if (_holiday.contains(time)) {
      color = Color(0xFFFFD3D3);
    } else if (_workday.contains(time)) {
      color = Color(0xFFEBEBEB);
    } else {
      color = Colors.white;
    }
    return color;
  }

  _getHOrW(String time) {
    //1 放假 2补班 3正常
    if (_holiday.contains(time)) {
      return 1;
    } else if (_workday.contains(time)) {
      return 2;
    } else {
      return 3;
    }
  }

  _getText(DateModel dateModel) {
    return Text(
      _getHOrW(DateUtil.formatDate(dateModel.getDateTime(),
                  format: 'yyyy-MM-dd')) ==
              1
          ? '休'
          : _getHOrW(DateUtil.formatDate(dateModel.getDateTime(),
                      format: 'yyyy-MM-dd')) ==
                  2
              ? '班'
              : '',
      textScaleFactor: 1,
      style: AppTextStyle.generate(10.rsp,
          fontWeight: FontWeight.w500,
          color: _getHOrW(DateUtil.formatDate(dateModel.getDateTime(),
                      format: 'yyyy-MM-dd')) ==
                  1
              ? Color(0xFFDB2D2D)
              : _getHOrW(DateUtil.formatDate(dateModel.getDateTime(),
                          format: 'yyyy-MM-dd')) ==
                      2
                  ? Color(0xFF999999)
                  : AppColor.textMainColor),
    );
  }
}
