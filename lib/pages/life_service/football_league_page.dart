
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';

import 'foot_match_sort_page.dart';
import 'foot_near_match_page.dart';

class FootballLeaguePage extends StatefulWidget {
  FootballLeaguePage({
    Key? key,
  }) : super(key: key);

  @override
  _FootballLeaguePageState createState() => _FootballLeaguePageState();
}

class _FootballLeaguePageState extends State<FootballLeaguePage>
    with SingleTickerProviderStateMixin {
  List? tabList = ['西甲', '德甲', '英超', '意甲', '法甲', '中超'];

  List? tabLists = ['xijia', 'dejia', 'yingchao', 'yijia', 'fajia', 'zhongchao'];
  late TabController _tabController;
  GSRefreshController _refreshController1 =
      GSRefreshController(initialRefresh: true);

  GSRefreshController _refreshController2 =
  GSRefreshController(initialRefresh: true);

  String chooseItem = '赛程';
  String type = 'xijia';

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabList!.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
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
        title: Text('足球赛事',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 17.rsp,
            )),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.rw),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                child: TabBar(
                    onTap: (index) {
                      type = tabLists![index];
                      setState(() {});
                      if( chooseItem == '赛程'){
                        _refreshController1.requestRefresh();
                      }else{
                        _refreshController2.requestRefresh();
                      }
                    },
                    labelPadding: EdgeInsets.only(bottom: 7.rw, top: 20.rw),
                    controller: _tabController,
                    unselectedLabelColor: Color(0xFF999999),
                    unselectedLabelStyle: TextStyle(fontSize: 14.rsp),
                    labelColor: Color(0xFF333333),
                    labelStyle: TextStyle(fontSize: 14.rsp),
                    indicatorColor: AppColor.themeColor,
                    indicatorSize: TabBarIndicatorSize.label,
                   // indicatorPadding: EdgeInsets.only(left: 15.rw, right: 15.rw),
                    tabs: _tabItems()),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10.rw,horizontal: 14.rw),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){

                        chooseItem = '赛程';

                        setState(() {

                        });
                        _pageController.jumpToPage(0);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.rw,horizontal: 14.rw),
                        decoration: BoxDecoration(
                          color: chooseItem=='赛程'?Color(0xFFFFF1F1):Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(2.rw)
                        ),
                        child: Text(
                          '赛程',style: chooseItem=='赛程'?TextStyle(
                          color: Color(0xFFDB2D2D),fontSize: 14.rsp,fontWeight: FontWeight.bold
                        ):TextStyle(
                            color: Color(0xFF999999),fontSize: 14.rsp
                        ),
                        ),
                      ),
                    ),
                    32.wb,

                    GestureDetector(
                      onTap: (){

                        chooseItem = '积分';

                        setState(() {

                        });
                        _pageController.jumpToPage(1);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.rw,horizontal: 14.rw),
                        decoration: BoxDecoration(
                            color: chooseItem=='积分'?Color(0xFFFFF1F1):Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(2.rw)
                        ),
                        child: Text(
                          '积分',style: chooseItem=='积分'?TextStyle(
                            color: Color(0xFFDB2D2D),fontSize: 14.rsp,fontWeight: FontWeight.bold
                        ):TextStyle(
                            color: Color(0xFF999999),fontSize: 14.rsp
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
      body: _bodyWidget(),
    );
  }

  _tabItems() {
    return tabList!
        .map(
          (e) => Container(
            child: Text(
              e,
            ),
          ),
        )
        .toList();
  }

  _bodyWidget() {
    return PageView(
        controller: _pageController,
        // onPageChanged: (index){
        //   if(index ==0){
        //     chooseItem = '赛程';
        //   }else{
        //     chooseItem = '赛程';
        //   }
        //   print('122212');
        //   setState(() {
        //
        //   });
        // },
      physics: NeverScrollableScrollPhysics(),
        children: [
          FootNearMatchPage(refreshController: _refreshController1, type: type,),
          FootMatchSortPage(refreshController: _refreshController2,type: type,),
        ],
    );
  }
}
