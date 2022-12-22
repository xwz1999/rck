
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

import 'nba_match_sort_page.dart';
import 'nba_near_match_page.dart';

class NBAMatchPage extends StatefulWidget {
  NBAMatchPage({
    Key? key,
  }) : super(key: key);

  @override
  _NBAMatchPageState createState() => _NBAMatchPageState();
}

class _NBAMatchPageState extends State<NBAMatchPage>
    with SingleTickerProviderStateMixin {
  List? tabList = ['近期赛程','球队排名'];
  late TabController _tabController;
  GSRefreshController _refreshController =
  GSRefreshController(initialRefresh: true);


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabList!.length, vsync: this,);

  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: CustomAppBar(
        appBackground: Colors.white,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        leading: RecookBackButton(
          white: false,
        ),
        elevation: 0,
        title: Text('NBA赛事',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
        bottom:TabBar(

            onTap: (index) {
              setState(() {});
            },

            labelPadding: EdgeInsets.only(bottom: 7.rw,top: 20.rw),
            controller: _tabController,
            unselectedLabelColor: Color(0xFF999999),
            unselectedLabelStyle: TextStyle(fontSize: 14.rsp),
            labelColor: Color(0xFF333333),
            labelStyle: TextStyle(fontSize: 14.rsp),

            indicatorColor: AppColor.themeColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.only(left: 15.rw,right: 15.rw),
            tabs: _tabItems()),
      ),
      body: _bodyWidget(),
    );
  }

  _tabItems(){
    return tabList!.map((e) =>Container(
      child: Text(
        e,
      ),
    ),).toList();
  }

  _bodyWidget() {
    return TabBarView(
      controller: _tabController,
      children: [
        NBANearMatchPage(),
        NBAMatchSortPage(),
      ],

    );
  }


}
