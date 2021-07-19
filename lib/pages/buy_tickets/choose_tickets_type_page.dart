import 'dart:io';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/widgets/calendar/calendar_vertial_widget.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/weather_page/weather_city_model.dart';
import 'package:velocity_x/velocity_x.dart';

import 'choose_city_page.dart';

class ChooseTicketsTypePage extends StatefulWidget {
  ChooseTicketsTypePage({Key key}) : super(key: key);

  @override
  _ChooseTicketsTypePageState createState() => _ChooseTicketsTypePageState();
}

class _ChooseTicketsTypePageState extends State<ChooseTicketsTypePage> {
  //按钮选中类型
  int _chooseType = 1; //1为飞机票 2为汽车票 3为火车票
  String _originText = '出发地';
  String _destinationText = '选择到达';
  //定位
  AMapFlutterLocation _amapFlutterLocation;
  Map<String, Object> _location;
  WeatherCityModel cityModel;
  DateTime _date = DateTime.now();
  String _dateText = DateUtil.formatDate(DateTime.now(), format: 'M月d日');
  //DateTime _selectedDay;
  //CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  void initState() {
    super.initState();
    _amapFlutterLocation = AMapFlutterLocation();

    requestPermission().then((value) {
      if (value) {
        //监听要在设置参数之前 否则无法获取定位
        _amapFlutterLocation.onLocationChanged().listen(
          (event) {
            _location = event;
            _originText = _location['city'];
            setState(() {});
          },
        );
        _amapFlutterLocation
            .setLocationOption(AMapLocationOption(onceLocation: true));
        _amapFlutterLocation.startLocation();
      } else {
        ReToast.err(text: '未获取到定位权限，请先在设置中打开定位权限');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.frenchColor,
        appBar: CustomAppBar(
          appBackground: Color(0xFFF9F9FB),
          elevation: 0,
          title: '瑞库客购票',
          themeData: AppThemes.themeDataGrey.appBarTheme,
        ),
        body: _bodyWidget());
  }

  _bodyWidget() {
    return Container(
      decoration: new BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.rw))),
      margin: EdgeInsets.symmetric(horizontal: 10.rw, vertical: 10.rw),
      height: 272.rw,
      child: Column(
        children: [
          _chooseTab(),
          Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.rw))),
            //margin: EdgeInsets.symmetric(horizontal: 10.rw, vertical: 10.rw),
            height: 222.rw,
            child: Column(
              children: [
                _choosePlace(),
                _divider(),
                _chooseDate(),
                _divider(),
                _btnWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _chooseTab() {
    return Row(
      children: [
        GestureDetector(
          //飞机票
          onTap: () {
            _chooseType = 1;
            setState(() {});
          },
          child: Column(
            children: [
              Container(
                height: 10.rw,
                decoration: _chooseType == 1
                    ? new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(50.rw)))
                    : new BoxDecoration(
                        color: Colors.transparent,
                      ),
              ),
              Container(
                decoration: new BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFF8F7F8), Colors.white])),
                child: Container(
                  alignment: Alignment.center,
                  height: 40.rw,
                  decoration: _chooseType == 1
                      ? new BoxDecoration(color: Colors.white)
                      : _chooseType == 2
                          ? new BoxDecoration(
                              color: Color(0xFFFCE7E5),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.rw),
                                  bottomRight: Radius.circular(10.rw)))
                          : new BoxDecoration(
                              color: Color(0xFFFCE7E5),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.rw))),
                  child: Text('飞机票',
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      )),
                ),
              )
            ],
          ),
        ).expand(),
        GestureDetector(
          //汽车票
          onTap: () {
            _chooseType = 2;
            setState(() {});
          },
          child: Column(
            children: [
              Container(
                height: 10.rw,
                decoration: _chooseType == 2
                    ? new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(50.rw)))
                    : new BoxDecoration(
                        color: Color(0xFFF8F7F8),
                      ),
              ),
              Container(
                decoration: new BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFF8F7F8), Colors.white])),
                child: Container(
                  alignment: Alignment.center,
                  height: 40.rw,
                  decoration: _chooseType == 2
                      ? new BoxDecoration(
                          color: Colors.white,
                        )
                      : _chooseType == 1
                          ? new BoxDecoration(
                              color: Color(0xFFFCE7E5),
                              border: new Border.all(
                                  color: Color(0xFFFCE7E5), width: 1.rw),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.rw)))
                          : new BoxDecoration(
                              color: Color(0xFFFCE7E5),
                              border: new Border.all(
                                  color: Color(0xFFFCE7E5), width: 1.rw),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10.rw))),
                  child: Text('汽车票',
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      )),
                ),
              )
            ],
          ),
        ).expand(),
        GestureDetector(
          //火车票
          onTap: () {
            _chooseType = 3;
            setState(() {});
          },
          child: Column(
            children: [
              Container(
                height: 10.rw,
                decoration: _chooseType == 3
                    ? new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(50.rw)))
                    : new BoxDecoration(
                        color: Color(0xFFF8F7F8),
                      ),
              ),
              Container(
                decoration: new BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFF8F7F8), Colors.white])),
                child: Container(
                  alignment: Alignment.center,
                  height: 40.rw,
                  decoration: _chooseType == 3
                      ? new BoxDecoration(
                          color: Colors.white,
                        )
                      : _chooseType == 1
                          ? new BoxDecoration(
                              color: Color(0xFFFCE7E5),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.rw)))
                          : new BoxDecoration(
                              color: Color(0xFFFCE7E5),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.rw),
                                  bottomLeft: Radius.circular(10.rw))),
                  child: Text('火车票',
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      )),
                ),
              )
            ],
          ),
        ).expand(),
      ],
    );
  }

  _choosePlace() {
    String locationCityName =
        _location != null && !TextUtils.isEmpty(_location['city'])
            ? _location['city']
            : "";
    try {
      locationCityName = locationCityName.replaceAll("区", "");
      locationCityName = locationCityName.replaceAll("市", "");
    } catch (e) {}
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: 80.rw,
      child: Row(
        children: [
          GestureDetector(
              onTap: () async {
                cityModel = await Get.to(() => ChooseCityPage(
                    arguments: ChooseCityPage.setArguments(locationCityName)));
                if (cityModel != null) {
                  _originText = cityModel.cityZh;
                  setState(() {});
                }
              },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(_originText,
                    style: TextStyle(
                      fontSize: 22.rsp,
                      color: Color(0xFF333333),
                    )),
              )).expand(),
          Container(
              alignment: Alignment.center,
              child: Icon(Icons.keyboard_arrow_right,
                  size: 50, color: Colors.red)),
          GestureDetector(
              onTap: () async {
                cityModel = await Get.to(() => ChooseCityPage(
                    arguments: ChooseCityPage.setArguments(locationCityName)));
                _destinationText = cityModel.cityZh;
                setState(() {});
              },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(_destinationText,
                    style: TextStyle(
                      fontSize: 22.rsp,
                      color: Color(0xFF333333),
                    )),
              )).expand(),
        ],
      ),
    );
  }

  _divider() {
    return Divider(
      height: 1.rw,
      indent: 20.rw,
      endIndent: 20.rw,
      color: Color(0xFFEEEEEE),
    );
  }

  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      return true;
    }
    bool permission = await Permission.locationWhenInUse.isRestricted;
    bool permanentDenied =
        await Permission.locationWhenInUse.isPermanentlyDenied;
    if (!permission) {
      await Permission.locationWhenInUse.request();
      if (permanentDenied) {
        await PermissionTool.showOpenPermissionDialog(context, '打开定位权限');
      }
      permission = await Permission.locationWhenInUse.isGranted;
    }
    return permission;
  }

  _chooseDate() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: 49.rw,
      child: Row(
        children: [
          40.wb,
          GestureDetector(
              onTap: () {
                _date = _date.add(new Duration(days: -1));
                setState(() {});
              },
              child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      50.hb,
                      Text("前一天",
                          style: TextStyle(
                            fontSize: 10.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ))),
          GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  _dateWidget(),
                  isScrollControlled: true,
                );
                //setState(() {});
              },
              child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateUtil.formatDate(_date, format: 'M月d日'),
                          style: TextStyle(
                            fontSize: 22.rsp,
                            color: Color(0xFF333333),
                          )),
                      3.wb,
                      DateUtil.formatDate(_date, format: 'M月d日') == _dateText
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                18.hb,
                                Text("今天",
                                    style: TextStyle(
                                      fontSize: 14.rsp,
                                      color: Color(0xFF333333),
                                    )),
                              ],
                            )
                          : SizedBox()
                    ],
                  ))).expand(),
          GestureDetector(
              onTap: () {
                _date = _date.add(new Duration(days: 1));

                setState(() {});
              },
              child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      50.hb,
                      Text("后一天",
                          style: TextStyle(
                            fontSize: 10.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ))),
          40.wb,
        ],
      ),
    );
  }

  _btnWidget() {
    return Container(
      height: 91.rw,
      color: Colors.white,
      padding: EdgeInsets.only(top: 29.rw, bottom: 20.rw),
      margin: EdgeInsets.symmetric(horizontal: 20.rw),
      alignment: Alignment.center,
      child: CustomImageButton(
        height: 42,
        padding: EdgeInsets.symmetric(vertical: 8),
        title: "马上查询",
        backgroundColor: AppColor.themeColor,
        color: Colors.white,
        fontSize: 16 * 2.sp,
        borderRadius: BorderRadius.all(Radius.circular(2)),
        onPressed: () {
          print('查询');
        },
      ),
    );
  }

  _dateWidget() {
    return CalendarVerticalWidget(
      startDay: _date,
      //endDay: _date,
      callBack: (BuildContext context, DateTime start) {
        _date = start;
        setState(() {});
      },
    );
  }

  // _dateWidget() {
  //   return Container(
  //     height: 448.rw,
  //     color: Colors.white,
  //     child: TableCalendar(
  //       //availableGestures: (AvailableGestures.verticalSwipe),
  //       calendarBuilders: CalendarBuilders(),
  //       daysOfWeekHeight: 20.rw,
  //       locale: 'zh_CN',
  //       headerStyle: HeaderStyle(
  //         titleTextStyle: TextStyle(
  //           color: Colors.black,
  //           fontSize: 20.0,
  //         ),
  //         titleCentered: true,
  //         leftChevronVisible: true,
  //         rightChevronVisible: true,
  //         formatButtonVisible: false,
  //       ),
  //       rangeStartDay: DateTime.utc(2021, 7, 16),
  //       rangeEndDay: DateTime.utc(2021, 8, 15),
  //       calendarStyle: CalendarStyle(
  //         defaultTextStyle: TextStyle(
  //           color: Color(0xFFCCCCCC),
  //           fontSize: 16.0,
  //         ),

  //         weekendTextStyle: TextStyle(
  //           color: Color(0xFFCCCCCC),
  //           fontSize: 16.0,
  //         ),
  //         rangeHighlightColor: Colors.transparent,
  //         rangeStartDecoration: (BoxDecoration(color: Colors.transparent)),
  //         rangeStartTextStyle: TextStyle(
  //           color: Colors.black,
  //           fontSize: 16.0,
  //         ),
  //         rangeEndTextStyle: TextStyle(
  //           color: Colors.black,
  //           fontSize: 16.0,
  //         ),
  //         withinRangeTextStyle: TextStyle(
  //           color: Colors.black,
  //           fontSize: 16.0,
  //         ),
  //         outsideDaysVisible: false,
  //         todayTextStyle: TextStyle(
  //           color: Colors.blue,
  //           fontSize: 26.0,
  //         ),
  //         // disabledTextStyle: TextStyle(
  //         //   color: Color(0xFFCCCCCC),
  //         //   fontSize: 16.0,
  //         // ),
  //       ),
  //       firstDay: DateTime.utc(2021, 6, 1),
  //       lastDay: DateTime.utc(2021, 8, 1),
  //       focusedDay: _date,
  //       selectedDayPredicate: (day) {
  //         return isSameDay(_selectedDay, day);
  //       },
  //       onDaySelected: (selectedDay, focusedDay) {
  //         if (!isSameDay(_selectedDay, selectedDay)) {
  //           setState(() {
  //             _selectedDay = selectedDay;
  //             _date = focusedDay; // update `_focusedDay` here as well
  //           });
  //         }
  //       },
  //       onFormatChanged: (format) {
  //         if (_calendarFormat != format) {
  //           // Call `setState()` when updating calendar format
  //           setState(() {
  //             _calendarFormat = format;
  //           });
  //         }
  //       },
  //       onPageChanged: (focusedDay) {
  //         // No need to call `setState()` here
  //         _date = focusedDay;
  //       },
  //     ),
  //   );
  // }
}
