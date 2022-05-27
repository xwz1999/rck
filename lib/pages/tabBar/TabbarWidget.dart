
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/constants/config.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/business/release_material_page.dart';
import 'package:recook/pages/home/home_page.dart';
import 'package:recook/pages/home/widget/aku_college_page.dart';
import 'package:recook/pages/live/pages/discovery_page.dart';
import 'package:recook/pages/live/widget/live_fab_location.dart';
import 'package:recook/pages/message/message_ceter_page.dart';
import 'package:recook/pages/shopping_cart/shopping_cart_page.dart';
import 'package:recook/pages/user/user_page.dart';
import 'package:recook/pages/wholesale/wholesale_car_page.dart';
import 'package:recook/pages/wholesale/wholesale_user_page.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/utils/versionInfo/version_tool.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/tabbarWidget/ace_bottom_navigation_bar.dart';
import 'package:oktoast/oktoast.dart';

class TabBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabBarWidgetState();
  }
}

class _TabBarWidgetState extends State<TabBarWidget>
    with TickerProviderStateMixin {
  TabController _tabController;
  HomeBottomBarController _bottomBarController;
  BuildContext _context;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      VersionTool.checkVersionInfo(_context);
    });
    _tabController = TabController(length: 5, vsync: this);
    _bottomBarController = HomeBottomBarController();
    _tabController.addListener(_tabListener);

    UserManager.instance.login.addListener(_loginListener);
    UserManager.instance.selectTabbar.addListener(_selectTabbar);
    UserManager.instance.refreshHomeBottomTabbar.addListener(() {
      setState(() {

      });
    });
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

  _tabListener() {
    setState(() {});
  }

  _showBottomModalSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(rSize(15))),
          ),
          child: Builder(builder: (context) {
            verticalButton(
              String title,
              String path, {
              VoidCallback onTap,
            }) {
              return CustomImageButton(
                onPressed: onTap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: rSize(20)),
                    Image.asset(
                      path,
                      height: rSize(44),
                      width: rSize(44),
                    ),
                    SizedBox(height: rSize(10)),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: rSP(14),
                        color: Color(0xFF666666),
                      ),
                    ),
                    SizedBox(height: rSize(20)),
                  ],
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // verticalButton(
                    //   '直播',
                    //   R.ASSETS_LIVE_ADD_STREAM_PNG,
                    //   onTap: () {
                    //     checkStartLive();
                    //   },
                    // ),
                    // verticalButton(
                    //   '视频',
                    //   R.ASSETS_LIVE_ADD_VIDEO_PNG,
                    //   onTap: () => CRoute.pushReplace(context, AddVideoPage()),
                    // ),
                    verticalButton(
                      '图文',
                      R.ASSETS_LIVE_ADD_IMAGE_PNG,
                      onTap: () =>
                          Get.off(ReleaseMaterialPage()),
                    ),
                  ],
                ),
                CustomImageButton(
                  height: rSize(66),
                  onPressed: () => Get.back(),
                  child: Text('取消',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(14),
                      )),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_context == null) {
      _context = context;
    }
    return Scaffold(
        floatingActionButton: _tabController.index == 2
            ? Container(
                padding: EdgeInsets.all(rSize(4)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: CustomImageButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (!UserManager.instance.haveLogin) {
                      showToast('未登陆，请先登陆');
                      Get.to(UserPage());
                    } else {
                      _showBottomModalSheet();
                    }
                  },
                  child: Container(
                    height: rSize(40),
                    width: rSize(40),
                    child: Image.asset(R.ASSETS_LIVE_RECOOK_FAB_PNG),
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FabLocation.recook,
        body: CacheTabBarView(
          physics: NeverScrollableScrollPhysics(),
          needAnimation: false,
          controller: _tabController,
          children: <Widget>[
            HomePage(
              tabController: _tabController,
            ),
            //MessageCenterPage(canback: false,),
            AkuCollegePage(),
            DiscoveryPage(),

            UserManager.instance.isWholesale?WholesaleCarPage(canBack: false,): ShoppingCartPage(),
            UserManager.instance.isWholesale?WholesaleUserPage(): UserPage()
          ],
        ),
        bottomNavigationBar: _changeBottomBar(context));
  }

  _changeBottomBar(BuildContext context) {
    return BottomBar(
      barController: _bottomBarController,
      tabChangeListener: (index) {
        if (!AppConfig.getShowCommission()) {
          // if(AppConfig.getShowCommission()){
          // if (index == 2) {
          //   UserManager.instance.refreshShopPage.value = !UserManager.instance.refreshShopPage.value;
          // }
          if (index == 3) {
            UserManager.instance.refreshUserPage.value =
                !UserManager.instance.refreshUserPage.value;
          }
        } else {
          if (index == 1) {
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
    _tabController?.removeListener(_tabListener);
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
  final HomeBottomBarController barController;
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
      items: [
        NavigationItemBean(

          textStr: UserManager.instance.isWholesale?'特批':'特推',
          image: UserManager.instance.isWholesale?AssetImage(Assets.tabbarPHome.path): AssetImage("assets/tabbar_sale_normal.png"),
          imageSelected:UserManager.instance.isWholesale?AssetImage(Assets.tabbarPHomeSelect.path): AssetImage("assets/tabbar_sale_selected.png"),
        ),
        NavigationItemBean(
          textStr: '消息',
          image: AssetImage("assets/tabbar_message.png"),
          imageSelected: AssetImage("assets/tabbar_message_select.png"),
        ),
        NavigationItemBean(
          textStr: '发现',
          image: AssetImage("assets/tabbar_find_normal.png"),
          imageSelected: AssetImage("assets/tabbar_find_selected.png"),
        ),
        NavigationItemBean(
          textStr: UserManager.instance.isWholesale?'进货单':'购物车',
          image: UserManager.instance.isWholesale?AssetImage(Assets.tabbarPCar.path): AssetImage("assets/tabbar_cart_normal.png"),
          imageSelected: UserManager.instance.isWholesale?AssetImage(Assets.tabbarPCarSelect.path): AssetImage("assets/tabbar_cart_selected.png"),
//              protrudingIcon: Icons.add
        ),
        NavigationItemBean(
          textStr: '我的',
          image: AssetImage("assets/tabbar_mine_normal_new.png"),
          imageSelected: AssetImage("assets/tabbar_mine_selected_new.png"),
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

class HomeBottomBarController {
  ValueNotifier<ACEBottomNavigationBarType> type =
      ValueNotifier(ACEBottomNavigationBarType.normal);
  ValueNotifier<int> selectIndex = ValueNotifier(0);
  bool selectIndexChange = false;
  void dispose() {
    type?.dispose();
  }
}
