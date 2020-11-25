/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-02  09:24 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/order/order_list_controller.dart';
import 'package:recook/pages/user/order/order_list_page.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/tabbarWidget/sc_tab_bar.dart';
import 'package:recook/widgets/title_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCenterPage extends StatefulWidget {
  final Map arguments;

  const OrderCenterPage({Key key, this.arguments}) : super(key: key);

  static setArguments(int initialIndex) {
    return {"initialIndex": initialIndex};
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderCenterPageState();
  }
}

class _OrderCenterPageState extends BaseStoreState<OrderCenterPage>
    with TickerProviderStateMixin {
  bool _showAlert = true;
  TitleSwitchController _titleSwitchController = TitleSwitchController();
  final String _alertMessage =
      "重要提醒：请谨防网络及客服诈骗！瑞库客不会以订单异常、系统维护等情况为由，要求你进行退款操作。";
  // List<String> _items = ["全部", "未付款", "待发货", "待收货", "售后/退款"];
  List<String> _items = ["全部", "未付款", "待发货", "待收货"];
  List<String> _storeItems = ["全部", "未付款", "待自提", "待评价"];
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
    _getHaveReadAlertMessage().then((have) {
      _showAlert = !have;
      if (mounted) {
        setState(() {});
      }
    });
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
        TabController(initialIndex: 0, length: 4, vsync: this);
  }

  _getHaveReadAlertMessage() async {
    // 获取实例
    var prefs = await SharedPreferences.getInstance();
    String key = 'HaveReadAlertMessage+${UserManager.instance.user.info.id}';
    if (prefs.getKeys().contains(key)) {
      // 获取存储数据
      bool have = prefs.getBool(key) ?? false;
      return have;
    }
    return false;
  }

  _setHaveReadAlertMessage() async {
    var prefs = await SharedPreferences.getInstance();
    // 存储数据
    prefs.setBool(
        'HaveReadAlertMessage+${UserManager.instance.user.info.id}', true);
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
        actions: [
          // MaterialButton(
          //   minWidth: rSize(74),
          //   onPressed: () {
          //     AppRouter.push(context, RouteName.USER_INVOICE);
          //   },
          //   child: Text(
          //     '开发票',
          //     style: TextStyle(
          //       color: AppColor.blackColor,
          //       fontSize: ScreenAdapterUtils.setSp(14),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: _newBuildBody(),
      // body: _buildBody(),
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
          // setState(() {});
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
              _showAlert ? _alertWidget() : Container(),
              Expanded(
                child: CacheTabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    OrderListPage(
                      controller: _orderListControllers[0],
                      type: OrderListType.all,
                      positionType: _positionType,
                    ),
                    OrderListPage(
                      controller: _orderListControllers[1],
                      type: OrderListType.unpaid,
                      positionType: _positionType,
                    ),
                    OrderListPage(
                      controller: _orderListControllers[2],
                      type: OrderListType.undelivered,
                      positionType: _positionType,
                    ),
                    OrderListPage(
                      controller: _orderListControllers[3],
                      type: OrderListType.receipt,
                      positionType: _positionType,
                    ),
                    // Container()
                    // OrderListPage(
                    //   controller: _orderListControllers[4],
                    //   type: OrderListType.afterSale,
                    //   positionType: _positionType,
                    // ),
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
                    OrderListPage(
                      controller: _storeOrderListControllers[0],
                      type: OrderListType.all,
                      positionType: _positionType,
                    ),
                    OrderListPage(
                      controller: _storeOrderListControllers[1],
                      type: OrderListType.unpaid,
                      positionType: _positionType,
                    ),
                    OrderListPage(
                      controller: _storeOrderListControllers[2],
                      type: OrderListType.undelivered,
                      positionType: _positionType,
                    ),
                    // OrderListPage(controller: _storeOrderListControllers[3], type: OrderListType.receipt, positionType: _positionType,),
                    // Container()
                    OrderListPage(
                      controller: _storeOrderListControllers[3],
                      type: OrderListType.afterSale,
                      positionType: _positionType,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: _positionType == OrderPositionType.onlineOrder
              ? SCTabBar(
                  labelColor: Colors.white,
                  needRefresh: true,
                  labelPadding: EdgeInsets.zero,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: AppColor.themeColor,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: rSize(20)),
                  itemBuilder: (int index) {
                    return _item(index);
                  },
                )
              : SCTabBar(
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
        _showAlert ? _alertWidget() : Container(),
        Expanded(
          child: Container(
            child: Stack(
              children: <Widget>[
                Expanded(
                  child: Offstage(
                    offstage: _positionType != OrderPositionType.onlineOrder,
                    child: CacheTabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        OrderListPage(
                          controller: _orderListControllers[0],
                          type: OrderListType.all,
                          positionType: _positionType,
                        ),
                        OrderListPage(
                          controller: _orderListControllers[1],
                          type: OrderListType.unpaid,
                          positionType: _positionType,
                        ),
                        OrderListPage(
                          controller: _orderListControllers[2],
                          type: OrderListType.undelivered,
                          positionType: _positionType,
                        ),
                        OrderListPage(
                          controller: _orderListControllers[3],
                          type: OrderListType.receipt,
                          positionType: _positionType,
                        ),
                        // Container()
                        OrderListPage(
                          controller: _orderListControllers[4],
                          type: OrderListType.afterSale,
                          positionType: _positionType,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Offstage(
                      offstage: _positionType != OrderPositionType.storeOrder,
                      child: CacheTabBarView(
                        controller: _storeTabController,
                        children: <Widget>[
                          OrderListPage(
                            controller: _storeOrderListControllers[0],
                            type: OrderListType.all,
                            positionType: _positionType,
                          ),
                          OrderListPage(
                            controller: _storeOrderListControllers[1],
                            type: OrderListType.unpaid,
                            positionType: _positionType,
                          ),
                          OrderListPage(
                            controller: _storeOrderListControllers[2],
                            type: OrderListType.undelivered,
                            positionType: _positionType,
                          ),
                          // OrderListPage(controller: _storeOrderListControllers[3], type: OrderListType.receipt, positionType: _positionType,),
                          // Container()
                          OrderListPage(
                            controller: _storeOrderListControllers[3],
                            type: OrderListType.afterSale,
                            positionType: _positionType,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
        // Expanded(
        //   child: _positionType == OrderPositionType.onlineOrder
        //    ? CacheTabBarView(
        //     controller: _tabController,
        //     children: <Widget>[
        //       OrderListPage(controller: _orderListControllers[0], type: OrderListType.all, positionType: _positionType,),
        //       OrderListPage(controller: _orderListControllers[1], type: OrderListType.unpaid, positionType: _positionType,),
        //       OrderListPage(controller: _orderListControllers[2], type: OrderListType.undelivered, positionType: _positionType,),
        //       OrderListPage(controller: _orderListControllers[3], type: OrderListType.receipt, positionType: _positionType,),
        //       // Container()
        //       OrderListPage(controller: _orderListControllers[4], type: OrderListType.afterSale, positionType: _positionType,),
        //     ],
        //   )
        //   : CacheTabBarView(
        //     controller: _storeTabController,
        //     children: <Widget>[
        //       OrderListPage(controller: _storeOrderListControllers[0], type: OrderListType.all, positionType: _positionType,),
        //       OrderListPage(controller: _storeOrderListControllers[1], type: OrderListType.unpaid, positionType: _positionType,),
        //       OrderListPage(controller: _storeOrderListControllers[2], type: OrderListType.undelivered, positionType: _positionType,),
        //       // OrderListPage(controller: _storeOrderListControllers[3], type: OrderListType.receipt, positionType: _positionType,),
        //       // Container()
        //       OrderListPage(controller: _storeOrderListControllers[3], type: OrderListType.afterSale, positionType: _positionType,),
        //     ],
        //   ),
        // )
      ],
    );
  }

  _alertWidget() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Color(0xfffffbe3),
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/order_center_alert_icon.png",
            width: 20,
            height: 20,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(_alertMessage,
                  maxLines: 2,
                  style: TextStyle(
                    color: Color(0xffff6d2c),
                    fontSize: 10,
                  )),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showAlert = false;
              _setHaveReadAlertMessage();
              setState(() {});
            },
            child: Image.asset(
              "assets/order_center_alert_close_icon.png",
              width: 11,
              height: 11,
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
