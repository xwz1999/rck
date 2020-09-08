/*
 * ====================================================
 * package   : pages.tabBar
 * author    : Created by nansi.
 * time      : 2019/5/6  1:56 PM 
 * remark    : 
 * ====================================================
 */
import 'package:flutter/material.dart';
import 'package:recook/constants/config.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/business/business_page.dart';
import 'package:recook/pages/home/home_page.dart';
import 'package:recook/pages/shop/widget/normal_shop_page.dart';
import 'package:recook/pages/shopping_cart/shopping_cart_page.dart';
import 'package:recook/pages/user/user_page.dart';
import 'package:recook/third_party/bugly_helper.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/utils/versionInfo/version_tool.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/tabbarWidget/ace_bottom_navigation_bar.dart';

class TabBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabBarWidgetState();
  }
}

class _TabBarWidgetState extends State<TabBarWidget>
    with TickerProviderStateMixin {
  TabController _tabController;
  BottomBarController _bottomBarController;
  BuildContext _context;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      // _showUpDateAlert();
      // _getVersionInfo();
      VersionTool.checkVersionInfo(_context);
    });
    _tabController = TabController(
        length: (!UserManager.instance.haveLogin ||
                    UserLevelTool.currentRoleLevelEnum() ==
                        UserRoleLevel.Vip) &&
                !AppConfig.showExtraCommission
            ? 4
            : 5,
        vsync: this);
    _bottomBarController = BottomBarController();

    UserManager.instance.login.addListener(_loginListener);
    UserManager.instance.selectTabbar.addListener(_selectTabbar);
    // UserManager.instance.refreshUserRole.addListener(_refreshUserRoleTabBar);
    BuglyHelper.setUserInfo();
  }

  _loginListener() {
    print("context ---- $_context, ${UserManager.instance.haveLogin}");
    if (_context != null && UserManager.instance.haveLogin == false) {
      AppRouter.pushAndRemoveUntil(_context, RouteName.LOGIN);
    }
  }

  _selectTabbar() {
    _tabController.index = UserManager.instance.selectTabbarIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (_context == null) {
      _context = context;
    }
    return Scaffold(
        body: CacheTabBarView(
          physics: NeverScrollableScrollPhysics(),
          needAnimation: false,
          controller: _tabController,
          children:
              // AppConfig.getShowCommission()
              (!UserManager.instance.haveLogin ||
                          UserLevelTool.currentRoleLevelEnum() ==
                              UserRoleLevel.Vip) &&
                      !AppConfig.showExtraCommission
                  ? <Widget>[
                      HomePage(),
                      BusinessPage(),
                      ShoppingCartPage(),
                      UserPage()
                    ]
                  : <Widget>[
                      HomePage(),
                      BusinessPage(),
                      NormalShopPage(),
                      ShoppingCartPage(),
                      UserPage()
                    ],
        ),
        bottomNavigationBar: _changeBottomBar(context));
  }

  _changeBottomBar(BuildContext context) {
    return BottomBar(
      barController: _bottomBarController,
      tabChangeListener: (index) {
        if ((!UserManager.instance.haveLogin ||
            UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip)) {
          // if(AppConfig.getShowCommission()){
          // if (index == 2) {
          //   UserManager.instance.refreshShopPage.value = !UserManager.instance.refreshShopPage.value;
          // }
          if (index == 3) {
            UserManager.instance.refreshUserPage.value =
                !UserManager.instance.refreshUserPage.value;
          }
        } else {
          if (index == 2) {
            UserManager.instance.refreshShopPage.value =
                !UserManager.instance.refreshShopPage.value;
          }
          if (index == 4) {
            UserManager.instance.refreshUserPage.value =
                !UserManager.instance.refreshUserPage.value;
          }
        }
        _tabController.index = index;
      },
      onCenterItemClick: (index) {
        // AppRouter.model(context, RouteName.BUSINESS_DISTRICT_PUBLISH_PAGE);
      },
    );
  }

  @override
  void dispose() {
    DPrint.printf("- - - - - - dispose");
    _tabController.dispose();
    _bottomBarController.dispose();
    UserManager.instance.login?.removeListener(_loginListener);
    UserManager.instance.selectTabbar.removeListener(_selectTabbar);
    super.dispose();
  }

//  @override
//  bool get wantKeepAlive => true;
}

typedef TabChangeListener = Function(int index);

class BottomBar extends StatefulWidget {
  final BottomBarController barController;
  final TabChangeListener tabChangeListener;
  final TabChangeListener onCenterItemClick;

  const BottomBar({
    Key key,
    this.barController,
    this.tabChangeListener,
    this.onCenterItemClick,
  }) : assert(barController != null, "controller 不能为空");

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  Color selectedColor = AppColor.themeColor;
  Color unSelectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    widget.barController.type.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ACEBottomNavigationBar(
      barController: widget.barController,
      type: widget.barController.type.value,
      textUnSelectedColor: unSelectedColor,
      textSelectedColor: selectedColor,
      iconSelectedColor: selectedColor,
      iconUnSelectedColor: unSelectedColor,
      protrudingColor: selectedColor,
      // items: AppConfig.getShowCommission()
      items: (!UserManager.instance.haveLogin ||
                  UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip) &&
              !AppConfig.showExtraCommission
          ? [
              NavigationItemBean(
                textStr: '特卖',
                image: AssetImage("assets/tabbar_sale_normal.png"),
                imageSelected: AssetImage("assets/tabbar_sale_selected.png"),
              ),
              NavigationItemBean(
                textStr: '发现',
                image: AssetImage("assets/tabbar_find_normal.png"),
                imageSelected: AssetImage("assets/tabbar_find_selected.png"),
              ),
              NavigationItemBean(
                textStr: '购物车',
                image: AssetImage("assets/tabbar_cart_normal.png"),
                imageSelected: AssetImage("assets/tabbar_cart_selected.png"),
//              protrudingIcon: Icons.add
              ),
              NavigationItemBean(
                textStr: '我的',
                image: AssetImage("assets/tabbar_mine_normal_new.png"),
                imageSelected:
                    AssetImage("assets/tabbar_mine_selected_new.png"),
              )
            ]
          : [
              NavigationItemBean(
                textStr: '特卖',
                image: AssetImage("assets/tabbar_sale_normal.png"),
                imageSelected: AssetImage("assets/tabbar_sale_selected.png"),
              ),
              NavigationItemBean(
                textStr: '发现',
                image: AssetImage("assets/tabbar_find_normal.png"),
                imageSelected: AssetImage("assets/tabbar_find_selected.png"),
              ),
              NavigationItemBean(
                textStr: '店铺',
                image: AssetImage("assets/tabbar_shop_normal.png"),
                imageSelected: AssetImage("assets/tabbar_shop_selected.png"),
              ),
              NavigationItemBean(
                textStr: '购物车',
                image: AssetImage("assets/tabbar_cart_normal.png"),
                imageSelected: AssetImage("assets/tabbar_cart_selected.png"),
//              protrudingIcon: Icons.add
              ),
              NavigationItemBean(
                textStr: '我的',
                image: AssetImage("assets/tabbar_mine_normal_new.png"),
                imageSelected:
                    AssetImage("assets/tabbar_mine_selected_new.png"),
              )
            ],
      onTabChangedListener: (index) {
        print(" $index");
        if (widget.tabChangeListener != null) {
          // if ((index == 4 || index == 5) && !UserManager.instance.haveLogin) {
          // AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
          // return;
          // }
          if (index == 3) {
            UserManager.instance.refreshShoppingCart.value = true;
          }
          widget.tabChangeListener(index);
        }
      },
      onProtrudingItemClickListener: (int index) {
        widget.onCenterItemClick(index);
      },
    );
  }
}

class BottomBarController {
  ValueNotifier<ACEBottomNavigationBarType> type =
      ValueNotifier(ACEBottomNavigationBarType.normal);
  ValueNotifier<int> selectIndex = ValueNotifier(0);
  bool selectIndexChange = false;
  void dispose() {
    type?.dispose();
  }
}
