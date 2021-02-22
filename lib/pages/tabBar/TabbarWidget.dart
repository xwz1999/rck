/*
 * ====================================================
 * package   : pages.tabBar
 * author    : Created by nansi.
 * time      : 2019/5/6  1:56 PM 
 * remark    : 
 * ====================================================
 */
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/config.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/agreements/live_agreement_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/home_page.dart';
import 'package:recook/pages/home/widget/goods_hot_list_page.dart';
import 'package:recook/pages/live/functions/live_function.dart';
import 'package:recook/pages/live/live_stream/live_page.dart';
import 'package:recook/pages/live/models/live_resume_model.dart';
import 'package:recook/pages/live/video/add_video_page.dart';
import 'package:recook/pages/live/pages/discovery_page.dart';
import 'package:recook/pages/live/widget/live_fab_location.dart';
import 'package:recook/pages/shop/widget/normal_shop_page.dart';
import 'package:recook/pages/shopping_cart/shopping_cart_page.dart';
import 'package:recook/pages/user/user_page.dart';
import 'package:recook/third_party/bugly_helper.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/utils/print_util.dart';
import 'package:recook/utils/rui_code_util.dart';
import 'package:recook/utils/versionInfo/version_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/tabbarWidget/ace_bottom_navigation_bar.dart';
import 'package:recook/widgets/toast.dart';

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
    _tabController = TabController(length: 5, vsync: this);
    _bottomBarController = BottomBarController();
    _tabController.addListener(_tabListener);

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

  _tabListener() {
    setState(() {});
  }

  _showBottomModalSheet() {
    BuildContext fatherContext = context;
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
                    verticalButton(
                      '直播',
                      R.ASSETS_LIVE_ADD_STREAM_PNG,
                      onTap: () {
                        checkStartLive(context, fatherContext);
                      },
                    ),
                    verticalButton(
                      '视频',
                      R.ASSETS_LIVE_ADD_VIDEO_PNG,
                      onTap: () => CRoute.pushReplace(context, AddVideoPage()),
                    ),
                    // verticalButton(
                    //   '图文',
                    //   R.ASSETS_LIVE_ADD_IMAGE_PNG,
                    //   onTap: () {},
                    // ),
                  ],
                ),
                CustomImageButton(
                  height: rSize(66),
                  onPressed: () => Navigator.pop(context),
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
                      CRoute.push(context, UserPage());
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
          children:
              // AppConfig.getShowCommission()
              !AppConfig.getShowCommission()
                  ? <Widget>[
                      HomePage(),
                      GoodsHotListPage(),
                      DiscoveryPage(),
                      // BusinessPage(),
                      ShoppingCartPage(),
                      UserPage()
                    ]
                  : <Widget>[
                      HomePage(),
                      NormalShopPage(),
                      DiscoveryPage(),
                      // BusinessPage(),
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
    _tabController.dispose();
    _bottomBarController.dispose();
    UserManager.instance.login?.removeListener(_loginListener);
    UserManager.instance.selectTabbar.removeListener(_selectTabbar);
    _tabController?.removeListener(_tabListener);
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
  Future<GoodsDetailModel> _getDetail(int goodsId) async {
    GoodsDetailModel _goodsDetail = await GoodsDetailModelImpl.getDetailInfo(
        goodsId, UserManager.instance.user.info.id);
    if (_goodsDetail.code != HttpStatus.SUCCESS) {
      Toast.showError(_goodsDetail.msg);
      return null;
    }
    return _goodsDetail;
  }

  Future<ResultData> _getUserInfo(int id) async {
    return await HttpManager.post(UserApi.userInfo, {'userId': id});
  }

  _clipboardListener() async {
    String rawData = (await Clipboard.getData(Clipboard.kTextPlain)).text;
    bool isRUICode = RUICodeUtil.isCode(rawData);
    GoodsDetailModel goodsDetailModel;

    //瑞口令
    if (isRUICode) {
      RUICodeModel model = RUICodeUtil.decrypt(rawData);

      goodsDetailModel = await _getDetail(model.goodsId);
      //user info
      String userImg = '';
      String userName = '';
      ResultData resultData = await _getUserInfo(model.userId);
      if (resultData.data != null && resultData.data['data'] != null) {
        userImg = resultData.data['data']['headImgUrl'];
        userName = resultData.data['data']['nickname'];
      }
      if (goodsDetailModel != null)
        showDialog(
          context: context,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(rSize(9)),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: rSize(50)),
                    padding: EdgeInsets.all(rSize(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Material(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(rSize(17)),
                              child: FadeInImage.assetNetwork(
                                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                                image: Api.getImgUrl(userImg),
                                height: rSize(34),
                                width: rSize(34),
                                fit: BoxFit.cover,
                              ),
                            ),
                            rWBox(8),
                            Expanded(
                              child: Text(
                                userName ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: rSP(14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        rHBox(4),
                        Text(
                          '给你分享了商品',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: rSP(12),
                          ),
                        ),
                        rHBox(4),
                        Material(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(rSize(8)),
                          child: FadeInImage.assetNetwork(
                            placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                            image: Api.getImgUrl(
                                goodsDetailModel.data.mainPhotos.first.url),
                            height: rSize(256),
                            fit: BoxFit.cover,
                          ),
                        ),
                        rHBox(10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '¥',
                              style: TextStyle(
                                color: Color(0xFFE13327),
                                fontSize: rSP(14),
                              ),
                            ),
                            Text(
                              '${goodsDetailModel.data.price.max.discountPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Color(0xFFE13327),
                                fontSize: rSP(18),
                              ),
                            ),
                            Text(
                              '/赚${goodsDetailModel.data.price.max.commission.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: Color(0xFFE13327),
                                fontSize: rSP(10),
                              ),
                            ),
                          ],
                        ),
                        rHBox(4),
                        Text(
                          goodsDetailModel.data.goodsName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(),
                        ),
                        Center(
                          child: MaterialButton(
                            elevation: 0,
                            shape: StadiumBorder(),
                            onPressed: () {
                              CRoute.pushReplace(
                                  context,
                                  CommodityDetailPage(
                                    arguments: CommodityDetailPage.setArguments(
                                      model.goodsId,
                                    ),
                                  ));
                            },
                            height: rSize(36),
                            minWidth: rSize(235),
                            padding: EdgeInsets.zero,
                            color: Color(0xFFDB2D2D),
                            child: Text(
                              '查看详情',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                rHBox(30),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Material(
                    color: Colors.transparent,
                    child: Icon(
                      CupertinoIcons.clear_circled,
                      size: rSize(40),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

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
      items: !AppConfig.getShowCommission()
          ? [
              NavigationItemBean(
                textStr: '特卖',
                image: AssetImage("assets/tabbar_sale_normal.png"),
                imageSelected: AssetImage("assets/tabbar_sale_selected.png"),
              ),
              NavigationItemBean(
                textStr: '排行榜',
                image: AssetImage("assets/tabbar_shop_normal.png"),
                imageSelected: AssetImage("assets/tabbar_shop_selected.png"),
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
                textStr: '店铺',
                image: AssetImage("assets/tabbar_shop_normal.png"),
                imageSelected: AssetImage("assets/tabbar_shop_selected.png"),
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
            ],
      onTabChangedListener: (index) {
        if (index == 0) {
          _clipboardListener();
        }
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
