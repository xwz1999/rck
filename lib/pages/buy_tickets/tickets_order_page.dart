import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/utils/solar_term_util.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/buy_tickets/add_used_passager_page.dart';
import 'package:recook/pages/buy_tickets/airplane_detail_page.dart';
import 'package:recook/pages/buy_tickets/order_widgt.dart';
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

class TicketsOrderPage extends StatefulWidget {
  final String code; //飞机票标准商品编号
  final int ticketType; //1飞机 2汽车 3火车
  final int firstTab;
  TicketsOrderPage({Key key, this.code, @required this.ticketType, this.firstTab})
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
  int countDown = 5; //剩下多少秒
  List<AirOrderModel> _orderList = [];
  bool showList = false;
  DateTime _endDate = new DateTime.now();
  List<AirOrderModel> _typelist = [];

  @override
  void initState() {
    super.initState();
    _ticketTypee = 1;
    _tabController =  TabController(length: 4, vsync: this,initialIndex:widget.firstTab!=null?widget.firstTab:0 );
    //startTick();
  }

  @override
  void dispose() {
    //_timer.cancel();
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

  List<Widget> tabs = [
    Tab(
      text: '出票中',
      // icon: Badge(
      //   badgeColor: Colors.red,
      //   shape: BadgeShape.circle,
      //   position: BadgePosition.topEnd(top: -3, end: -4),
      //   padding: EdgeInsets.all(3.rw),
      //   badgeContent: null,
      //   child: Text(
      //     '出票中',
      //   ),
      // ),
    ),
    Tab(
      text: '已完成',
      // icon: Badge(
      //   badgeColor: Colors.red,
      //   shape: BadgeShape.circle,
      //   position: BadgePosition.topEnd(top: -3, end: -4),
      //   padding: EdgeInsets.all(3.rw),
      //   badgeContent: null,
      //   child: Text(
      //     '已完成',
      //   ),
      // ),
    ),
    Tab(
      text: '出票失败',
      // icon: Badge(
      //   badgeColor: Colors.red,
      //   shape: BadgeShape.circle,
      //   position: BadgePosition.topEnd(top: -3, end: -4),
      //   padding: EdgeInsets.all(3.rw),
      //   badgeContent: null,
      //   child: Text(
      //     '出票失败',
      //   ),
      // ),
    ),
    Tab(
      text: '已取消',
      // icon: Badge(
      //   badgeColor: Colors.red,
      //   shape: BadgeShape.circle,
      //   position: BadgePosition.topEnd(top: -3, end: -4),
      //   padding: EdgeInsets.all(3.rw),
      //   badgeContent: null,
      //   child: Text(
      //     '已取消',
      //   ),
      // ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        appBackground: Color(0xFFF9F9FB),
        actions: [
          Row(
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
          // PopupMenuButton(
          //     offset: Offset(0, 10),
          //     color: Colors.white,
          //     child: Row(
          //       children: [
          //         Text(getTicketType(),
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 14.rsp,
          //               color: Color(0xFF333333),
          //             )),
          //         Icon(
          //           Icons.arrow_drop_down,
          //           color: Colors.black87,
          //         ),
          //       ],
          //     ),
          //     onSelected: (String value) {
          //       setState(() {
          //         _ticketTypee = int.parse(value);
          //         print(value);
          //         setState(() {});
          //       });
          //     },
          //     itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          //           PopupMenuItem(
          //               value: "1",
          //               child: Text("飞机票",
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 14.rsp,
          //                     color: Color(0xFF333333),
          //                   ))),
          //           PopupMenuItem(
          //               value: "2",
          //               child: Text("汽车票",
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 14.rsp,
          //                     color: Color(0xFF333333),
          //                   ))),
          //           PopupMenuItem(
          //               value: "3",
          //               child: Text("火车票",
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 14.rsp,
          //                     color: Color(0xFF333333),
          //                   ))),
          //         ]),
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
                  _stateText = '出票中';
                  break;
                case 1:
                  _stateText = '已完成';
                  break;
                case 2:
                  _stateText = '已取消';
                  break;
                case 3:
                  _stateText = '出票失败';
                  break;
                // case 4:
                //   _stateText = '已完成';
                //   break;
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
        //
        OrderWidgetPage(ticketType: widget.ticketType, orderType: 1), //1 出票中
        OrderWidgetPage(ticketType: widget.ticketType, orderType: 2), //2 已完成
        // OrderWidgetPage(ticketType: widget.ticketType, orderType: 4),
        OrderWidgetPage(ticketType: widget.ticketType, orderType: 3), //3 出票失败
        OrderWidgetPage(ticketType: widget.ticketType, orderType: 5), //5已取消
      ]),
    );
  }
}
