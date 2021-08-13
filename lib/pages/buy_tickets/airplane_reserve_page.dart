import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/buy_tickets/models/airline_model.dart';
import 'package:recook/utils/date/date_utils.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

import 'airplane_detail_page.dart';

class AirplaneReservePage extends StatefulWidget {
  final List<Airline> airline;
  final String fromText; //出发地
  final String toText; //目的地
  final DateTime originDate; //出发日期
  final int index;
  final String itemId;
  AirplaneReservePage(
      {Key key,
      this.airline,
      this.fromText,
      this.toText,
      this.originDate,
      this.index,
      this.itemId})
      : super(key: key);

  @override
  _AirplaneReservePageState createState() => _AirplaneReservePageState();
}

class _AirplaneReservePageState extends State<AirplaneReservePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  DateTime _dateNow = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0); //当天0点
  List<AirSeat> _firstclassList = [];
  List<AirSeat> _economyclassList = [];
  Airline airline;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.airline != null) {
      if (widget.airline.length > 0) {
        airline = widget.airline[widget.index];
        airline.airSeats.airSeat.forEach((element) {
          if (element.seatMsg == '商务舱' || element.seatMsg == '头等舱') {
            _firstclassList.add(element);
          } else if (element.seatMsg != '商务舱' &&
              element.seatMsg != '头等舱' &&
              element.discount <= 1) {
            _economyclassList.add(element);
          }
        });
        print(widget.airline);
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
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
        ));
  }

  _bodyWidget() {
    return Container(
      child: Column(
        children: [_information(), _tabBarView(), _ticketsList()],
      ),
    );
  }

  _information() {
    return Container(
      margin: EdgeInsets.only(top: 10.rw),
      height: 121.rw,
      color: Colors.white,
      child: Column(
        children: [
          20.hb,
          Row(
            children: [
              Row(
                children: [
                  50.wb,
                  Text(
                    airline.flightCompanyName + airline.flightNo,
                    style:
                        TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
              40.wb,
              Container(
                child: Text(
                  DateUtil.formatDate(widget.originDate, format: 'MM月dd日') +
                      " " +
                      getDayWeek(widget.originDate),
                  style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                ),
              )
            ],
          ),
          20.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    airline.depTime,
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFF333333)),
                  ),
                  Text(
                    airline.orgCityName,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
              40.wb,
              Container(
                //height: 53.rw,
                margin: EdgeInsets.only(bottom: 25.rw),
                child: Column(
                  children: [
                    Text(
                      DateUtilss.getTimeReduce(
                          airline.depTime, airline.arriTime),
                      style:
                          TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                    ),
                    10.hb,
                    Image.asset(
                      R.ASSETS_TICKET_GOTO2_ICON_PNG,
                      width: 68.rw,
                      height: 7.rw,
                    ),
                  ],
                ),
              ),
              40.wb,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    airline.arriTime,
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFF333333)),
                  ),
                  Text(
                    airline.dstCityName,
                    style:
                        TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
            ],
          ),
          8.hb,
          Text(
            _getPlaneNameByType(airline.planeType),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12.rsp, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  _getPlaneNameByType(String type) {
    String first = type.substring(0, 1);
    if (first == "7") {
      return '波音' + type;
    } else if (first == '3') {
      return '空客' + type;
    } else {
      return type;
    }
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

  _tabBarView() {
    return Container(
      margin: EdgeInsets.all(10.rw),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4.rw)),
      alignment: Alignment.center,
      child: TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 40.rw),
        isScrollable: true,
        controller: _tabController,
        labelColor: Color(0xFF333333),
        unselectedLabelColor: Color(0xFF333333).withOpacity(0.3),
        labelStyle: TextStyle(
          fontSize: 16.rsp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16.rsp,
          fontWeight: FontWeight.w400,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: RecookIndicator(
          borderSide: BorderSide(
            width: rSize(3),
            color: Color(0xFFDB2D2D),
          ),
        ),
        tabs: [
          Tab(text: '经济仓'),
          Tab(text: '商务/头等仓'),
        ],
      ),
    );
  }

  _ticketsList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.rw),
      child: TabBarView(
        controller: _tabController,
        children: [
          _economyList(),
          _firstList(),
        ],
      ),
    ).expand();
  }

//头等舱
  _firstList() {
    return _firstclassList != null
        ? ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _firstclassList.length,
            itemBuilder: (context, index) {
              return _firstclassList.length > 0
                  ? _firstItem(_firstclassList[index], 2, index)
                  : SizedBox();
            })
        : SizedBox();
  }

  _economyList() {
    return _economyclassList != null
        ? ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _economyclassList.length,
            itemBuilder: (context, index) {
              return _economyclassList.length > 0
                  ? _firstItem(_economyclassList[index], 1, index)
                  : SizedBox();
            })
        : SizedBox();
  }

  _firstItem(AirSeat model, int type, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.rw),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(bottom: 10.rw),
      padding: EdgeInsets.only(left: 14.rw, right: 14.rw, top: 10.rw),
      height: 118.rw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "¥",
                    style:
                        TextStyle(fontSize: 12.rsp, color: Color(0xFFC92219)),
                  ),
                  Text(
                    model.parPrice.toString(),
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFFC92219)),
                  ),
                ],
              ),
              20.hb,
              Text(
                '儿童票，婴儿暂不可预订',
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
              ),
              10.hb,
              Row(
                children: [
                  Text(
                    type == 1 ? '免费托运20KG行李' : '免费托运30KG行李',
                    style:
                        TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 10.rw, bottom: 2.rw),
                  //     child: Icon(
                  //       AppIcons.icon_next,
                  //       size: 12.rw,
                  //       color: Color(0xFF999999),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              10.hb,
              Text(
                type == 1
                    ? model.discount != 1
                        ? (model.discount * 10).toStringAsFixed(2) +
                            '折' +
                            model.seatMsg
                        : '全价' + model.seatMsg
                    : model.seatMsg,
                style: TextStyle(fontSize: 10.rsp, color: Color(0xFF666666)),
              ),
            ],
          ),
          Column(
            children: [
              10.hb,
              model.seatStatus != 'A'
                  ? CustomImageButton(
                      padding: EdgeInsets.zero,
                      boxDecoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Color(0xFFC92219),
                          blurRadius: 4.rw,
                        )
                      ]),
                      height: 38.rw,
                      width: 44.rw,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 24.rw,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFFF493F),
                                  Color(0xFFC92219),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.rw)),
                            ),
                            child: Text('预订',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.rsp,
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 14.rw,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4.rw),
                                  bottomRight: Radius.circular(4.rw)),
                            ),
                            child: Text("余" + model.seatStatus + "张",
                                style: TextStyle(
                                  color: Color(0xFFF64239),
                                  fontSize: 10.rsp,
                                )),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Get.to(AirplaneDetailPage(
                            airline: widget.airline,
                            airlineindex: widget.index,
                            airSeat: type == 1
                                ? _economyclassList[index]
                                : _firstclassList[index],
                            fromText: widget.fromText,
                            toText: widget.toText,
                            originDate: widget.originDate,
                            itemId: widget.itemId));
                      },
                    )
                  : CustomImageButton(
                      height: 38.rw,
                      width: 44.rw,
                      title: "预订",
                      boxDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFFF493F),
                            Color(0xFFC92219),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4.rw)),
                      ),
                      backgroundColor: Color(0xFFC92219),
                      color: Colors.white,
                      fontSize: 16.rsp,
                      onPressed: () {
                        Get.to(AirplaneDetailPage(
                            airline: widget.airline,
                            airlineindex: widget.index,
                            airSeat: type == 1
                                ? _economyclassList[index]
                                : _firstclassList[index],
                            fromText: widget.fromText,
                            toText: widget.toText,
                            originDate: widget.originDate,
                            itemId: widget.itemId));
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
