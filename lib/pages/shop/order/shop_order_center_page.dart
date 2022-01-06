/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  09:24 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/shop/order/shop_order_list_page.dart';
import 'package:jingyaoyun/pages/user/order/order_list_controller.dart';
import 'package:jingyaoyun/pages/user/order/order_list_page.dart';
import 'package:jingyaoyun/widgets/cache_tab_bar_view.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/tabbarWidget/sc_tab_bar.dart';
import 'package:jingyaoyun/widgets/title_switch.dart';

class ShopOrderCenterPage extends StatefulWidget {
  final Map arguments;

  const ShopOrderCenterPage({Key key, this.arguments}) : super(key: key);

  static setArguments(int initialIndex) {
    return {"initialIndex": initialIndex};
  }

  @override
  State<StatefulWidget> createState() {
    return _ShopOrderCenterPageState();
  }
}

class _ShopOrderCenterPageState extends BaseStoreState<ShopOrderCenterPage>
    with TickerProviderStateMixin {
  // List<String> _items = ["全部", "未付款", "待发货", "待收货", "售后/退款"];
  TitleSwitchController _titleSwitchController = TitleSwitchController();
  // List<String> _items = ["全部", "待发货", "已发货", "已收货", "退款/售后"];
  // List<String> _storeItems = ["全部", "待自提", "已收货", "退款/售后"];
  List<String> _items = [
    "全部",
    "待发货",
    "已发货",
    "已收货",
  ];
  List<String> _storeItems = [
    "全部",
    "待自提",
    "已收货",
  ];
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
    OrderListController()
  ];
  @override
  void initState() {
    super.initState();

    int index = 0;
    if (widget.arguments != null) {
      index = widget.arguments["initialIndex"];
    }
    _allTabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _allTabController.addListener(() {
      _titleSwitchController.changeIndex(_allTabController.index);
    });
    _tabController = TabController(initialIndex: index, length: 4, vsync: this);
    _storeTabController =
        TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        // title: "订单中心",
        title: _titleView(),
        themeData: AppThemes.themeDataGrey.appBarTheme,
        appBackground: Colors.white,
        elevation: 0,
      ),
      body: _newBuildBody(),
    );
  }

  _titleView() {
    return Container(
      child: TitleSwitch(
        controller: _titleSwitchController,
        height: 30,
        index: 0,
        titles: ["线上订单", "门店订单"],
        selectIndexBlock: (index) {
          if (index == 0) {
            _positionType = OrderPositionType.onlineOrder;
            _allTabController.index = 0;
            setState(() {});
            // if (_orderListControllers[_tabController.index]!=null
            // && _orderListControllers[_tabController.index].refresh!=null) {
            //   _orderListControllers[_tabController.index].refresh();
            // }
          } else {
            _positionType = OrderPositionType.storeOrder;
            _allTabController.index = 1;
            setState(() {});
            // if (_storeOrderListControllers[_storeTabController.index] != null
            // && _storeOrderListControllers[_storeTabController.index].refresh != null) {
            //   _storeOrderListControllers[_storeTabController.index].refresh();
            // }
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
                    ShopOrderListPage(
                      controller: _orderListControllers[0],
                      type: ShopOrderListType.all,
                      positionType: _positionType,
                    ),
                    ShopOrderListPage(
                      controller: _orderListControllers[1],
                      type: ShopOrderListType.undelivered,
                      positionType: _positionType,
                    ),
                    ShopOrderListPage(
                      controller: _orderListControllers[2],
                      type: ShopOrderListType.delivered,
                      positionType: _positionType,
                    ),
                    ShopOrderListPage(
                      controller: _orderListControllers[3],
                      type: ShopOrderListType.receipt,
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
                    return _storeItem(index);
                  },
                ),
              ),
              Expanded(
                child: CacheTabBarView(
                  controller: _storeTabController,
                  children: <Widget>[
                    ShopOrderListPage(
                      controller: _storeOrderListControllers[0],
                      type: ShopOrderListType.all,
                      positionType: _positionType,
                    ),
                    ShopOrderListPage(
                      controller: _storeOrderListControllers[1],
                      type: ShopOrderListType.undelivered,
                      positionType: _positionType,
                    ),
                    ShopOrderListPage(
                      controller: _storeOrderListControllers[2],
                      type: ShopOrderListType.delivered,
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
  // _buildBody() {
  //   return Column(
  //     children: <Widget>[
  //       Container(
  //         color: Colors.white,
  //         child: _positionType == OrderPositionType.onlineOrder
  //         ? SCTabBar(
  //           labelColor: Colors.white,
  //           needRefresh: true,
  //           labelPadding: EdgeInsets.zero,
  //           controller: _tabController,
  //           indicatorSize: TabBarIndicatorSize.label,
  //           indicatorColor: AppColor.themeColor,
  //           indicatorPadding:
  //               EdgeInsets.symmetric(horizontal: rSize(20)),
  //           itemBuilder: (int index) {
  //             return _item(index);
  //           },
  //         )
  //         : SCTabBar(
  //           labelColor: Colors.white,
  //           needRefresh: true,
  //           labelPadding: EdgeInsets.zero,
  //           controller: _storeTabController,
  //           indicatorSize: TabBarIndicatorSize.label,
  //           indicatorColor: AppColor.themeColor,
  //           indicatorPadding:
  //               EdgeInsets.symmetric(horizontal: rSize(20)),
  //           itemBuilder: (int index) {
  //             return _storeItem(index);
  //           },
  //         ),
  //       ),
  //       Expanded(
  //         child: Container(
  //           child: Stack(
  //             children: <Widget>[
  //               Expanded(
  //                 child: Offstage(
  //                   offstage: _positionType != OrderPositionType.onlineOrder,
  //                   child: CacheTabBarView(
  //                     controller: _tabController,
  //                     children: <Widget>[
  //                       ShopOrderListPage(controller: _orderListControllers[0],type: ShopOrderListType.all, positionType: _positionType,),
  //                       ShopOrderListPage(controller: _orderListControllers[1],type: ShopOrderListType.undelivered, positionType: _positionType,),
  //                       ShopOrderListPage(controller: _orderListControllers[2],type: ShopOrderListType.delivered, positionType: _positionType,),
  //                       ShopOrderListPage(controller: _orderListControllers[3],type: ShopOrderListType.receipt, positionType: _positionType,),
  //                       // Container()
  //                       // ShopOrderListPage(type: ShopOrderListType.afterSale,),
  //                       OrderAfterSalePage(arguments: OrderAfterSalePage.setArguments(OrderAfterSaleType.shopPage, _positionType, _orderListControllers[4]),),
  //                     ],
  //                   )
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Offstage(
  //                   offstage: _positionType != OrderPositionType.storeOrder,
  //                   child: CacheTabBarView(
  //                     controller: _storeTabController,
  //                     children: <Widget>[
  //                       ShopOrderListPage(controller: _storeOrderListControllers[0], type: ShopOrderListType.all, positionType: _positionType,),
  //                       ShopOrderListPage(controller: _storeOrderListControllers[1], type: ShopOrderListType.undelivered, positionType: _positionType,),
  //                       ShopOrderListPage(controller: _storeOrderListControllers[2], type: ShopOrderListType.delivered, positionType: _positionType,),
  //                       // OrderListPage(controller: _storeOrderListControllers[3], type: ShopOrderListType.receipt, positionType: _positionType,),
  //                       // Container()
  //                       OrderAfterSalePage(arguments: OrderAfterSalePage.setArguments(OrderAfterSaleType.shopPage, _positionType, _orderListControllers[4]),),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
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

  _storeItem(int index) {
    String title = _storeItems[index];
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
