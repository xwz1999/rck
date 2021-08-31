import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/utils/solar_term_util.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/buy_tickets/add_used_passager_page.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/pages/buy_tickets/tickets_orde_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:badges/badges.dart';

import 'functions/passager_func.dart';
import 'models/air_order_model.dart';

class OrderWidgetPage extends StatefulWidget {
  final String code; //飞机票标准商品编号
  final int ticketType; //1飞机 2汽车 3火车
  final int orderType;
  OrderWidgetPage(
      {Key key, this.code, this.ticketType, @required this.orderType})
      : super(key: key);

  @override
  _OrderWidgetPageState createState() => _OrderWidgetPageState();
}

class _OrderWidgetPageState extends State<OrderWidgetPage>
    with TickerProviderStateMixin {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  int _ticketTypee;
  String _ticketText = '飞机票';
  String _stateText = '';
  // Timer _timer;
  // bool _getTime = false;
  // int countDown = 0; //剩下多少秒
  List<AirOrderModel> _orderList = [];
  bool showList = false;
  DateTime _endDate = new DateTime.now();
  List<AirOrderModel> _typelist = [];

  @override
  void initState() {
    super.initState();
    _ticketTypee = 1;

    //startTick();
  }

  @override
  void dispose() {
    //_timer.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  // String _getStartDate(DateTime date) {
  //   int endYear = date.year;
  //   int endMonth = date.month;
  //   int startYear = 0;
  //   int startMonth = 0;
  //   if (endMonth - 3 < 0) {
  //     startYear = endYear - 1;
  //     startMonth = 12 + endMonth - 3;
  //   } else {
  //     startYear = endYear;
  //     startMonth = endMonth - 3;
  //   }
  //   return DateUtil.formatDate(
  //       DateTime(startYear, startMonth, DateTime.now().day, 0, 0, 0),
  //       format: 'yyyy-MM-dd HH:mm:ss');
  // }

  // startTick() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (timer.tick >= 15 * 60) {
  //       _getTime = false;
  //       _timer.cancel();
  //       _timer = null;
  //       _refreshController.requestRefresh();
  //     } else {
  //       _getTime = true;
  //     }

  //     setState(() {});
  //   });
  // }

  // getTimeText(int tick) {
  //   String m = '';
  //   String s = '';
  //   if (tick >= 0) {
  //     if ((tick ~/ 60) < 10) {
  //       m = '0' + (tick ~/ 60).toString() + '分';
  //     } else {
  //       m = (tick ~/ 60).toString() + '分';
  //     }
  //     if ((tick % 60) < 10) {
  //       s = '0' + (tick % 60).toString() + '秒后';
  //     } else {
  //       s = (tick % 60).toString() + '秒后';
  //     }
  //   }
  //   return m + s;
  // }

  getTicketType() {
    switch (_ticketTypee) {
      case 1:
        _ticketText = '飞机票';
        break;
      case 2:
        _ticketText = '汽车票';
        break;
      case 3:
        _ticketText = '火车票';
        break;
    }
    return _ticketText;
  }

  // int getsurplus(String expiration) {
  //   if (expiration != null) {
  //     //获取订单剩余时间
  //     DateTime endTime = DateUtil.getDateTime(expiration);
  //     if (endTime.difference(DateTime.now()).inSeconds <= 0) {
  //       return 0;
  //     } else {
  //       return endTime.difference(DateTime.now()).inSeconds;
  //     }
  //   }
  //   return 0;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.frenchColor,
        body: _bulidBody(widget.orderType));
  }

  _bulidBody(int type) {
    return RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          _typelist = [];
          _orderList = await PassagerFunc.getAirOrderList();
          if (_orderList == null) {
            _orderList = [];
          }
          _orderList.forEach((element) {
            if (element.order.status == type) {
              _typelist.add(element);
            }
          });
          showList = true;
          _refreshController.refreshCompleted();
          setState(() {});
        },
        onLoadMore: () async {
          _refreshController.loadComplete();
          _refreshController.loadNoData();
        },
        body: _typelist.length > 0
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _typelist.length,
                itemBuilder: (context, index) {
                  return MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Get.to(TicketsOrderDetailPage(
                            ticketType: 1,
                            status: type,
                            airOrderModel: _typelist[index]));
                      },
                      child: _ticketsItem(_typelist[index]));
                })
            : showList
                ? noDataView('抱歉，没有找到您想查看的订单')
                : SizedBox());
  }

  _ticketsItem(AirOrderModel item) {
    return Container(
        padding: EdgeInsets.only(
            left: 10.rw, right: 10.rw, top: 10.rw, bottom: 10.rw),
        margin: EdgeInsets.only(top: 10.rw, left: 10.rw, right: 10.rw),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(item.order.fromCity ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.rsp,
                          color: Color(0xFF333333),
                        )),
                    20.wb,
                    Image.asset(R.ASSETS_GOTO1_PNG,
                        width: 18.rw, height: 7.rw, color: Color(0xFF999999)),
                    20.wb,
                    Text(item.order.toCity ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.rsp,
                          color: Color(0xFF333333),
                        )),
                  ],
                ),
                widget.orderType == 1
                    ? Text('出票中',
                        style: TextStyle(
                          fontSize: 14.rsp,
                          color: Color(0xFFFA6400),
                        ))
                    : widget.orderType == 2
                        ? Text('已完成',
                            style: TextStyle(
                              fontSize: 14.rsp,
                              color: Color(0xFF25D701),
                            ))
                        : widget.orderType == 3
                            ? Text('出票失败',
                                style: TextStyle(
                                  fontSize: 14.rsp,
                                  color: Color(0xFFCB322D),
                                ))
                            : widget.orderType == 5
                                ? Text('已取消',
                                    style: TextStyle(
                                      fontSize: 14.rsp,
                                      color: Color(0xFF999999),
                                    ))
                                : SizedBox(),
              ],
            ),
            20.hb,
            Row(
              children: [
                Text("出发",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    )),
                20.wb,
                Container(
                  padding: EdgeInsets.only(top: 2.rw),
                  child: Row(
                    children: [
                      Text(
                          DateUtil.formatDate(
                                  DateUtil.getDateTime(item.order.date ?? ''),
                                  format: 'MM-dd') ??
                              '',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                      10.wb,
                      Text(item.order.fromDate ?? '',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ),
                ),
                60.wb,
                Text("到达",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    )),
                20.wb,
                Container(
                  padding: EdgeInsets.only(top: 2.rw),
                  child: Row(
                    children: [
                      Text(
                          _getDayTime(item.order.fromDate, item.order.toDate,
                                  item.order.date) ??
                              '',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                      10.wb,
                      Text(item.order.toDate ?? '',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ),
                )
              ],
            ),
            20.hb,
            Row(
              children: [
                Text(item.order.fromPort ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    )),
                40.wb,
                Text(item.order.line ?? '',
                    style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    )),
              ],
            ),
            20.hb,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("¥",
                        style: TextStyle(
                          fontSize: 18.rsp,
                          color: Color(0xFFCB322D),
                        )),
                    Text(item.order.amountMoney.toString() ?? '',
                        style: TextStyle(
                          fontSize: 18.rsp,
                          color: Color(0xFFCB322D),
                        )),
                  ],
                ),
                // item.order.status == 2
                //     ? Row(
                //         children: [
                //           Text(
                //               _getTime
                //                   ? getTimeText(
                //                       getsurplus(item.order.fromDate) -
                //                           _timer.tick)
                //                   : '',
                //               style: TextStyle(
                //                 fontSize: 10.rsp,
                //                 color: Color(0xFFCB322D),
                //               )),
                //           Text('本订单已取消',
                //               style: TextStyle(
                //                 fontSize: 10.rsp,
                //                 color: Color(0xFF333333),
                //               )),
                //         ],
                //       )
                //     : SizedBox(),
              ],
            )
          ],
        ));
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

  _getDayTime(String start, String end, String date) {
    //print(DateUtil.getDateTime(date));
    if (date != null) {
      if (end.compareTo(start) == -1) {
        return DateUtil.formatDate(
            DateUtil.getDateTime(date).add(Duration(days: 1)),
            format: 'MM-dd');
      } else {
        return DateUtil.formatDate(DateUtil.getDateTime(date), format: 'MM-dd');
      }
    }
  }
}
