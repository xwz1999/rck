import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/utils/solar_term_util.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/buy_tickets/add_used_passager_page.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/pages/buy_tickets/models/passager_model.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:badges/badges.dart';

import 'models/air_order_model.dart';

class TicketsOrderDetailPage extends StatefulWidget {
  final String code; //飞机票标准商品编号
  final int ticketType; //1飞机 2汽车 3火车
  final int status;
  final AirOrderModel airOrderModel;
  TicketsOrderDetailPage(
      {Key key,
      this.code,
      @required this.ticketType,
      @required this.status,
      this.airOrderModel})
      : super(key: key);

  @override
  _TicketsOrderDetailState createState() => _TicketsOrderDetailState();
}

class _TicketsOrderDetailState extends State<TicketsOrderDetailPage> {
  List<User> _passengerList = [];
  bool _showList;
  String _stateText = '';
  Timer _timer;
  bool _getTime = false;
  DateTime _dateNow = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0); //当天0点
  @override
  void initState() {
    super.initState();
    _showList = true;
    _passengerList.addAll(widget.airOrderModel.user);
    startTick();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: Color(0xFFF9F9FB),
        elevation: 0,
        title: Text(
          '订单详情',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.rsp),
        ),
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _buildWidgt(),
    );
  }

  startTick() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick >= 15 * 60) {
        _getTime = false;
        _timer.cancel();
        _timer = null;
        Alert.show(
            context,
            NormalTextDialog(
              type: NormalTextDialogType.normal,
              title: "提示",
              content: "订单已超时",
              items: ["确认"],
              listener: (index) {
                Get.back();
                Alert.dismiss(context);
              },
            ));
      } else {
        _getTime = true;
      }
      setState(() {});
    });
  }

  getTimeText(int tick) {
    String m = '';
    String s = '';
    if (tick >= 0) {
      if ((tick ~/ 60) < 10) {
        m = '0' + (tick ~/ 60).toString() + '分';
      } else {
        m = (tick ~/ 60).toString() + '分';
      }
      if ((tick % 60) < 10) {
        s = '0' + (tick % 60).toString() + '秒内';
      } else {
        s = (tick % 60).toString() + '秒内';
      }
    }
    return m + s;
  }

  getsurplus(String expiration) {
    //获取订单剩余时间
    DateTime endTime = DateUtil.getDateTime(expiration);
    if (endTime.difference(DateTime.now()).inSeconds <= 0) {
      return 0;
    } else {
      return endTime.difference(DateTime.now()).inSeconds;
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

  _getFromTimeText(String fromDate) {
    DateTime dateTime = DateUtil.getDateTime(fromDate);
    String day = DateUtil.formatDate(dateTime, format: 'MM-dd');
    String hour = DateUtil.formatDate(dateTime, format: 'HH:mm');
    String tian = getDayWeek(dateTime);
    return day + ' ' + tian + ' ' + hour;
  }

  _buildWidgt() {
    return Column(
      children: [
        Container(
          height: 70.rw,
          padding: EdgeInsets.only(top: 15.rw, left: 15.rw, right: 15.rw),
          width: double.infinity,
          decoration: new BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFCE2727), Color(0xFFEE5250)])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.status == 0
                          ? '等待付款'
                          : widget.status == 1
                              ? '支付成功'
                              : widget.status == 2
                                  ? '已取消'
                                  : widget.status == 3
                                      ? '已过期'
                                      : widget.status == 4
                                          ? '出票成功'
                                          : '已关闭',
                      style: TextStyle(
                        fontSize: 16.rsp,
                        color: Colors.white,
                      )),
                  widget.status == 0
                      ? Text(
                          _getTime
                              ? '请在' +
                                  getTimeText(getsurplus(
                                          widget.airOrderModel.order.fromDate) -
                                      _timer.tick) +
                                  '完成支付'
                              : '',
                          style: TextStyle(
                            fontSize: 12.rsp,
                            color: Colors.white,
                          ))
                      : widget.status == 1
                          ? ''
                          : widget.status == 3
                              ? '由于您未在指定时间内付款，您的订单已过期'
                              : widget.status == 4
                                  ? '请注意您的出发时间，提前检票。'
                                  : '',
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.rw),
                child: Row(
                  children: [
                    Text('¥',
                        style: TextStyle(
                          fontSize: 16.rsp,
                          color: Colors.white,
                        )),
                    Text(widget.airOrderModel.order.amountMoney.toString(),
                        style: TextStyle(
                          fontSize: 24.rsp,
                          color: Colors.white,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 15.rw, right: 15.rw, top: 10.rw),
              padding: EdgeInsets.only(left: 15.rw, right: 15.rw),
              height: 42.rw,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2.rw),
                      topRight: Radius.circular(2.rw)),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('航班信息',
                      style: TextStyle(
                        fontSize: 16.rsp,
                        color: Color(0xFF333333),
                      )),
                  Row(
                    children: [
                      Text(widget.airOrderModel.order.line,
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  )
                ],
              ),
            ),
            _returnDivider(15.rw, 15.rw),
            Container(
              margin: EdgeInsets.only(left: 15.rw, right: 15.rw),
              height: 1.rw,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15.rw, right: 15.rw),
              margin: EdgeInsets.only(left: 15.rw, right: 15.rw, bottom: 10.rw),
              height: 99.rw,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2.rw),
                      bottomRight: Radius.circular(2.rw)),
                  color: Colors.white,
                  image: DecorationImage(
                      alignment: Alignment.bottomRight,
                      image: AssetImage(R.ASSETS_AIR_BACKGROUD_PNG))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  18.hb,
                  Row(
                    children: [
                      Text(
                          _getFromTimeText(widget.airOrderModel.order.fromDate),
                          style: TextStyle(
                            fontSize: 14.rsp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          )),
                      // Text(' ' + '后天' + ' ',
                      //     style: TextStyle(
                      //       fontSize: 14.rsp,
                      //       fontWeight: FontWeight.bold,
                      //       color: Color(0xFF333333),
                      //     )),
                      // Text('21:00',
                      //     style: TextStyle(
                      //       fontSize: 14.rsp,
                      //       fontWeight: FontWeight.bold,
                      //       color: Color(0xFF333333),
                      //     )),
                    ],
                  ),
                  18.hb,
                  Row(
                    children: [
                      Container(
                        width: 24.rw,
                        height: 14.rw,
                        margin: EdgeInsets.only(top: 1.rw),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.rw)),
                            border: Border.all(
                                width: 0.5.rw, color: Color(0xFFCF2929))),
                        child: Text('出发',
                            style: TextStyle(
                                fontSize: 10.rsp,
                                color: Color(0xFFCF2929),
                                wordSpacing: 0.5.rw)),
                      ),
                      10.wb,
                      Text('上海',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                      Text('·',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                      Text(widget.airOrderModel.order.fromPort,
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ),
                  18.hb,
                  Row(
                    children: [
                      Container(
                        width: 24.rw,
                        height: 14.rw,
                        margin: EdgeInsets.only(top: 1.rw),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(1.rw)),
                            border: Border.all(
                                width: 0.5.rw, color: Color(0xFFCF2929))),
                        child: Text('出发',
                            style: TextStyle(
                                fontSize: 10.rsp,
                                color: Color(0xFFCF2929),
                                wordSpacing: 0.5.rw)),
                      ),
                      10.wb,
                      Text('上海',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                      Text('·',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                      Text(widget.airOrderModel.order.toPort,
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        _information()
      ],
    );
  }

  _returnDivider(double start, double end) {
    return Divider(
      color: Color(0xFFE6E6E6),
      height: 1.rw,
      thickness: rSize(1.rw),
      indent: start,
      endIndent: end,
    );
  }

  _buildList() {
    print(_passengerList.length);
    return Container(
      margin: EdgeInsets.only(left: 15.rw, right: 15.rw),
      //padding: EdgeInsets.only(left: 15.rw, right: 15.rw),
      color: Colors.white,
      width: double.infinity,
      height: _showList ? (_passengerList.length * 50).rw : 0.rw,
      child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _passengerList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Color(0xFFE6E6E6),
              height: 1.rw,
              thickness: rSize(1),
            );
          },
          itemBuilder: (context, index) {
            return MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  //Get.to(AirplaneReservePage());
                },
                child: _passagerItem(_passengerList[index]));
          }),
    );
  }

  _information() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 15.rw, right: 15.rw),
            padding: EdgeInsets.only(left: 15.rw, right: 15.rw, top: 10.rw),
            height: 42.rw,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2.rw),
                    topRight: Radius.circular(2.rw)),
                color: Colors.white),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('乘机人信息',
                        style: TextStyle(
                          fontSize: 16.rsp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        )),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 4.rw),
                          child: Text('预留手机',
                              style: TextStyle(
                                fontSize: 12.rsp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              )),
                        ),
                        5.wb,
                        Text('13012348888',
                            style: TextStyle(
                              fontSize: 12.rsp,
                              color: Color(0xFF333333),
                            )),
                      ],
                    )
                  ],
                ),
              ],
            )),
        _returnDivider(15, 15),
        _showList ? _buildList() : SizedBox(),
        Container(
            margin: EdgeInsets.only(left: 15.rw, right: 15.rw),
            padding: EdgeInsets.only(left: 15.rw, right: 15.rw),
            height: 42.rw,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2.rw),
                    topRight: Radius.circular(2.rw)),
                color: Colors.white),
            child: GestureDetector(
              onTap: () {
                _showList = !_showList;
                setState(() {});
              },
              child: Container(
                alignment: Alignment.center,
                height: 42.rw,
                color: Colors.white,
                width: double.infinity,
                child: Text(!_showList ? '展开乘车人列表' : '收起乘车人列表',
                    style: TextStyle(
                      fontSize: 12.rsp,
                      color: Color(0xFFCF2929),
                    )),
              ),
            )),
      ],
    );
  }

  _passagerItem(User item) {
    return Container(
        height: 40.rw,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                20.wb,
                Container(
                  width: 90.rw,
                  child: Row(
                    children: [
                      Image.asset(
                        R.ASSETS_TICKET_PASSAGER_ICON_PNG,
                        width: 12.rw,
                        height: 12.rw,
                      ),
                      Text(item.name,
                          style: TextStyle(
                            fontSize: 14.rsp,
                            color: Color(0xFF333333),
                          )),
                    ],
                  ),
                )
              ],
            ),
            Container(
                width: 100.rw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_getCardId(item.phone),
                        style: TextStyle(
                          fontSize: 12.rsp,
                          color: Color(0xFF333333),
                        )),
                    20.wb
                  ],
                )),
            Container(
                width: 140.rw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_getCardId(item.residentIdCard),
                        style: TextStyle(
                          fontSize: 12.rsp,
                          color: Color(0xFF333333),
                        )),
                    20.wb
                  ],
                )),
          ],
        ));
  }

  _getCardId(String id) {
    if (id.length > 7) {
      String hear = id.substring(0, 4);
      String foot = id.substring(id.length - 3);
      String newId = '';
      for (var i = 0; i < id.length - 7; i++) {
        newId += '*';
      }
      return hear + newId + foot;
    } else
      return id;
  }
}
