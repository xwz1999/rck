import 'dart:async';

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

class TicketsOrderPage extends StatefulWidget {
  final String code; //飞机票标准商品编号
  final int ticketType; //1飞机 2汽车 3火车
  TicketsOrderPage({Key key, this.code, @required this.ticketType})
      : super(key: key);

  @override
  _TicketsOrderPageState createState() => _TicketsOrderPageState();
}

class _TicketsOrderPageState extends State<TicketsOrderPage>
    with TickerProviderStateMixin {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  TabController _tabController;
  int _tabType = 0; //0 预订 1待付款 2待出行 3已完成 4已取消
  int _ticketTypee;
  String _ticketText = '飞机票';
  String _stateText = '';
  Timer _timer;
  bool _getTime = false;
  int countDown = 5;

  @override
  void initState() {
    super.initState();
    _ticketTypee = 1;
    _tabController = TabController(length: 5, vsync: this);
    startTick();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  startTick() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick >= 5) {
        _getTime = false;
        _timer.cancel();
        _timer = null;
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
        s = '0' + (tick % 60).toString() + '秒后';
      } else {
        s = (tick % 60).toString() + '秒后';
      }
    }
    return m + s;
  }

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

  List<Widget> tabs = [
    Tab(
      icon: Badge(
        badgeColor: Colors.red,
        shape: BadgeShape.circle,
        position: BadgePosition.topEnd(top: -3, end: -4),
        padding: EdgeInsets.all(3.rw),
        badgeContent: null,
        child: Text(
          '预订中',
        ),
      ),
    ),
    Tab(
      icon: Badge(
        badgeColor: Colors.red,
        shape: BadgeShape.circle,
        position: BadgePosition.topEnd(top: -3, end: -4),
        padding: EdgeInsets.all(3.rw),
        badgeContent: null,
        child: Text(
          '待付款',
        ),
      ),
    ),
    Tab(
      icon: Badge(
        badgeColor: Colors.red,
        shape: BadgeShape.circle,
        position: BadgePosition.topEnd(top: -3, end: -4),
        padding: EdgeInsets.all(3.rw),
        badgeContent: null,
        child: Text(
          '待出行',
        ),
      ),
    ),
    Tab(
      icon: Badge(
        badgeColor: Colors.red,
        shape: BadgeShape.circle,
        position: BadgePosition.topEnd(top: -3, end: -4),
        padding: EdgeInsets.all(3.rw),
        badgeContent: null,
        child: Text(
          '已完成',
        ),
      ),
    ),
    Tab(
      icon: Badge(
        badgeColor: Colors.red,
        shape: BadgeShape.circle,
        position: BadgePosition.topEnd(top: -3, end: -4),
        padding: EdgeInsets.all(3.rw),
        badgeContent: null,
        child: Text(
          '已取消',
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: Color(0xFFF9F9FB),
        actions: [
          PopupMenuButton(
              offset: Offset(0, 10),
              color: Colors.white,
              child: Row(
                children: [
                  Text(getTicketType(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      )),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black87,
                  ),
                ],
              ),
              onSelected: (String value) {
                setState(() {
                  _ticketTypee = int.parse(value);
                  print(value);
                  setState(() {});
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    PopupMenuItem(
                        value: "1",
                        child: Text("飞机票",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.rsp,
                              color: Color(0xFF333333),
                            ))),
                    PopupMenuItem(
                        value: "2",
                        child: Text("汽车票",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.rsp,
                              color: Color(0xFF333333),
                            ))),
                    PopupMenuItem(
                        value: "3",
                        child: Text("火车票",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.rsp,
                              color: Color(0xFF333333),
                            ))),
                  ]),
        ],
        elevation: 0,
        title: Text(
          '订单',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.rsp),
        ),
        themeData: AppThemes.themeDataGrey.appBarTheme,
        bottom: TabBar(
            controller: _tabController,
            onTap: (int index) {
              _tabType = index;
              switch (_tabType) {
                case 0:
                  _stateText = '等待预订';
                  break;
                case 1:
                  _stateText = '待付款';
                  break;
                case 2:
                  _stateText = '待出行';
                  break;
                case 3:
                  _stateText = '已完成';
                  break;
                case 4:
                  _stateText = '已取消';
                  break;
              }
              setState(() {});
            },
            unselectedLabelColor:
                Color(0xFF777777), //设置未选中时的字体颜色，tabs里面的字体样式优先级最高
            unselectedLabelStyle:
                TextStyle(fontSize: 14.rsp), //设置未选中时的字体样式，tabs里面的字体样式优先级最高
            labelColor: Color(0xFFCB322D), //设置选中时的字体颜色，tabs里面的字体样式优先级最高
            labelStyle:
                TextStyle(fontSize: 14.rsp), //设置选中时的字体样式，tabs里面的字体样式优先级最高

            labelPadding: EdgeInsets.only(left: 14.rw, right: 14.rw),
            isScrollable: true, //允许左右滚动
            indicatorColor: Color(0xFFCB322D), //选中下划线的颜色
            indicatorSize: TabBarIndicatorSize
                .label, //选中下划线的长度，label时跟文字内容长度一样，tab时跟一个Tab的长度一样
            indicatorWeight: 2.0, //选中下划线的高度，值越大高度越高，默认为2。0
//                indicator: BoxDecoration(),//用于设定选中状态下的展示样式
            tabs: tabs),
      ),
      body: TabBarView(controller: _tabController, children: [
        _bulidBody(_tabType),
        _bulidBody(_tabType),
        _bulidBody(_tabType),
        _bulidBody(_tabType),
        _bulidBody(_tabType),
      ]),
    );
  }

  _bulidBody(int type) {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        _refreshController.refreshCompleted();
      },
      onLoadMore: () async {
        _refreshController.loadComplete();
        _refreshController.loadNoData();
      },
      body: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.to(TicketsOrderDetailPage());
                },
                child: _ticketsItem());
          }),
    );
  }

  _ticketsItem() {
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
                    Text("上海",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.rsp,
                          color: Color(0xFF333333),
                        )),
                    20.wb,
                    Image.asset(R.ASSETS_GOTO1_PNG,
                        width: 18.rw, height: 7.rw, color: Color(0xFF999999)),
                    20.wb,
                    Text("北京",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.rsp,
                          color: Color(0xFF333333),
                        )),
                  ],
                ),
                Text(_stateText,
                    style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFFFA6400),
                    )),
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
                Text("06-27 21:00",
                    style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    )),
                60.wb,
                Text("到达",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    )),
                20.wb,
                Text("06-27 23:30",
                    style: TextStyle(
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    )),
              ],
            ),
            20.hb,
            Row(
              children: [
                Text("虹桥机场T2",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.rsp,
                      color: Color(0xFF333333),
                    )),
                40.wb,
                Text("MU5199",
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
                    Text("1250",
                        style: TextStyle(
                          fontSize: 18.rsp,
                          color: Color(0xFFCB322D),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                        _getTime
                            ? getTimeText(countDown - _timer.tick)
                            : '00分00秒后',
                        style: TextStyle(
                          fontSize: 10.rsp,
                          color: Color(0xFFCB322D),
                        )),
                    Text('本订单取消',
                        style: TextStyle(
                          fontSize: 10.rsp,
                          color: Color(0xFF333333),
                        )),
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
