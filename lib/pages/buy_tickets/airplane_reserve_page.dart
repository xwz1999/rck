import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_cache_image.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

import 'airplane_detail_page.dart';

class AirplaneReservePage extends StatefulWidget {
  AirplaneReservePage({Key key}) : super(key: key);

  @override
  _AirplaneReservePageState createState() => _AirplaneReservePageState();
}

class _AirplaneReservePageState extends State<AirplaneReservePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          title: '上海-北京',
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
                  Container(
                    child: CustomCacheImage(
                      borderRadius: BorderRadius.circular(5),
                      width: 10.rw,
                      height: 10.rw,
                      imageUrl: R.ASSETS_ORDER_ALERT_PNG,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "东方航空CA8685",
                    style:
                        TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
              40.wb,
              Container(
                child: Text(
                  "06月23日 后天",
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
                    "21.00",
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFF333333)),
                  ),
                  Text(
                    "浦东T1",
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
                      "2h25m",
                      style:
                          TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                    ),
                    10.hb,
                    Container(
                      width: 68.rw,
                      height: 7.rw,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              40.wb,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "23.00",
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFF333333)),
                  ),
                  Text(
                    "大兴西北",
                    style:
                        TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
                  ),
                ],
              ),
            ],
          ),
          8.hb,
          Text(
            "波音747-aaaa (中)",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12.rsp, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
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
          _firstList(),
          _economyList(),
        ],
      ),
    ).expand();
  }

//头等舱
  _firstList() {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _firstItem();
        });
  }

  _economyList() {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _economyItem();
        });
  }

  _firstItem() {
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
                    "400",
                    style:
                        TextStyle(fontSize: 24.rsp, color: Color(0xFFC92219)),
                  ),
                ],
              ),
              20.hb,
              Text(
                "儿童票，婴儿暂不可预定",
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
              ),
              10.hb,
              Row(
                children: [
                  Text(
                    "退改规｜免费托运20KG",
                    style:
                        TextStyle(fontSize: 12.rsp, color: Color(0xFF333333)),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(left: 10.rw, bottom: 2.rw),
                      child: Icon(
                        AppIcons.icon_next,
                        size: 12.rw,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                ],
              ),
              10.hb,
              Text(
                "7.0折经济舱 ｜ 提供行程单",
                style: TextStyle(fontSize: 10.rsp, color: Color(0xFF666666)),
              ),
            ],
          ),
          Column(
            children: [
              10.hb,
              CustomImageButton(
                height: 38.rw,
                width: 44.rw,
                title: "预定",
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
                  Get.to(AirplaneDetailPage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _economyItem() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.rw)),
    );
  }
}
