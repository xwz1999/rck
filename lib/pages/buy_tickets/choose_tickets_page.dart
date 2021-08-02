import 'package:azlistview/azlistview.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/buy_tickets/models/airline_model.dart';
import 'package:recook/pages/buy_tickets/models/airport_city_model.dart';
import 'package:recook/pages/buy_tickets/tools/airport_city_tool.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/calendar/calendar_vertial_widget.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'airplane_reserve_page.dart';
import 'as_date_range_picker_part.dart';
import 'condition_picker.dart';
import 'functions/passager_func.dart';

class ChooseTicketsPage extends StatefulWidget {
  final String fromText; //出发地
  final String toText; //目的地
  final DateTime originDate; //出发日期
  final String code; //飞机票标准商品编号
  final List<AirportCityModel> list;
  ChooseTicketsPage(
      {Key key,
      @required this.fromText,
      @required this.toText,
      @required this.originDate,
      @required this.list,
      this.code})
      : super(key: key);

  @override
  _ChooseTicketsPageState createState() => _ChooseTicketsPageState();
}

class _ChooseTicketsPageState extends State<ChooseTicketsPage>
    with TickerProviderStateMixin {
  List<DateTime> _dateTableList = [];
  TabController _tabController;
  DateTime _dateNow = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0); //当天0点
  DateTime _chooseDate; //最终选中的日期
  int index = 0; //默认为选择日期在日期列表的位置
  bool _chooseState = true;
  bool _choosePriceSort = true;
  bool _sortPriceType = true; //1 低-高排序 2高-低排序
  bool _chooseTimeSort = false;
  bool _sortTimeType = true; //1 早-晚排序 2晚-早排序
  bool _chooseScreen = false;

  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);

  List<AirLineModel> _airLineList;
  List<AirportCityModel> _cityModelList = [];
  // List formList = [];
  // List toList = [];
  bool showList = false;
  @override
  void initState() {
    super.initState();
    _chooseDate = widget.originDate;
    _cityModelList = widget.list;
    // Future.delayed(Duration.zero, () async {
    //   _airLineList = await PassagerFunc.getAirLineList(
    //       _getAirport(widget.fromText),
    //       widget.code,
    //       DateUtil.formatDate(_chooseDate, format: 'yyyy-MM-dd'),
    //       _getAirport(widget.toText));
    // });

    initDate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.frenchColor,
        appBar: CustomAppBar(
          appBackground: Color(0xFFF9F9FB),
          elevation: 0,
          title: widget.fromText + '-' + widget.toText,
          themeData: AppThemes.themeDataGrey.appBarTheme,
        ),
        floatingActionButton: _chooseState
            ? Container(
                color: Colors.transparent,
                child: _chooseConditon(),
              )
            : SizedBox(),
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 48.rw,
                  alignment: Alignment.center,
                  color: Color(0xFFE51B25),
                  // width: DeviceInfo.screenWidth,
                  child: TabBar(
                      onTap: (index) {
                        _chooseDate = _dateTableList[index];
                        //initDate();
                        _refreshController.requestRefresh();
                        setState(() {});
                      },
                      isScrollable: true,
                      labelPadding: EdgeInsets.all(0),
                      controller: _tabController,
                      indicator: const BoxDecoration(),
                      unselectedLabelColor: Colors.black54,
                      labelStyle: TextStyle(color: Colors.black54),
                      tabs: _tabItems()),
                ).expand(),
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      CalendarVerticalWidget(
                        startDay: _chooseDate,
                        callBack: (BuildContext context, DateTime start) {
                          _chooseDate = start;
                          initDate();
                          setState(() {
                            //_tabController.animateTo(index);
                          });
                        },
                      ),
                      isScrollControlled: true,
                    );
                  },
                  child: Container(
                    height: 48.rw,
                    alignment: Alignment.center,
                    color: Color(0xFFD5101A),
                    width: 51.rw,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.rw),
                        color: Color(0xFFD5101A),
                      ),
                      margin: EdgeInsets.only(
                          left: 5.rw, right: 5.rw, top: 3.rw, bottom: 6.rw),
                      padding: EdgeInsets.only(left: 5.rw, right: 5.rw),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "全部\n日期",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.rsp,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: _buildListView(),
            )
          ],
        ));
  }

  List<Widget> _tabItems() {
    return _dateTableList.map<Widget>((item) {
      int index = _dateTableList.indexOf(item);
      return _tabItem(item, index);
    }).toList();
  }

  _tabItem(DateTime date, int index) {
    Color textColor =
        index == _tabController.index ? Color(0xFFE51B25) : Colors.white;
    return Tab(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.rw),
              color: index != _tabController.index
                  ? Color(0xFFE51B25)
                  : Colors.white),
          margin:
              EdgeInsets.only(left: 5.rw, right: 5.rw, top: 4.rw, bottom: 2.rw),
          padding: EdgeInsets.only(left: 5.rw, right: 5.rw),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DateUtil.formatDate(date, format: 'MM-dd'),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.rsp,
                    color: textColor),
              ),
              Text(
                // DateUtil.formatDate(date, format: 'MM-dd')
                getDayWeek(date),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.rsp,
                    color: textColor),
              ),
            ],
          ),
        ),
        index != _tabController.length - 1
            ? Opacity(
                opacity: 0.3,
                child: Container(
                  width: 1.rw,
                  height: 20.rw,
                  color: Colors.white,
                ),
              )
            : SizedBox(),
      ],
    ));
  }

  getDayWeek(DateTime date) {
    //获取当天是周几
    if (date == _dateNow) {
      return '今天';
    } else if (date == _dateNow.add(new Duration(days: 1))) {
      return '明天';
    } else if (date == _dateNow.add(new Duration(days: 2))) {
      return '后天';
    } else {
      return DateUtil.getWeekday(date, languageCode: 'zh', short: true);
    }
  }

  initDate() {
    int days = 0;
    _dateTableList.clear();
    //计算 选择日期和当天 天数间隔
    var endDate = new DateTime.now();
    var hours = _chooseDate.difference(endDate).inHours;

    if (hours <= 0) {
      days = hours ~/ 24;
    } else {
      days = hours ~/ 24 + 1;
    }
    if (days > 5) {
      index = days = 5;
    } else {
      index = days;
    }
    for (var i = 0; i < days; i++) {
      DateTime a = _chooseDate.add(new Duration(days: -days + i));
      _dateTableList.add(a);
    }
    for (var i = 0; i <= 5; i++) {
      DateTime a = _chooseDate.add(new Duration(days: i));
      _dateTableList.add(a);
    }
    _tabController = TabController(
      initialIndex: index,
      vsync: this,
      length: _dateTableList.length,
    );
  }

  _buildListView() {
    return RefreshWidget(
        controller: _refreshController,
        noData: '抱歉，没有找到您想要的班次',
        onRefresh: () async {
          Function cancel = ReToast.loading();
          _airLineList = await PassagerFunc.getAirLineList(
              _getAirportList(widget.fromText),
              widget.code,
              DateUtil.formatDate(_chooseDate, format: 'yyyy-MM-dd'),
              _getAirportList(widget.toText));
          showList = true;

          setState(() {});
          _refreshController.refreshCompleted();
          cancel();
        },
        body: _airLineList != null
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 80.rw),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _airLineList[0]
                    .airlinesListResponse
                    .airlines
                    .airline
                    .length, //_listViewController.getData().length,

                itemBuilder: (context, index) {
                  //GoodsSimple goods = _listViewController.getData()[index];
                  return MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // AppRouter.push(context, RouteName.COMMODITY_PAGE,
                        //     arguments: CommodityDetailPage.setArguments(goods.id));
                        Get.to(AirplaneReservePage());
                      },
                      child: _ticketsItem(_airLineList[0], index));
                })
            : showList
                ? noDataView('抱歉，没有找到您想要的班次')
                : SizedBox());
  }

  //获取城市的机场列表
  List<String> _getAirportList(String city) {
    if (_cityModelList != null) {
      int index = _cityModelList.indexWhere((element) => element.city == city);
      List<AirPorts> list = _cityModelList[index].airPorts;
      List<String> airportsList = [];
      for (int i = 0; i < list.length; i++) {
        airportsList.add(list[i].code);
      }
      return airportsList;
      // _cityModelList.forEach((element) {
      //   if (element.city == city) return element.airPorts;
      // });
    }
    return [];
  }

  // //获取出发机场名称
  // _getFormAirportByCode(String code) {
  //   if (_cityModelList != null) {
  //     formList = _getAirportList(widget.fromText);
  //     int index = formList.indexWhere((element) => element.code == code);
  //     return formList[index];
  //   }
  // }

  // //获取到达机场名称
  // _getToAirportByCode(String code) {
  //   if (_cityModelList != null) {
  //     toList = _getAirportList(widget.toText);
  //     int index = toList.indexWhere((element) => element.code == code);
  //     return toList[index];
  //   }
  // }

  _ticketsItem(AirLineModel model, int index) {
    return Container(
      padding:
          EdgeInsets.only(left: 20.rw, right: 15.rw, top: 10.rw, bottom: 7.rw),
      margin: EdgeInsets.only(top: 10.rw),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  child: CustomCacheImage(
                    borderRadius: BorderRadius.circular(5),
                    width: 28.rw,
                    height: 28.rw,
                    imageUrl: R.ASSETS_ORDER_ALERT_PNG,
                    fit: BoxFit.cover,
                  ),
                ),
                22.wb,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.airlinesListResponse.airlines.airline[index]
                                  .depTime,
                              style: TextStyle(
                                  fontSize: 18.rsp, color: Color(0xFF333333)),
                            ),
                            Text(
                              model.airlinesListResponse.airlines.airline[index]
                                  .orgCityName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12.rsp, color: Color(0xFF333333)),
                            ),
                          ],
                        ),
                        20.wb,
                        Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Icon(
                                Icons.arrow_right_alt,
                                color: Colors.black,
                                size: 20.rw,
                              ),
                              Text(
                                "2h25m",
                                style: TextStyle(
                                    fontSize: 12.rsp, color: Color(0xFF333333)),
                              ),
                            ],
                          ),
                        ),
                        20.wb,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.airlinesListResponse.airlines.airline[index]
                                  .arriTime,
                              style: TextStyle(
                                  fontSize: 18.rsp, color: Color(0xFF333333)),
                            ),
                            Text(
                              model.airlinesListResponse.airlines.airline[index]
                                  .dstCityName,
                              style: TextStyle(
                                  fontSize: 12.rsp, color: Color(0xFF333333)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    8.hb,
                    Text(
                      model.airlinesListResponse.airlines.airline[index]
                              .flightCompanyName +
                          model.airlinesListResponse.airlines.airline[index]
                              .flightNo +
                          "|" +
                          model.airlinesListResponse.airlines.airline[index]
                              .planeType,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 12.rsp, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "¥" + "400",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18.rsp, color: Color(0xFFD5101A)),
              ),
              Text(
                "2.8折经济仓",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10.rsp, color: Color(0xFF999999)),
              ),
              Text(
                "仅剩9张",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFFD5101A)),
              ),
            ],
          )
        ],
      ),
    );
  }

  _chooseConditon() {
    return Container(
      height: 48.rw,
      margin: EdgeInsets.only(left: 55.rw, right: 55.rw, bottom: 10.rw),
      //padding: EdgeInsets.symmetric(horizontal: 55.rw),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(24.rw),
              right: Radius.circular(24.rw)), //BorderRadius.circular(24.rw),
          color: Colors.white),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              Options options =
                  await show2DatePicker(context, date: _chooseDate);
              if (options.arrive != '' ||
                  options.depart != '' ||
                  options.date != '' ||
                  options.company != '' ||
                  options.space != '') {
                _chooseScreen = true;
                setState(() {});
              } else if (options.arrive == '' &&
                  options.depart == '' &&
                  options.date == '' &&
                  options.company == '' &&
                  options.space == '') {
                _chooseScreen = false;
                setState(() {});
              }
            },
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    AppIcons.icon_training,
                    size: rSize(14),
                    color: Colors.grey,
                  ),
                  Text(
                    '筛选条件',
                    style: TextStyle(
                        color: _chooseScreen ? Colors.red : Colors.black,
                        fontSize: 12.rsp),
                  ),
                ],
              ),
            ),
          ).expand(),
          GestureDetector(
              onTap: () {
                _choosePriceSort = true;
                _sortPriceType = !_sortPriceType;
                _chooseTimeSort = false;
                setState(() {});
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  _choosePriceSort
                      ? _sortPriceType
                          ? '价格低-高'
                          : '价格高-低'
                      : '价格排序',
                  style: TextStyle(
                      color: _choosePriceSort ? Colors.red : Colors.black,
                      fontSize: 12.rsp),
                ),
              )).expand(),
          GestureDetector(
            onTap: () {
              _choosePriceSort = false;
              _chooseTimeSort = true;
              _sortTimeType = !_sortTimeType;
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                _chooseTimeSort
                    ? _sortTimeType
                        ? '时间早-晚'
                        : '时间晚-早'
                    : '时间排序',
                style: TextStyle(
                    color: _chooseTimeSort ? Colors.red : Colors.black,
                    fontSize: 12.rsp),
              ),
            ),
          ).expand(),
        ],
      ),
    );
  }

  noDataView(String text) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(top: 100.rw),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            R.ASSETS_TICKET_TICKET_NODATA_ICON_PNG,
            width: rSize(144.rw),
            height: rSize(126.rw),
          ),
//          Icon(AppIcons.icon_no_data_search,size: rSize(80),color: Colors.grey),
          40.hb,
          Text(
            text,
            style: AppTextStyle.generate(12.rsp, color: Color(0xFF333333)),
          ),
          SizedBox(
            height: rSize(30),
          )
        ],
      ),
    );
  }
}
