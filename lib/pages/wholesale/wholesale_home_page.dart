import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_car_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_shop_page.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:velocity_x/velocity_x.dart';

class WholesaleHomePage extends StatefulWidget {
  WholesaleHomePage({
    Key key,
  }) : super(key: key);

  @override
  _WholesaleHomePageState createState() => _WholesaleHomePageState();
}

class _WholesaleHomePageState extends State<WholesaleHomePage> with SingleTickerProviderStateMixin{


  //页面列表
  List<Widget> _pages = <Widget>[];
  TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      WholesaleCarPage(),
      WholesaleCarPage(),
      WholesaleCarPage(),
    ];

    _tabController = TabController(
        length: _pages.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }
  _buildBottomBar(
      String title,
      String unselected,
      String selected,
      ) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        unselected,
        height: 56.w,
        width: 56.w,
        color: Colors.black38,
      ),
      activeIcon: Image.asset(
        selected,
        height: 56.w,
        width: 56.w,
      ),
      label: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    //底部导航来
    List<BottomNavigationBarItem> _bottomNav = <BottomNavigationBarItem>[
      _buildBottomBar(
        '批发商城',
        R.ASSETS_WHOLESALE_HOME_PNG,
        R.ASSETS_WHOLESALE_HOME_CHOOSE_PNG,
      ),
      _buildBottomBar(
        '购物车',
        R.ASSETS_WHOLESALE_CAR_PNG,
        R.ASSETS_WHOLESALE_CAR_CHOOSE_PNG,
      ),
      _buildBottomBar(
        '批发订单',
        R.ASSETS_WHOLESALE_ORDER_PNG,
        R.ASSETS_WHOLESALE_ORDER_CHOOSE_PNG,
      ),
    ];
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      body: _pages[_currentIndex],
      // TabBarView(
      //   children: _pages,
      //   controller: _tabController,
      //   physics: NeverScrollableScrollPhysics(),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNav,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedFontSize: 20.sp,
        unselectedFontSize: 20.sp,
        fixedColor: AppColor.themeColor,
        unselectedItemColor: Colors.black38,
        onTap: (index) {
          setState(() {
            this._currentIndex = index;
          });
        },

      ),
    );
  }

}