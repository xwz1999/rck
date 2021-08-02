import 'dart:io';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/buy_tickets/tickets_order_page.dart';
import 'package:recook/pages/buy_tickets/tools/airport_city_tool.dart';
import 'package:recook/pages/buy_tickets/used_passager_page.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/calendar/calendar_vertial_widget.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/weather_page/weather_city_model.dart';
import 'package:velocity_x/velocity_x.dart';

import 'choose_city_page.dart';
import 'choose_tickets_page.dart';
import 'functions/passager_func.dart';
import 'models/air_items_list_model.dart';
import 'models/airport_city_model.dart';

class ChooseTicketsTypePage extends StatefulWidget {
  ChooseTicketsTypePage({Key key}) : super(key: key);

  @override
  _ChooseTicketsTypePageState createState() => _ChooseTicketsTypePageState();
}

class _ChooseTicketsTypePageState extends State<ChooseTicketsTypePage> {
  final items = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.pages,
        size: rSize(14),
        color: Color(0xFF666666),
      ),
      title: Text('订单'),
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.pages,
          size: rSize(14),
          color: Color(0xFF666666),
        ),
        title: Text("常用旅客")),
  ];
  //按钮选中类型
  int _chooseType = 1; //1为飞机票 2为汽车票 3为火车票
  String _originText = '出发地';
  String _destinationText = '选择到达';
  //定位
  AMapFlutterLocation _amapFlutterLocation;
  Map<String, Object> _location;
  AirportCityModel cityModel;
  DateTime _date = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  String _dateText = DateUtil.formatDate(DateTime.now(), format: 'M月d日');
  AirItemModel airItemModel;
  String goodId;
  List notCity = [
    '',
  ];
  List<AirportCityModel> _cityModelList;
  //DateTime _selectedDay;
  //CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      airItemModel = await PassagerFunc.getAirTicketGoodsList();
      print(airItemModel.items.item[0].itemId);
      goodId = airItemModel.items.item[0].itemId;
    });

    _amapFlutterLocation = AMapFlutterLocation();
    requestPermission().then((value) {
      if (value) {
        //监听要在设置参数之前 否则无法获取定位
        _amapFlutterLocation.onLocationChanged().listen(
          (event) {
            _location = event;
            print(_location);
            _originText = _location['city'];
            _originText = _originText.replaceAll('市', '');
            _originText = _originText.replaceAll('区', '');
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
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          onTap: onTap,
          backgroundColor: Colors.white,
          unselectedItemColor: Color(0xFF666666),
          selectedItemColor: Color(0xFF666666),
          type: BottomNavigationBarType.fixed,
        ),
        body: _bodyWidget());
  }

  void onTap(int index) {
    if (index == 0) {
      Get.to(TicketsOrderPage(ticketType: 1,));
    } else {
      Get.to(UsedPassagerPage());
    }
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          R.ASSETS_AIR_ICON_PNG,
                          width: 14.rw,
                          height: 14.rw,
                        ),
                        12.wb,
                        Text('飞机票',
                            style: TextStyle(
                              fontSize: 10.rsp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            )),
                      ],
                    )),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        R.ASSETS_TICKET_BUS_ICON_PNG,
                        width: 14.rw,
                        height: 14.rw,
                      ),
                      12.wb,
                      Text('汽车票',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        R.ASSETS_TICKET_TRAIN_ICON_PNG,
                        width: 14.rw,
                        height: 14.rw,
                      ),
                      12.wb,
                      Text('火车票',
                          style: TextStyle(
                            fontSize: 10.rsp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ),
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
                      arguments: ChooseCityPage.setArguments(locationCityName),
                      type: 1,
                    ));
                if (cityModel != null) {
                  _originText = cityModel.city;

                  setState(() {});
                }
              },
              child: Container(
                padding: EdgeInsets.only(left: 10.rw),
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(_originText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.rsp,
                      color: Color(0xFF333333),
                    )),
              )).expand(),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              R.ASSETS_TICKET_COME_GO_ICON_PNG,
              width: 30.rw,
              height: 30.rw,
            ),
          ),
          GestureDetector(
              onTap: () async {
                cityModel = await Get.to(() => ChooseCityPage(
                      arguments: ChooseCityPage.setArguments(locationCityName),
                      type: 1,
                    ));
                _destinationText = cityModel.city;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(left: 10.rw),
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(_destinationText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: _destinationText != '选择到达'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 22.rsp,
                      color: _destinationText != '选择到达'
                          ? Color(0xFF333333)
                          : Color(0xFF999999),
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
              onTap: _date.day != DateTime.now().day
                  ? () {
                      _date = _date.add(new Duration(days: -1));

                      setState(() {});
                    }
                  : () {},
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
                            fontWeight: FontWeight.bold,
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
        onPressed: () async {
          if (_originText == '出发地' || _originText == null || _date == null) {
            Alert.show(
                context,
                NormalTextDialog(
                  type: NormalTextDialogType.normal,
                  title: "提示",
                  content: "请您先选择出发地",
                  items: ["确认"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                ));
          } else if (_destinationText == '选择到达' || _destinationText == null) {
            Alert.show(
                context,
                NormalTextDialog(
                  type: NormalTextDialogType.normal,
                  title: "提示",
                  content: "请您先选择目的地",
                  items: ["确认"],
                  listener: (index) {
                    Alert.dismiss(context);
                  },
                ));
          } else {
            //airportCityModel = await PassagerFunc.getCityAirportList();
            _cityModelList =
                await AriportCityTool.getInstance().getCityAirportList();
            print(_date);
            Get.to(ChooseTicketsPage(
                fromText: _originText,
                toText: _destinationText,
                originDate: _date,
                code: goodId,
                list: _cityModelList));
          }
          print('查询');
        },
      ),
    );
  }

  _dateWidget() {
    return CalendarVerticalWidget(
      startDay: _date,
      callBack: (BuildContext context, DateTime start) {
        _date = start;
        setState(() {});
      },
    );
  }
}
