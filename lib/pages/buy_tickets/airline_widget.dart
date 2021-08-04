import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';

import 'package:recook/pages/buy_tickets/models/airline_model.dart';
import 'package:recook/pages/buy_tickets/models/airport_city_model.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/utils/date/date_utils.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_cache_image.dart';

import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import 'airplane_reserve_page.dart';

import 'as_date_range_picker_part.dart';
import 'condition_picker.dart';
import 'functions/passager_func.dart';

class AirlineWidget extends StatefulWidget {
  final String fromText; //出发地
  final String toText; //目的地
  final DateTime originDate; //出发日期
  final String code; //飞机票标准商品编号
  final List<AirportCityModel> cityModelList;

  AirlineWidget(
      {Key key,
      this.cityModelList,
      this.fromText,
      this.toText,
      this.originDate,
      this.code})
      : super(key: key);

  @override
  _AirlineWidgetState createState() => _AirlineWidgetState();
}

class _AirlineWidgetState extends State<AirlineWidget> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  List<AirLineModel> _airLineList = [];
  bool showList = false;
  bool _chooseState = true;
  DateTime _chooseDate; //最终选中的日期
  int index = 0; //默认为选择日期在日期列表的位置
  bool _choosePriceSort = true;
  bool _sortPriceType = true; //1 低-高排序 2高-低排序
  bool _chooseTimeSort = false;
  bool _sortTimeType = true; //1 早-晚排序 2晚-早排序
  bool _chooseScreen = false;
  List<String> fromList = [];
  List<String> toList = [];

  Timer _timer;
  int _countdownTime = 10 * 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.frenchColor,
        floatingActionButton: _chooseState
            ? Container(
                color: Colors.transparent,
                child: _chooseConditon(),
              )
            : SizedBox(),
        body: _buildListView());
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    startCountdownTimer();
    fromList = _getAirportList(widget.fromText);
    toList = _getAirportList(widget.toText);
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer.cancel();
              Alert.show(
                  context,
                  NormalTextDialog(
                    type: NormalTextDialogType.normal,
                    title: "提示",
                    content: "这一天的航班信息有所变化，已为您更新了信息",
                    items: ["确认"],
                    listener: (index) {
                      Alert.dismiss(context);
                      _refreshController.requestRefresh();
                    },
                  ));
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };

    _timer = Timer.periodic(oneSec, callback);
  }

  _buildListView() {
    return RefreshWidget(
        controller: _refreshController,
        noData: '抱歉，没有找到您想要的班次',
        onRefresh: () async {
          Function cancel = ReToast.loading();

          _airLineList = await PassagerFunc.getAirLineList(
              fromList,
              widget.code,
              DateUtil.formatDate(widget.originDate, format: 'yyyy-MM-dd'),
              toList);

          showList = true;

          setState(() {});
          _refreshController.refreshCompleted();
          cancel();
        },
        body: _airLineList.length > 0 &&
                _airLineList.first.airlinesListResponse.airlines.airline != null
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
                        Get.to(AirplaneReservePage(
                          fromText: widget.fromText,
                          toText: widget.toText,
                          originDate: widget.originDate,
                          airline: _airLineList
                              .first.airlinesListResponse.airlines.airline,
                          index: index,
                        ));
                      },
                      child: _ticketsItem(_airLineList[0], index));
                })
            : showList
                ? noDataView('抱歉，没有找到您想要的班次')
                : SizedBox());
  }

  List<String> _getAirportList(String city) {
    if (widget.cityModelList != null) {
      int index =
          widget.cityModelList.indexWhere((element) => element.city == city);
      List<AirPorts> list = widget.cityModelList[index].airPorts;
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

  List<String> _getAirportNameList(String city) {
    if (widget.cityModelList != null) {
      int index =
          widget.cityModelList.indexWhere((element) => element.city == city);
      List<AirPorts> list = widget.cityModelList[index].airPorts;
      List<String> airportsList = [];
      for (int i = 0; i < list.length; i++) {
        airportsList.add(list[i].name);
      }
      return airportsList;
      // _cityModelList.forEach((element) {
      //   if (element.city == city) return element.airPorts;
      // });
    }
    return [];
  }

  _getAirportCode(String city, String airport) {
    if (widget.cityModelList != null) {
      int index =
          widget.cityModelList.indexWhere((element) => element.city == city);
      List<AirPorts> list = widget.cityModelList[index].airPorts;

      int airportIndex = list.indexWhere((element) => element.name == airport);
      List<String> airportsCodeList = [];
      airportsCodeList.add(list[airportIndex].code);
      return airportsCodeList;
      // _cityModelList.forEach((element) {
      //   if (element.city == city) return element.airPorts;
      // });
    }
    return [];
  }

  _ticketsItem(AirLineModel model, int index) {
    return Container(
      padding:
          EdgeInsets.only(left: 10.rw, right: 15.rw, top: 10.rw, bottom: 7.rw),
      margin: EdgeInsets.only(top: 10.rw),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                22.wb,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.airlinesListResponse.airlines.airline[index]
                                  .depTime,
                              style: TextStyle(
                                  fontSize: 18.rsp, color: Color(0xFF333333)),
                            ),
                            20.wb,
                            Container(
                              //alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(bottom: 5.rw),
                              child: Column(
                                children: [
                                  Text(
                                    DateUtilss.getTimeReduce(
                                        model.airlinesListResponse.airlines
                                            .airline[index].depTime,
                                        model.airlinesListResponse.airlines
                                            .airline[index].arriTime),
                                    style: TextStyle(
                                        fontSize: 12.rsp,
                                        color: Color(0xFF333333)),
                                  ),
                                  Image.asset(
                                    R.ASSETS_TICKET_GOTO2_ICON_PNG,
                                    height: rSize(5.rw),
                                    width: rSize(103.rw),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ],
                              ),
                            ),
                            20.wb,
                            Text(
                              model.airlinesListResponse.airlines.airline[index]
                                  .arriTime,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18.rsp, color: Color(0xFF333333)),
                            ),
                          ],
                        ),
                        20.wb,
                        Container(
                          width: 220.rw,
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model.airlinesListResponse.airlines
                                    .airline[index].orgCityName,
                                style: TextStyle(
                                    fontSize: 12.rsp, color: Color(0xFF333333)),
                              ),
                              Text(
                                model.airlinesListResponse.airlines
                                    .airline[index].dstCityName,
                                style: TextStyle(
                                    fontSize: 12.rsp, color: Color(0xFF333333)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    8.hb,
                    Text(
                      model.airlinesListResponse.airlines.airline[index]
                              .flightCompanyName +
                          model.airlinesListResponse.airlines.airline[index]
                              .flightNo +
                          " | " +
                          _getPlaneNameByType(model.airlinesListResponse
                              .airlines.airline[index].planeType),
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
                "¥" + _sortListbyPrice(model).parPrice.toString(),
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18.rsp, color: Color(0xFFD5101A)),
              ),
              Text(
                (_sortListbyPrice(model).discount * 10).toString() +
                    '折' +
                    _sortListbyPrice(model).seatMsg,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10.rsp, color: Color(0xFF999999)),
              ),
              _sortListbyPrice(model).seatStatus != 'A'
                  ? Text(
                      "仅剩" + _sortListbyPrice(model).seatStatus + '张',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 12.rsp, color: Color(0xFFD5101A)),
                    )
                  : SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  AirSeat _sortListbyPrice(AirLineModel model) {
    return model.airlinesListResponse.airlines.airline[index].airSeats.airSeat
        .sortedBy((a, b) => a.settlePrice.compareTo(b.settlePrice))
        .first;
  }

  // _ticketsItem1(AirLineModel model, int index) {
  //   return Container(
  //     padding:
  //         EdgeInsets.only(left: 20.rw, right: 15.rw, top: 10.rw, bottom: 7.rw),
  //     margin: EdgeInsets.only(top: 10.rw),
  //     color: Colors.white,
  //     child:
  //         Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //       Row(
  //         children: [
  //           Text(
  //             model.airlinesListResponse.airlines.airline[index].depTime,
  //             style: TextStyle(fontSize: 18.rsp, color: Color(0xFF333333)),
  //           ),
  //           20.wb,
  //           Container(
  //             alignment: Alignment.topCenter,
  //             padding: EdgeInsets.only(bottom: 10.rw),
  //             child: Column(
  //               children: [
  //                 Text(
  //                   "2h25m",
  //                   style:
  //                       TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
  //                 ),
  //                 Image.asset(
  //                   R.ASSETS_TICKET_GOTO2_ICON_PNG,
  //                   height: rSize(5.rw),
  //                   width: rSize(106.rw),
  //                   fit: BoxFit.fitWidth,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           20.wb,
  //           Text(
  //             model.airlinesListResponse.airlines.airline[index].depTime,
  //             style: TextStyle(fontSize: 18.rsp, color: Color(0xFF333333)),
  //           ),
  //         ],
  //       ),
  //       Container(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               model.airlinesListResponse.airlines.airline[index].orgCityName,
  //               textAlign: TextAlign.left,
  //               style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
  //             ),
  //             Text(
  //               model.airlinesListResponse.airlines.airline[index].dstCityName,
  //               textAlign: TextAlign.left,
  //               style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
  //             ),
  //           ],
  //         ),
  //       )
  //     ]),
  //   );
  // }

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
              Options options = await show2DatePicker(context,
                  fromNameList: _getAirportNameList(widget.fromText),
                  endNameList: _getAirportNameList(widget.toText));
              if (options.arrive != '' ||
                  options.depart != '' ||
                  options.date != '' ||
                  options.company != '' ||
                  options.space != '') {
                if (options.depart != '') {
                  fromList = _getAirportCode(widget.fromText, options.depart);
                } else {
                  fromList = _getAirportList(widget.fromText);
                }
                if (options.arrive != '') {
                  toList = _getAirportCode(widget.toText, options.arrive);
                } else {
                  toList = _getAirportList(widget.toText);
                }

                _refreshController.requestRefresh();

                _chooseScreen = true;
                setState(() {});
              } else if (options.arrive == '' &&
                  options.depart == '' &&
                  options.date == '' &&
                  options.company == '' &&
                  options.space == '') {
                _chooseScreen = false;
                fromList = _getAirportList(widget.fromText);
                toList = _getAirportList(widget.toText);
                _refreshController.requestRefresh();
                setState(() {});
              }
            },
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _chooseScreen
                        ? R.ASSETS_TICKET_SCREEN_CHOOSE_ICON_PNG
                        : R.ASSETS_TICKET__SCREEN_ICON_PNG,
                    width: 17.rw,
                    height: 17.rw,
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
