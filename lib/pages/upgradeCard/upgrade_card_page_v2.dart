import 'package:flutter/material.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_unused_view.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_used_view.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/recook_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class UpgradeCardPageV2 extends StatefulWidget {
  UpgradeCardPageV2({Key key}) : super(key: key);

  @override
  _UpgradeCardPageV2State createState() => _UpgradeCardPageV2State();
}

class _UpgradeCardPageV2State extends State<UpgradeCardPageV2>
    with TickerProviderStateMixin {
  TabController _tabController;

  // placeholder when no data
  _noDataWidget(title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 1),
          Image.asset(
            "assets/shop_upgrade_code_page_nodata.png",
            width: 99,
            height: 60,
          ),
          Container(height: 20),
          Text(
            title,
            style: TextStyle(color: Color(0xff666666), fontSize: 13),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

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
    return RecookScaffold(
      title: '权益卡',
      appBarBottom: TabBar(
        controller: _tabController,
        labelColor: Color(0xFFDB2D2D),
        unselectedLabelColor: Color(0xFF333333),
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.sp,
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
          Tab(text: '未使用'),
          Tab(text: '已使用'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UpgradeUnusedView(),
          UpgradeUsedView(),
        ],
      ).material(color: Color(0xFFF5F5F5)),
    );
  }
}
