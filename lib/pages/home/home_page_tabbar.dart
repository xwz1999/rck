import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/promotion_list_model.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';

class HomePageTabbar extends StatefulWidget {
  final List<Promotion>? promotionList;
  final TabController? tabController;
  final Function? clickItem;
  final Function(int index)? timerJump;

  const HomePageTabbar(
      {Key? key,
      required this.promotionList,
      required this.tabController,
      this.clickItem,
      this.timerJump})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageTabbarPage();
  }
}

class _HomePageTabbarPage extends State<HomePageTabbar>
    with TickerProviderStateMixin {
  // List<Promotion> _promotionList = [];
  int hour = 0;
  //活动时间定时器
  Timer? _promotionTimer;
  //int _timeNumber = 0;

  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    hour = DateTime.now().hour;
    _gifController = GifController(vsync: this, value: 0);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _gifController.repeat(
          min: 0, max: 44, period: Duration(milliseconds: 1500));
    });
    _startPromotionTimer();
  }

  @override
  void dispose() {
    _gifController.dispose();
    if (_promotionTimer != null) {
      _promotionTimer!.cancel();
      _promotionTimer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
        onTap: (index) {
          if (widget.clickItem != null) {
            widget.clickItem!(index);
          }
          // _getPromotionGoodsList(_promotionList[index].id);
          setState(() {});
        },
        isScrollable: true,
        labelPadding: EdgeInsets.only(bottom: 0),
        controller: widget.tabController,
        indicatorColor: Colors.white.withAlpha(0),
        tabs: _tabItems());
  }

  List<Widget> _tabItems() {
    return widget.promotionList!.map<Widget>((item) {
      int index = widget.promotionList!.indexOf(item);
      return _tabItem(item, index);
    }).toList();
  }

  _tabItem(Promotion item, int index) {
    //抢购中
    // DPrint.printf('xxxxx-----${DateTime.parse(item.startTime).add(Duration(hours: 2))}');
    // item.endTime = DateTime.parse(item.startTime).add(Duration(hours: 2)).toString();
    PromotionStatus processStatus =
        PromotionTimeTool.getPromotionStatusWithTabbar(
            item.startTime, item.getTrueEndTime());
    //String statusString = "";
    switch (processStatus) {
      case PromotionStatus.end:
        //statusString = "正在热卖";
        break;
      case PromotionStatus.ready:
        //statusString = "预热中";
        break;
      case PromotionStatus.start:
       // statusString = "正在抢购";
        break;
      case PromotionStatus.tomorrow:
       // statusString = "明日预告";
        break;
      default:
    }
    // print(statusString);
    bool isSelect = index == widget.tabController!.index;

    Color textColor = isSelect
        ? AppColor.themeColor
        : processStatus == PromotionStatus.ready
            ? Colors.black
            : Colors.black.withOpacity(0.5);
    // Color subTextColor = processStatus == PromotionStatus.ready
    //     ? Colors.black
    //     : Colors.black.withOpacity(0.5);
    Container textContainer = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        // color: isSelect ? getCurrentThemeColor() : Colors.white,
        color: AppColor.frenchColor,
      ),
      alignment: Alignment.center,
      width: 80,
      height: 16,
      margin: EdgeInsets.only(
        left: 0,
        right: 0,
        top: 2,
      ),
      child: Text(
        // item.isProcessing == 1 ? "正在抢购" : item.isProcessing == 0 ? "即将开始" : "已结束",
        item.showName!,
        // statusString,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10 * 2.sp,
          color: textColor,
        ),
      ),
    );
    return Tab(
      child: Container(
        width: processStatus == PromotionStatus.start && isSelect ? 80 : 80,
        alignment: Alignment.center,
        // color: Colors.white,
        color: AppColor.frenchColor,
        padding: EdgeInsets.only(left: 6, right: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              item.startTime!.substring(11, 16),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17 * 2.sp,
                  color: textColor),
            ),
            processStatus == PromotionStatus.start
                ? _isProcessingGifWidget(isSelect, item)
                : textContainer
          ],
        ),
      ),
    );
  }

  // _isProcessingWidget(isSelect, Promotion item) {
  //   double progressWidth = 68;
  //   double startTime =
  //       DateTime.parse(item.startTime!).millisecondsSinceEpoch / 1000;
  //   double endTime =
  //       DateTime.parse(item.getTrueEndTime()!).millisecondsSinceEpoch / 1000;
  //   double nowTime = DateTime.now().millisecondsSinceEpoch / 1000;
  //   double proportion = (nowTime - startTime) / (endTime - startTime);
  //   double width =
  //       proportion * progressWidth < 14 && proportion * progressWidth > 0
  //           ? 14
  //           : proportion * progressWidth;
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(7)),
  //         // color: AppColor.pinkColor,
  //         color: Color(0xffb5b5b6)),
  //     alignment: Alignment.center,
  //     width: progressWidth,
  //     height: 14,
  //     margin: EdgeInsets.only(
  //       top: 2,
  //     ),
  //     child: Stack(
  //       children: <Widget>[
  //         Positioned(
  //           left: 0,
  //           top: 0,
  //           bottom: 0,
  //           width: width,
  //           child: Container(
  //             width: width,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.all(Radius.circular(7)),
  //               color: AppColor.themeColor,
  //             ),
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               item.showName!,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w400,
  //                 fontSize: 9 * 2.sp,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             // Spacer(),
  //             // Text('${(proportion*100).toInt().toString()}% ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11*2.sp, color: proportion > 0.66 ? Colors.white : AppColor.themeColor,),),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  _isProcessingGifWidget(isSelect, Promotion item) {
    double progressWidth = 68;
    return Container(
      alignment: Alignment.center,
      width: progressWidth,
      height: 16,
      // margin: EdgeInsets.only(top: 2,),
      child: Container(
          child: GifImage(
        controller: _gifController,
        image: AssetImage(isSelect
            ? 'assets/home_page_tabbar_loading.gif'
            : 'assets/home_page_tabbar_loading_gray.gif'),
      )),
    );
  }

  _startPromotionTimer() {
    if (_promotionTimer != null && _promotionTimer!.isActive) {
      return;
    }
    _promotionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.promotionList == null ||
          widget.promotionList!.length <= 0 ||
          !mounted) {
        return;
      }
      // 判断当前小时和之前保存的小时是否不同
      int nowHour = DateTime.now().hour;
      // int nowHour = DateTime.now().second;
      if (nowHour / 2 > hour / 2) {
        // 每过两小时判断一次tabbar跳转
        // 当前tabbar index
        int tabbarIndex = widget.tabController!.index;
        for (Promotion subPro in widget.promotionList!) {
          // 活动开始时间 和 现在的小时一样 跳转到这个时间
          int subProStartHour = DateTime.parse(subPro.startTime!).hour;
          int day = DateTime.parse(subPro.startTime!).day;
          if (subProStartHour == nowHour && day == DateTime.now().day) {
            int nowIndex = widget.promotionList!.indexOf(subPro);
            if (nowIndex != tabbarIndex) {
              if (widget.timerJump != null) {
                widget.timerJump!(nowIndex);
              }
            }
          }
        }
      }
      hour = nowHour;
      // setState(() {

      //   // DPrint.printf('活动 首页 tabbar 倒计时 --- '+ (_timeNumber++).toString());
      //   // DPrint.printf('活动进行中倒计时--- '+ _promotionSeconds.toString());
      //   // if (_startPromotionSeconds == 0) {
      //   //   _startTimer.cancel();
      //   //   _startTimer = null;
      //   //   _delay();
      //   //   // _updatePromotionSeconds();
      //   //   // _updateNormalPrice = !_updateNormalPrice;
      //   //   return;
      //   // }
      // });
    });
  }
}
