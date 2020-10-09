import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/business/recommend/child_recommend_page.dart';
import 'package:recook/pages/live/sub_page/live_stream_page.dart';
import 'package:recook/pages/live/sub_page/user_home_page.dart';
import 'package:recook/pages/live/sub_page/video_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class DiscoveryPage extends StatefulWidget {
  DiscoveryPage({Key key}) : super(key: key);

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: SizedBox(
          width: rSize(50),
          child: CustomImageButton(
            padding: EdgeInsets.symmetric(
              horizontal: rSize(16),
              vertical: rSize(12),
            ),
            child: Image.asset(
              R.ASSETS_LIVE_USER_PNG,
              width: rSize(20),
              height: rSize(20),
            ),
            onPressed: () {
              CRoute.push(
                context,
                UserHomePage(
                  userId: UserManager.instance.user.info.id,
                ),
              );
            },
          ),
        ),
        title: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF333333),
          unselectedLabelColor: Color(0xFF333333).withOpacity(0.3),
          labelStyle: TextStyle(
            fontSize: rSP(18),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: rSP(18),
            fontWeight: FontWeight.w400,
          ),
          labelPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: RecookIndicator(
            borderSide: BorderSide(
              width: rSize(3),
              color: Color(0xFFDB2D2D),
            ),
          ),
          tabs: [
            Tab(text: '直播'),
            Tab(text: '视频'),
            Tab(text: '图文'),
          ],
        ),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          SizedBox(width: rSize(50)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: CacheTabBarView(
            controller: _tabController,
            children: [
              LiveStreamPage(),
              VideoPage(),
              RecommendPage(),
            ],
          )),
        ],
      ),
    );
  }
}
