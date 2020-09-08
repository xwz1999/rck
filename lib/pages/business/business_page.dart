/*
 * ====================================================
 * package   : pages.business
 * author    : Created by nansi.
 * time      : 2019/5/13  2:22 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/business/focus/child_focus_page.dart';
import 'package:recook/pages/business/recommend/child_recommend_page.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';

class BusinessPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BusinessPageState();
  }
}

class _BusinessPageState extends State<BusinessPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context, {store}) {
    super.build(context);
    Scaffold scaffold = Scaffold(
      body: _bodyWidget(),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(value: SystemUiOverlayStyle.dark, child: scaffold,);
  }

  _bodyWidget(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil.statusBarHeight,
            color: Colors.white,
          ),
          TabBar(
            controller: _tabController,
            unselectedLabelColor: Color(0xff999999),
            labelColor: AppColor.themeColor,
            indicatorColor: AppColor.themeColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.only(left: 5, right: 5, bottom: 3),
            isScrollable: false,
            labelPadding: EdgeInsets.all(0),
            labelStyle: AppTextStyle.generate(18, fontWeight: FontWeight.w500),
            unselectedLabelStyle: AppTextStyle.generate(16, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text:"关注", ),
              Tab(text:"推荐", ),
          ]),
          Container(height: 8, color: Colors.white,),
          Expanded(
            child: CacheTabBarView(
              controller: _tabController,
              children: <Widget>[
                FocusPage(),
                RecommendPage(),
            ],),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

