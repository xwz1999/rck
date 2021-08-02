import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/utils/solar_term_util.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/buy_tickets/add_used_passager_page.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/no_data_view.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:badges/badges.dart';

class TicketsOrderDetailPage extends StatefulWidget {
  final String code; //飞机票标准商品编号
  final int ticketType; //1飞机 2汽车 3火车
  TicketsOrderDetailPage({Key key, this.code, @required this.ticketType})
      : super(key: key);

  @override
  _TicketsOrderDetailState createState() => _TicketsOrderDetailState();
}

class _TicketsOrderDetailState extends State<TicketsOrderDetailPage> {
  List<Item> _passengerList = [];
  bool _showList;
  @override
  void initState() {
    super.initState();
    _showList = true;
    _passengerList
        .add(Item(item: '张伟', choice: false, num: '12345678901234567890'));
    _passengerList
        .add(Item(item: '欧阳青青', choice: false, num: '12345678901234567'));
    _passengerList
        .add(Item(item: '小星星', choice: false, num: '12345678901234567890'));
    _passengerList
        .add(Item(item: '吕小树', choice: false, num: '12345678901234567890'));
  }

  @override
  void dispose() {
    super.dispose();
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
                  Text('等待付款',
                      style: TextStyle(
                        fontSize: 16.rsp,
                        color: Colors.white,
                      )),
                  Text('请在29分30秒内完成支付',
                      style: TextStyle(
                        fontSize: 12.rsp,
                        color: Colors.white,
                      )),
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
                    Text('6050',
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
                      Image(
                        image: AssetImage(R.ASSETS_AIR_ICON_PNG),
                        width: 14.rw,
                        height: 14.rw,
                      ),
                      5.wb,
                      Text('航空MU5199',
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
                      Text('06月23日',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          )),
                      Text(' ' + '后天' + ' ',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          )),
                      Text('21:00',
                          style: TextStyle(
                            fontSize: 14.rsp,
                            fontWeight: FontWeight.bold,
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
                      Text('虹桥机场T2',
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
                      Text('虹桥机场T2',
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

  _passagerItem(Item item) {
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
                      Text(item.item,
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
                width: 140.rw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_getCardId(item.num),
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
    String hear = id.substring(0, 4);
    String foot = id.substring(id.length - 3);
    String newId = '';
    if (id.length > 7) {
      for (var i = 0; i < id.length - 7; i++) {
        newId += '*';
      }
    }
    return hear + newId + foot;
  }
}
