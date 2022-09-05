import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/promotion_list_model.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';

class HomeCountdownController{
  late Function(int) indexChange;
}

class HomeCountdownWidget extends StatefulWidget {
  final HomeCountdownController? controller;
  final double height;
  final int index;
  final List<Promotion>? promotionList;
  HomeCountdownWidget({Key? key, this.height=40, this.index=0, this.promotionList, this.controller}) : super(key: key);

  @override
  _HomeCountdownWidgetState createState() => _HomeCountdownWidgetState();
}

class _HomeCountdownWidgetState extends State<HomeCountdownWidget> {
  Color _redColor = Color(0xffc70404);
  int _index = 0;
  //活动时间定时器
  Timer? _promotionTimer;
  int _promotionCountdownTime = 0;
  @override
  void initState() { 
    super.initState();
    _index = widget.index;
    widget.controller!.indexChange = (int index){
      // if (mounted) {
      //   _index = index;
      //   setState(() {});
      // }
    };
    // _startPromotionTimer();
  }
  @override
  void dispose() {
    if (_promotionTimer != null) {
      _promotionTimer!.cancel();
      _promotionTimer = null;
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      color: AppColor.frenchColor,
      padding: EdgeInsets.only(left: 27, right: 10), height: widget.height, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Image.asset(UserManager.instance!.isWholesale?"assets/home_list_times_2.png": "assets/home_list_times_1.png", width: 77*1.5, height: 20*1.5),
          // Spacer(),
          // widget.promotionList!=null&&widget.promotionList.length>0?_rightWidget():Container(),
        ],
      ),
    );
  }

  _rightWidget(){
    int index = _index;
    Promotion item = widget.promotionList![index];
    
    PromotionStatus processStatus = PromotionTimeTool.getPromotionStatusWithTabbar(item.startTime, item.getTrueEndTime());
    String statusString = "";
    switch (processStatus) {
      case PromotionStatus.end:
      case PromotionStatus.start:
        return Text('正在抢购中', style: TextStyle(color: _redColor, fontWeight: FontWeight.w600, fontSize: 13),);

      case PromotionStatus.ready:
      case PromotionStatus.tomorrow:
        DateTime nowTime = DateTime.now();
        DateTime startTime = DateTime.parse(item.startTime!);
        Duration difference = startTime.difference(nowTime);
        _promotionCountdownTime = difference.inSeconds + 1;
        // statusString = "预热中";
        return _countdownTimeWidget();
        // return Text(statusString, style: TextStyle(color: _redColor, fontWeight: FontWeight.w600, fontSize: 13),);

      default:
        return Container();

    }
  }

  _countdownTimeWidget(){
    if (_promotionCountdownTime <= 0) {
      return Text('正在抢购中', style: TextStyle(color: _redColor, fontWeight: FontWeight.w600, fontSize: 13),);
    }
    int hour = _promotionCountdownTime ~/ 3600;
    int minute = _promotionCountdownTime % 3600 ~/ 60;
    int second = _promotionCountdownTime % 60;
    String minStr = minute>=10?minute.toString():"0$minute";
    String hourStr = hour>=10?hour.toString():"0$hour";
    String secStr = second>=10?second.toString():"0$second";
    return Container(
      child: Row(
        children: <Widget>[
          Text('距本场开始还剩', style: TextStyle(color: _redColor, fontWeight: FontWeight.w600, fontSize: 13),),
          _boxWidget(hourStr),
          Container(
            margin: EdgeInsets.only(left: 1),
            width: 1,
            child: Text(':', style: TextStyle(color: _redColor, fontWeight: FontWeight.w600, fontSize: 16),),
          ),
          _boxWidget(minStr),
          Container(
            margin: EdgeInsets.only(left: 1),
            width: 1,
            child: Text(':', style: TextStyle(color: _redColor, fontWeight: FontWeight.w600, fontSize: 16),),
          ),
          _boxWidget(secStr),
        ],
      ),
    );
  }

  _boxWidget(infoStr){
    return Container(
      alignment: Alignment.center,
      width: 22,height: 22,
      margin: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        color: _redColor, borderRadius: BorderRadius.circular(2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Text(infoStr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),),
    );
  }

  _startPromotionTimer(){
    if (_promotionTimer != null && _promotionTimer!.isActive) {
      return;
    }
    _promotionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_promotionCountdownTime <= 0) {
        return;
      }else{
        _promotionCountdownTime--;
        setState(() {});
      }
      // if (widget.promotionList == null || widget.promotionList.length <= 0 || !mounted) {
      //   return;
      // }
      // // 判断当前小时和之前保存的小时是否不同
      // int nowHour = DateTime.now().hour;
      // // int nowHour = DateTime.now().second;
      // if (nowHour/2>hour/2) {
      //   // 每过两小时判断一次tabbar跳转
      //   // 当前tabbar index
      //   int tabbarIndex = widget.tabController.index;
      //   for (Promotion subPro in widget.promotionList) {
      //     // 活动开始时间 和 现在的小时一样 跳转到这个时间
      //     int subProStartHour = DateTime.parse(subPro.startTime).hour;
      //     int day = DateTime.parse(subPro.startTime).day;
      //     if (subProStartHour == nowHour && day == DateTime.now().day) {
      //       int nowIndex = widget.promotionList.indexOf(subPro);
      //       if (nowIndex != tabbarIndex) {
      //         if (widget.timerJump != null) {
      //           widget.timerJump(nowIndex);
      //         }
      //       }
      //     }
      //   }
      // }
    });
  }

}
