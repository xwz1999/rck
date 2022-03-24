
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/order/guide_order_view.dart';
import 'package:jingyaoyun/pages/user/order/order_list_controller.dart';
import 'package:jingyaoyun/pages/user/order/order_list_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_order_list_page.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/cache_tab_bar_view.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/tabbarWidget/sc_tab_bar.dart';
import 'package:jingyaoyun/widgets/title_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';



class WholesaleOrderHomePage extends StatefulWidget {
  // final Map arguments;
  final int initialIndex;
  const WholesaleOrderHomePage({Key key, this.initialIndex}) : super(key: key);

  // static setArguments(int initialIndex) {
  //   return {"initialIndex": initialIndex};
  // }

  @override
  State<StatefulWidget> createState() {
    return _WholesaleOrderHomePageState();
  }
}

class _WholesaleOrderHomePageState extends BaseStoreState<WholesaleOrderHomePage>
    with TickerProviderStateMixin {
  TitleSwitchController _titleSwitchController = TitleSwitchController();
  List<String> _items = ["全部","待处理","未付款", "待发货", "待收货"];
  TabController _allTabController;
  TabController _tabController;
  TabController _storeTabController;
  OrderPositionType _positionType = OrderPositionType.onlineOrder;
  List<OrderListController> _orderListControllers = [
    OrderListController(),
    OrderListController(),
    OrderListController(),
    OrderListController(),
    OrderListController()
  ];

  List<OrderListController> _storeOrderListControllers = [
    OrderListController(),
    OrderListController(),
    OrderListController(),
    OrderListController(),
    OrderListController()
  ];

  List<String> titles = ["自购订单", "VIP店铺订单"];

  @override
  void initState() {
    super.initState();
    int index = 0;
    if (widget.initialIndex != null) {
      index = widget.initialIndex;
    }
    if(UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary) {
      _allTabController = TabController(length: 2, vsync: this, initialIndex: 0);
    }else{
      _allTabController = TabController(length: 1, vsync: this, initialIndex: 0);
      titles = ["自购订单"];
    }



    _allTabController.addListener(() {
      _titleSwitchController.changeIndex(_allTabController.index);
    });
    _tabController = TabController(initialIndex: index, length: 5, vsync: this);
    _storeTabController =
        TabController(initialIndex: 0, length: 5, vsync: this);

  }


  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        title: _titleView(),
        themeData: AppThemes.themeDataGrey.appBarTheme,
        appBackground: Colors.white,
        elevation: 0,
      ),
      body: _newBuildBody()
      // body: _buildBody(),
    );
  }

  // _newBuildBody() {
  //   return Container(
  //     child:
  //         Column(
  //           children: <Widget>[
  //             Container(
  //                 color: Colors.white,
  //                 child: SCTabBar(
  //                   labelColor: Colors.white,
  //                   needRefresh: true,
  //                   labelPadding: EdgeInsets.symmetric(horizontal: 20.rw),
  //                   controller: _tabController,
  //                   indicatorSize: TabBarIndicatorSize.label,
  //                   indicatorColor: AppColor.themeColor,
  //                   indicatorPadding:
  //                   EdgeInsets.symmetric(horizontal: rSize(20)),
  //                   itemBuilder: (int index) {
  //                     return _item(index);
  //                   },
  //                 )),
  //
  //             Expanded(
  //               child: CacheTabBarView(
  //                 controller: _tabController,
  //                 children: <Widget>[
  //                   WholesaleOrderListPage(
  //                     controller: _orderListControllers[0],
  //                     type: WholesaleOrderListType.all,
  //
  //                   ),
  //                   WholesaleOrderListPage(
  //                     controller: _orderListControllers[1],
  //                     type: WholesaleOrderListType.unpaid,
  //
  //                   ),
  //                   WholesaleOrderListPage(
  //                     controller: _orderListControllers[2],
  //                     type: WholesaleOrderListType.undelivered,
  //
  //                   ),
  //                   WholesaleOrderListPage(
  //                     controller: _orderListControllers[3],
  //                     type: WholesaleOrderListType.receipt,
  //
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //
  //   );
  // }

  _titleView() {
    return Container(
      child:

      UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary?
      TitleSwitch(
        controller: _titleSwitchController,
        height: 30,
        index: 0,
        titles: titles,
        selectIndexBlock: (index) {

          if(UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary){
            if (index == 0) {
              _positionType = OrderPositionType.onlineOrder;
              _allTabController.index = 0;

              setState(() {});

            } else {
              _positionType = OrderPositionType.storeOrder;
              _allTabController.index = 1;
              setState(() {});

            }
          }

        },
        backgroundWidget: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xffE8E8E8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ):Text(
        "自购订单",
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 18.rsp,
        ),
      ),
    );
  }


  _newBuildBody() {
    return Container(
      child: CacheTabBarView(
        controller: _allTabController,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  color: Colors.white,
                  child: SCTabBar(
                    labelColor: Colors.white,
                    needRefresh: true,
                    labelPadding: EdgeInsets.zero,
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
                      positionType: _positionType,
                    ),
                    WholesaleOrderListPage(
                      controller: _orderListControllers[1],
                      type: WholesaleOrderListType.unDeal,
                      positionType: _positionType,
                    ),
                    WholesaleOrderListPage(
                      controller: _orderListControllers[2],
                      type: WholesaleOrderListType.unPay,
                      positionType: _positionType,
                    ),
                    WholesaleOrderListPage(
                      controller: _orderListControllers[3],
                      type: WholesaleOrderListType.undelivered,
                      positionType: _positionType,
                    ),
                    WholesaleOrderListPage(
                      controller: _orderListControllers[4],
                      type: WholesaleOrderListType.unReceipt,
                      positionType: _positionType,
                    ),
                    // Container()
                    // ShopOrderListPage(type: ShopOrderListType.afterSale,),
                    // OrderAfterSalePage(arguments: OrderAfterSalePage.setArguments(OrderAfterSaleType.shopPage, _positionType, _orderListControllers[4]),),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: SCTabBar(
                  labelColor: Colors.white,
                  needRefresh: true,
                  labelPadding: EdgeInsets.zero,
                  controller: _storeTabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: AppColor.themeColor,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: rSize(20)),
                  itemBuilder: (int index) {
                    return _storeitem(index);
                  },
                ),
              ),
              Expanded(
                child: CacheTabBarView(
                  controller: _storeTabController,
                  children: <Widget>[
                    WholesaleOrderListPage(
                      controller: _storeOrderListControllers[0],
                      type: WholesaleOrderListType.all,
                      positionType: _positionType,
                    ),
                    WholesaleOrderListPage(
                      controller: _storeOrderListControllers[1],
                      type: WholesaleOrderListType.unDeal,
                      positionType: _positionType,
                    ),
                    WholesaleOrderListPage(
                      controller: _storeOrderListControllers[2],
                      type: WholesaleOrderListType.unPay,
                      positionType: _positionType,
                    ),
                    WholesaleOrderListPage(
                      controller: _storeOrderListControllers[3],
                      type: WholesaleOrderListType.undelivered,
                      positionType: _positionType,
                    ),
                    WholesaleOrderListPage(
                      controller: _storeOrderListControllers[4],
                      type: WholesaleOrderListType.unReceipt,
                      positionType: _positionType,
                    ),
                    // OrderListPage(controller: _storeOrderListControllers[3], type: ShopOrderListType.receipt, positionType: _positionType,),
                    // Container()
                    // OrderAfterSalePage(arguments: OrderAfterSalePage.setArguments(OrderAfterSaleType.shopPage, _positionType, _orderListControllers[4]),),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // _normalBuildBody(){
  //   return Container(
  //     child: CacheTabBarView(
  //       controller: _allTabController,
  //       children: <Widget>[
  //         Column(
  //           children: <Widget>[
  //             Container(
  //                 color: Colors.white,
  //                 child: SCTabBar(
  //                   labelColor: Colors.white,
  //                   needRefresh: true,
  //                   labelPadding: EdgeInsets.zero,
  //                   controller: _tabController,
  //                   indicatorSize: TabBarIndicatorSize.label,
  //                   indicatorColor: AppColor.themeColor,
  //                   indicatorPadding:
  //                   EdgeInsets.symmetric(horizontal: rSize(20)),
  //                   itemBuilder: (int index) {
  //                     return _item(index);
  //                   },
  //                 )),
  //             Expanded(
  //               child: CacheTabBarView(
  //                 controller: _tabController,
  //                 children: <Widget>[
  //                   WholesaleOrderListPage(
  //                     controller: _orderListControllers[0],
  //                     type: WholesaleOrderListType.all,
  //                     positionType: _positionType,
  //                   ),
  //                   WholesaleOrderListPage(
  //                     controller: _orderListControllers[1],
  //                     type: WholesaleOrderListType.unpaid,
  //                     positionType: _positionType,
  //                   ),
  //                   WholesaleOrderListPage(
  //                     controller: _orderListControllers[2],
  //                     type: WholesaleOrderListType.undelivered,
  //                     positionType: _positionType,
  //                   ),
  //                   WholesaleOrderListPage(
  //                     controller: _orderListControllers[3],
  //                     type: WholesaleOrderListType.receipt,
  //                     positionType: _positionType,
  //                   ),
  //                   // Container()
  //                   // ShopOrderListPage(type: ShopOrderListType.afterSale,),
  //                   // OrderAfterSalePage(arguments: OrderAfterSalePage.setArguments(OrderAfterSaleType.shopPage, _positionType, _orderListControllers[4]),),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }

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

  _storeitem(int index) {
    String title = _items[index];
    bool selected = index == _storeTabController.index;
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
