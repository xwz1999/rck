import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/live/sub_page/user_attention_page.dart';
import 'package:recook/pages/live/widget/sliver_bottom_persistent_delegate.dart';
import 'package:recook/pages/live/widget/user_activity_card.dart';
import 'package:recook/pages/live/widget/user_live_playback_card.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/recook_indicator.dart';

class UserHomePage extends StatefulWidget {
  final bool selfFlag;
  UserHomePage({Key key, @required this.selfFlag}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
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
      body: NestedScrollView(
        headerSliverBuilder: (context, isScroll) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              leading: RecookBackButton(),
              centerTitle: true,
              title: Text(
                '我的主页',
                style: TextStyle(
                  color: Color(0xFF333333),
                ),
              ),
              pinned: true,
              floating: true,
              snap: true,
              expandedHeight: rSize(162.0 + 44),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Padding(
                  padding: EdgeInsets.fromLTRB(
                      rSize(15), rSize(80), rSize(15), rSize(20)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: rSize(54 / 2.0)),
                          SizedBox(width: rSize(10)),
                          Text(
                            'USER TEST',
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: rSP(18),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: rSize(70),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildVerticalView(
                              '关注',
                              226,
                              onTap: () => CRoute.push(
                                context,
                                UserAttentionPage(),
                              ),
                            ),
                            _buildVerticalView(
                              '粉丝',
                              12,
                              onTap: () {},
                            ),
                            _buildVerticalView(
                              '获赞',
                              100,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 0,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverBottomPersistentDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Color(0xFF333333),
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.symmetric(
                    horizontal: rSize(18),
                  ),
                  indicator: RecookIndicator(
                      borderSide: BorderSide(
                    color: Color(0xFFDB2D2D),
                    width: rSize(3),
                  )),
                  tabs: [
                    Tab(text: '动态'),
                    Tab(text: '直播回放'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Material(
          color: Colors.white,
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(itemBuilder: (context, index) {
                return UserActivityCard();
              }),
              ListView.builder(itemBuilder: (context, index) {
                return UserPlaybackCard();
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalView(String title, int num, {VoidCallback onTap}) {
    return CustomImageButton(
      onPressed: onTap,
      child: Column(
        children: [
          Text(
            num.toString(),
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSP(18),
            ),
          ),
          SizedBox(height: rSize(6)),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: rSP(12),
            ),
          ),
        ],
      ),
    );
  }
}
