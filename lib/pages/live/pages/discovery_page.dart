import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/live/widget/round_tab_bar_indicator.dart';
import 'package:recook/widgets/custom_image_button.dart';

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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              top: true,
              bottom: false,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: rSize(80)),
                    child: TabBar(
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
                      indicator: RoundTabBarIndicator(
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
                  ),
                  CustomImageButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: rSize(16),
                      vertical: rSize(12),
                    ),
                    child: Image.asset(
                      R.ASSETS_LIVE_USER_PNG,
                      width: rSize(20),
                      height: rSize(20),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
