
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/order/guide_order_view.dart';
import 'package:jingyaoyun/pages/user/order/order_list_controller.dart';
import 'package:jingyaoyun/pages/user/order/order_list_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_order_list_page.dart';
import 'package:jingyaoyun/widgets/cache_tab_bar_view.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/tabbarWidget/sc_tab_bar.dart';
import 'package:jingyaoyun/widgets/title_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';



class WholesaleOrderHomePage extends StatefulWidget {
  final Map arguments;

  const WholesaleOrderHomePage({Key key, this.arguments}) : super(key: key);

  static setArguments(int initialIndex) {
    return {"initialIndex": initialIndex};
  }

  @override
  State<StatefulWidget> createState() {
    return _WholesaleOrderHomePageState();
  }
}

class _WholesaleOrderHomePageState extends BaseStoreState<WholesaleOrderHomePage>
    with TickerProviderStateMixin {
  List<String> _items = ["全部", "未付款", "待发货", "待收货"];
  TabController _tabController;
  OrderPositionType _positionType = OrderPositionType.onlineOrder;
  List<OrderListController> _orderListControllers = [
    OrderListController(),
    OrderListController(),
    OrderListController(),
    OrderListController(),
    OrderListController()
  ];
  @override
  void initState() {
    super.initState();
    int index = 0;
    if (widget.arguments != null) {
      index = widget.arguments["initialIndex"];
    }

    _tabController = TabController(initialIndex: index, length: 4, vsync: this);

  }


  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        title: "订单中心",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        appBackground: Colors.white,
        elevation: 0,
      ),
      body: _newBuildBody(),
      // body: _buildBody(),
    );
  }

  _newBuildBody() {
    return Container(
      child:
          Column(
            children: <Widget>[
              Container(
                  color: Colors.white,
                  child: SCTabBar(
                    labelColor: Colors.white,
                    needRefresh: true,
                    labelPadding: EdgeInsets.symmetric(horizontal: 20.rw),
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: AppColor.themeColor,
                    indicatorPadding:
                    EdgeInsets.symmetric(horizontal: rSize(20)),
                    itemBuilder: (int index) {
                      return _item(index);
                    },
                  )),

              Expanded(
                child: CacheTabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    WholesaleOrderListPage(
                      controller: _orderListControllers[0],
                      type: WholesaleOrderListType.all,

                    ),
                    WholesaleOrderListPage(
                      controller: _orderListControllers[1],
                      type: WholesaleOrderListType.unpaid,

                    ),
                    WholesaleOrderListPage(
                      controller: _orderListControllers[2],
                      type: WholesaleOrderListType.undelivered,

                    ),
                    WholesaleOrderListPage(
                      controller: _orderListControllers[3],
                      type: WholesaleOrderListType.receipt,

                    ),
                  ],
                ),
              )
            ],
          ),

    );
  }

  _item(int index) {
    String title = _items[index];
    bool selected = index == _tabController.index;
    return Container(
        height: rSize(30),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTextStyle.generate(
              ScreenAdapterUtils.setSp(selected ? 14 : 13),
              color: selected ? AppColor.themeColor : Colors.black,
              fontWeight: selected
                  ? FontWeight.w500
                  : FontWeight.lerp(FontWeight.w300, FontWeight.w400, 0.5)),
        ));
  }

}
