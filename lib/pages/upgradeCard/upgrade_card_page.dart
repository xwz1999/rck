import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_tab_widget.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class UpgradeCardPage extends StatefulWidget {
  UpgradeCardPage({Key key}) : super(key: key);

  @override
  _UpgradeCardPageState createState() => _UpgradeCardPageState();
}

class _UpgradeCardPageState extends BaseStoreState<UpgradeCardPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "权益卡",
        elevation: 0,
        themeData: AppThemes.themeDataGrey.appBarTheme,
        background: Colors.white,
        appBackground: Colors.white,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.black,
                labelColor: AppColor.themeColor,
                indicatorColor: AppColor.themeColor,
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: false,
                labelPadding: EdgeInsets.all(0),
                labelStyle:
                    AppTextStyle.generate(15, fontWeight: FontWeight.w500),
                unselectedLabelStyle:
                    AppTextStyle.generate(13, fontWeight: FontWeight.w500),
                tabs: [
                  Tab(
                    text: "未使用",
                  ),
                  Tab(
                    text: "已使用",
                  ),
                ]),
            Expanded(
              child: CacheTabBarView(
                controller: _tabController,
                children: <Widget>[
                  UpgradeCardTabWidget(used: false,),
                  UpgradeCardTabWidget(used: true,)
                  // FocusPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
