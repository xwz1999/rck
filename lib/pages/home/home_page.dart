import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response;
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/daos/home_dao.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/banner_list_model.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/models/category_model.dart';
import 'package:jingyaoyun/models/country_list_model.dart';
import 'package:jingyaoyun/models/home_weather_model.dart';
import 'package:jingyaoyun/models/promotion_goods_list_model.dart';
import 'package:jingyaoyun/models/promotion_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/brandgoods_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/classify_page.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/home_page_tabbar.dart';
import 'package:jingyaoyun/pages/home/items/item_row_acitivity.dart';
import 'package:jingyaoyun/pages/home/model/king_coin_list_model.dart';
import 'package:jingyaoyun/pages/home/promotion_time_tool.dart';
import 'package:jingyaoyun/pages/home/search_page.dart';
import 'package:jingyaoyun/pages/home/widget/animated_home_background.dart';
import 'package:jingyaoyun/pages/home/widget/good_high_commission_page.dart';
import 'package:jingyaoyun/pages/home/widget/good_preferential_list_page.dart';
import 'package:jingyaoyun/pages/home/widget/goods_list_temp_page.dart';
import 'package:jingyaoyun/pages/home/widget/home_countdown_widget.dart';
import 'package:jingyaoyun/pages/home/widget/home_sliver_app_bar.dart';
import 'package:jingyaoyun/pages/home/widget/home_weather_view.dart';
import 'package:jingyaoyun/pages/home/wx_page.dart';
import 'package:jingyaoyun/pages/tabBar/rui_code_listener.dart';
import 'package:jingyaoyun/pages/user/functions/user_func.dart';
import 'package:jingyaoyun/pages/wholesale/func/wholesale_func.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_customer_model.dart';
import 'package:jingyaoyun/pages/wholesale/models/wholesale_good_model.dart';
import 'package:jingyaoyun/pages/wholesale/more_goods/whoesale_goods_grid.dart';
import 'package:jingyaoyun/pages/wholesale/seven_card_dialog.dart';
import 'package:jingyaoyun/pages/wholesale/vip_shop_card_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholeasale_detail_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_customer_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_home_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_search_page.dart';
import 'package:jingyaoyun/third_party/wechat/wechat_utils.dart';
import 'package:jingyaoyun/utils/android_back_desktop.dart';
import 'package:jingyaoyun/utils/app_router.dart';
import 'package:jingyaoyun/utils/color_util.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/utils/permission_tool.dart';
import 'package:jingyaoyun/utils/share_tool.dart';
import 'package:jingyaoyun/utils/storage/hive_store.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/banner.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/goods_item.dart';
import 'package:jingyaoyun/widgets/home_gif_header.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:jingyaoyun/widgets/toast.dart';
import 'package:jingyaoyun/widgets/weather_page/weather_city_model.dart';
import 'package:jingyaoyun/widgets/weather_page/weather_city_page.dart';
import 'package:jingyaoyun/widgets/webView.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

// import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:power_logger/power_logger.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../utils/text_utils.dart';
import 'classify/classify_country_page.dart';
import 'items/item_brand_detail_grid.dart';

class HomeItem {
  String title;
  String imagePath;

  HomeItem(this.title, this.imagePath);
}

class HomeAcitvityItem {
  String logoUrl;
  String website;

  HomeAcitvityItem(this.logoUrl, this.website);
}

class HomePage extends StatefulWidget {
  final TabController tabController;

  const HomePage({Key key, this.tabController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class ClipboardListenerValue {
  static bool canListen = true;
}

class _HomePageState extends BaseStoreState<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Map<String, Object> _weatherLocation;
  TabController _tabController;
  int _tabIndex = 0;

  List<KingCoinListModel> kingCoinListModelList;

//控制额外功能显示（后端控制）
//false iOS隐藏
//true 全部显示

  List<BannerModel> _bannerList = [];
  List<Promotion> _promotionList = [];
  List _promotionGoodsList = [];
  Map _activityMap;
  GSRefreshController _gsRefreshController;
  ScrollController _sliverListController;

  // 天气数据
  HomeWeatherModel _homeWeatherModel;
  WeatherCityModel _weatherCityModel;

//定位
  AMapFlutterLocation _amapFlutterLocation;

  //高度
  double screenWidth = 0;
  double weatherHeight = 0;
  double bannerHeight = 0;
  double buttonsHeight = 100.rw;
  double t1Height = 0;
  double t23Height = 0;
  double t4Height = 0;
  double timeHeight = 60.rw;
  double tabbarHeight = 40.rw;
  HomeCountdownController _homeCountdownController;
  Color _backgroundColor;
  StateSetter _bannerState;
  GlobalKey<AnimatedHomeBackgroundState> _animatedBackgroundState = GlobalKey();
  GlobalKey<HomeSliverAppBarState> _sliverAppBarGlobalKey = GlobalKey();

  String keyWords = '锅';

  GifController _gifController;
  StateSetter _wholesaleState;


  String debugLable = 'Unknown';   /*错误信息*/
  final JPush jpush = new JPush();

  @override
  bool needStore() {
    return true;
  }

  Color getCurrentThemeColor() {
    return getStore().state.themeData.appBarTheme.color;
  }

  Color getCurrentAppItemColor() {
    return getStore().state.themeData.appBarTheme.iconTheme.color;
  }

  ///监听剪切板

  @override
  void initState() {
    super.initState();
    if (UserManager.instance.haveLogin) {
      Future.delayed(Duration.zero, () async {
        UserManager.instance.getSeven = await WholesaleFunc.get7();
        if (!UserManager.instance.getSeven) {
          showDialog(
            context: context,
            builder: (context) => SevenCardDialog(),
          );
        }
        //
        // if (HiveStore.appBox
        //         .get('showSeven${UserManager.instance.user.info.id}') !=
        //     null) {
        //   if (!HiveStore.appBox
        //       .get('showSeven${UserManager.instance.user.info.id}')) {
        //     if (!UserManager.instance.getSeven) {
        //       showDialog(
        //         context: context,
        //         builder: (context) => SevenCardDialog(),
        //       );
        //     }
        //   }
        // } else {
        //   if (!UserManager.instance.getSeven) {
        //     showDialog(
        //       context: context,
        //       builder: (context) => SevenCardDialog(),
        //     );
        //   }
        // }
      });
    }
    RUICodeListener(context).clipboardListener();
    _updateSource();
    _getWeather();
    Future.delayed(Duration.zero, () async {
      bool location = await Permission.location.isGranted;
      if (Platform.isIOS) {
        initLocation();
      }
      if (location == true) {
        initLocation();
      }
    });

    _gifController = GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );

    kingCoinListModelList = UserManager.instance.kingCoinListModelList;

    _amapFlutterLocation = AMapFlutterLocation();

    // 判断微信是否登录
    WeChatUtils.initial();
    // meiqia注册
    // MQManager.initial();
    ShareTool.init();
    // _backgroundColor = AppColor.themeColor;
    _homeCountdownController = HomeCountdownController();
    //
    // UserManager.instance.openInstallGoodsId
    //     .addListener(_openInstallGoodsIdListener);

    UserManager.instance.openInstallLive.addListener(() {
      if (!TextUtils.isEmpty(getStore().state.openinstall.type)) {
        int goodsid = 0;
        try {
          goodsid = int.parse(getStore().state.openinstall.goodsid);
        } catch (e) {
          getStore().state.openinstall.goodsid = "";
          return;
        }
        AppRouter.push(context, RouteName.COMMODITY_PAGE,
            arguments: CommodityDetailPage.setArguments(goodsid));
        getStore().state.openinstall.goodsid = "";
      }
    });
    // _updateSource();
    _sliverListController = ScrollController();
    _gsRefreshController = GSRefreshController(initialRefresh: true);
    _tabController = TabController(length: _promotionList.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (getStore().state.goodsId != null && getStore().state.goodsId > 0) {
        //跳到商品详情页面
        AppRouter.push(context, RouteName.COMMODITY_PAGE,
            arguments:
                CommodityDetailPage.setArguments(getStore().state.goodsId));
        getStore().state.goodsId = 0;
      }
      // _handleOpenInstallEvents();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  _change() {
    return GestureDetector(
      onTap: () {
        _activityMap = null;
        UserManager.instance.isWholesale = !UserManager.instance.isWholesale;
        _gsRefreshController.requestRefresh();
        UserManager.instance.refreshHomeBottomTabbar.value =
            !UserManager.instance.refreshHomeBottomTabbar.value;
        setState(() {});
      },
      child: Column(
        children: [
          15.hb,
          Container(
            height: 27.rw,
            width: 82.rw,
            alignment: Alignment.center,
            child: Stack(
              children: [

                AnimatedPositioned(
                    left: UserManager.instance.isWholesale ? 0.rw : 40.rw,
                    //right: !isWholesale? 0.rw:null,
                    curve: Curves.easeIn,
                    child: Container(
                      height: 25.rw,
                      width: 40.rw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.rw),
                        //border: Border.all(color: Colors.white,width: 1.rw),
                      ),
                    ),
                    duration: Duration(milliseconds: 200)),

                Container(
                  height: 25.rw,
                  width: 80.rw,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16.rw),
                    border: Border.all(color: Colors.white, width: 1.rw),
                  ),
                  child: Stack(
                    children: [
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        _wholesaleState = setState;
                        return Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            10.wb,
                            Text(
                              '批发',
                              style: TextStyle(
                                  color: !UserManager.instance.isWholesale
                                      ? Colors.white
                                      : _backgroundColor,
                                  fontSize: 14.rsp,height: 1.1),
                            ),
                            Spacer(),
                            Text(
                              '零售',
                              style: TextStyle(
                                  color: UserManager.instance.isWholesale
                                      ? Colors.white
                                      : _backgroundColor,
                                  fontSize: 14.rsp,height: 1.1),
                            ),
                            10.wb,
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  // 获取当前页面需要刷新的数据
  _updateSource() {


    _getActiviteList();
    _getBannerList();
    _getPromotionList();
    _getKeyWords();
    Future.delayed(Duration.zero, () async {
      kingCoinListModelList = await UserFunc.getKingCoinList();
      // setState(() {
      //
      // });
    });
  }

  initLocation() {
    _amapFlutterLocation.onLocationChanged().listen(
      (event) {
        _weatherLocation = event;
        LoggerData.addData(_weatherLocation['city']);
        _getWeather();
      },
    );
    _amapFlutterLocation
        .setLocationOption(AMapLocationOption(onceLocation: true));
    _amapFlutterLocation.startLocation();
  }

  @override
  void dispose() {
    _gifController.dispose();
    _tabController.dispose();
    _amapFlutterLocation?.stopLocation();
    _amapFlutterLocation?.destroy();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool _updateTag = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _updateTag = true;
    if (state == AppLifecycleState.resumed) {
      //TODO 修复订单无法下单的问题，该问题只在华为设备中发生，
      //  Set native info: isAppForeground(true)
      // Set native info: isAppForeground(false)
      // 不停的在前后台切换，原因未知
      if (_updateTag) {
        _updateSource();
        _updateTag = false;
      }

      // _handleOpenInstallEvents();
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    super.build(context);

    screenWidth = MediaQuery.of(context).size.width;
    weatherHeight = (76 + ScreenUtil().statusBarHeight);
    bannerHeight = (screenWidth - 20) / 2.34;
    t1Height = (screenWidth - 20) * 0.3429;
    t23Height = ((screenWidth - 28) / 2) * 0.5 + 10;
    t4Height = (screenWidth - 20) * 0.2714;

    return WillPopScope(
        onWillPop: () async {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.normal,
                title: "提示",
                content: "是否要跳转到桌面?",
                items: ["取消", "确认"],
                listener: (index) {
                  switch (index) {
                    case 1:
                      AndroidBackTop.backDeskTop();
                  }
                  Alert.dismiss(context);
                },
              ));

          return false; //一定要return false
        },
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                  // color: _backgroundColor,
                  ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: RefreshWidget(
                //header: HomeGifHeader(),
                isInNest: true,

                color: Colors.black,
                controller: _gsRefreshController,
                onRefresh: () async {
                  _tabController.animateTo(_tabIndex);
                  _updateSource();
                },
                body: _buildBody(context),
              ),
            )
          ],
        )));
  }

  _actionsWidget() {
    return <Widget>[
      _change(),
      // Container(
      //   height: kToolbarHeight,
      //   child: Column(
      //     children: <Widget>[
      //       CustomImageButton(
      //         buttonSize: 40,
      //         padding: EdgeInsets.all(0),
      //         icon: ImageIcon(AssetImage("assets/navigation_msg.png")),
      //         color: getCurrentAppItemColor(),
      //         onPressed: () async {
      //           if (UserManager.instance.haveLogin) {
      //             // MQManager.goToChat(
      //             //     userId: UserManager.instance.user.info.id.toString(),
      //             //     userInfo: <String, String>{
      //             //       "name": UserManager.instance.user.info.nickname ?? "",
      //             //       "gender": UserManager.instance.user.info.gender == 1
      //             //           ? "男"
      //             //           : "女",
      //             //       "mobile": UserManager.instance.user.info.mobile ?? ""
      //             //     });
      //
      //             //跳转到客服页面
      //             WholesaleCustomerModel model = await
      //             WholesaleFunc.getCustomerInfo();
      //
      //             Get.to(()=>WholesaleCustomerPage(model: model,));
      //           } else {
      //             AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
      //             // showError("请先登录!");
      //             Toast.showError("请先登录");
      //           }
      //         },
      //       ),
      //       Spacer(),
      //     ],
      //   ),
      // ),
      // scanCon,
      Container(
        width: 10,
      ),
    ];
  }

  Widget _buildTitle() {
    double iconSize = 18;
    GestureDetector scanCon = GestureDetector(
      onTap: () async {
        if (Platform.isIOS) {
          AppRouter.push(context, RouteName.BARCODE_SCAN);
          //Get.to(QRViewExample());
          return;
        }
        bool permission = await Permission.camera.isGranted;
        if (!permission) {
          Alert.show(
            context,
            NormalContentDialog(
              title: '需要获取相机使用权限',
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Image.asset(R.ASSETS_LOCATION_PER_PNG,width: 44.rw,height: 44.rw,),
                  Text(
                    '允许应用使用相机来扫码识别商品',
                    style:
                        TextStyle(color: Color(0xFF666666), fontSize: 14.rsp),
                  ),
                ],
              ),
              items: ["残忍拒绝"],
              listener: (index) {
                Alert.dismiss(context);
              },
              deleteItem: "立即授权",
              deleteListener: () async {
                Alert.dismiss(context);

                bool canUseCamera = await PermissionTool.haveCameraPermission();
                if (!canUseCamera) {
                  PermissionTool.showOpenPermissionDialog(
                      context, "没有相机使用权限,授予相机使用权限后才能进行扫码");
                  return;
                } else {
                  AppRouter.push(context, RouteName.BARCODE_SCAN);
                  //Get.to(QRViewExample());
                }
              },
              type: NormalTextDialogType.delete,
            ),
          );
        } else {
          AppRouter.push(context, RouteName.BARCODE_SCAN);
        }
      },
      child: Container(
        width: 25.rw,
        height: 25.rw,
        alignment: Alignment.center,
        child: Image.asset(
          "assets/navigation_scan.png",
          fit: BoxFit.cover,
          width: 17.rw,
          height: 17.rw,
        ),
      ),
    );
    GestureDetector ges = GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        // height: rSize(30),
        height: 30,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              width: iconSize * 2.w,
              height: iconSize * 2.w,
              child: Image.asset(
                'assets/home_tab_search.png',
                width: iconSize * 2.w,
                height: iconSize * 2.w,
              ),
            ),
            Container(
              width: 6,
            ),
            Text(
              keyWords,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13 * 2.sp,
                  fontWeight: FontWeight.w300),
            ),
            Spacer(),
            scanCon,
            22.wb,
          ],
        ),
      ),
      onTap: () {
        UserManager.instance.isWholesale?
        Get.to(()=>WholesaleSearchPage()):
        Get.to(
            SearchPage(
          keyWords: keyWords,
        ));
        //AppRouter.push(context, RouteName.SEARCH);
      },
    );
    String locationCityName =
        _weatherLocation != null && !TextUtils.isEmpty(_weatherLocation['city'])
            ? _weatherLocation['city']
            : "";
    try {
      locationCityName = locationCityName.replaceAll("区", "");
      locationCityName = locationCityName.replaceAll("市", "");
    } catch (e) {}
    String cityName =
        _homeWeatherModel != null && !TextUtils.isEmpty(_homeWeatherModel.city)
            ? _homeWeatherModel.city.length > 6
                ? _homeWeatherModel.city.substring(0, 6)
                : _homeWeatherModel.city
            : "";
    Widget leftContainer = GestureDetector(
      onTap: () async {
        if (Platform.isIOS) {
          print(_weatherLocation);
        } else {
          bool permission = await Permission.location.isGranted;
          if (!permission) {
            Alert.show(
              context,
              NormalContentDialog(
                title: '需要获取以下权限',
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      R.ASSETS_LOCATION_PER_PNG,
                      width: 35.rw,
                      height: 35.rw,
                    ),
                    4.wb,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '定位权限',
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 15.rsp,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            width: 200.rw,
                            child: Text(
                              '允许访问您的大概位置来查询城市天气',
                              style: TextStyle(
                                  color: Color(0xFF666666), fontSize: 13.rsp),
                            )),
                      ],
                    )
                  ],
                ),
                items: ["残忍拒绝"],
                listener: (index) {
                  Alert.dismiss(context);
                  HiveStore.appBox.put('locationPermission', false);
                },
                deleteItem: "立即授权",
                deleteListener: () async {
                  Alert.dismiss(context);

                  HiveStore.appBox.put('locationPermission', true);
                  var value = await requestPermission(true);
                  if (value) {
                    initLocation();
                  }
                },
                type: NormalTextDialogType.delete,
              ),
            );
          } else {
            var value = await requestPermission(true);
            if (value) {
              //监听要在设置参数之前 否则无法获取定位
              _amapFlutterLocation
                  .setLocationOption(AMapLocationOption(onceLocation: true));
              _amapFlutterLocation.startLocation();
            }
          }
        }

        String locationCityName = _weatherLocation != null &&
                !TextUtils.isEmpty(_weatherLocation['city'])
            ? _weatherLocation['city']
            : "";
        try {
          locationCityName = locationCityName.replaceAll("区", "");
          locationCityName = locationCityName.replaceAll("市", "");
        } catch (e) {}
        if (locationCityName != '') {
          AppRouter.push(context, RouteName.WEATHER_CITY_PAGE,
                  arguments: WeatherCityPage.setArguments(locationCityName))
              .then((model) {
            if (model is WeatherCityModel) {
              _weatherCityModel = model;
              _getWeather();
            }
          });
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.white, size: 16.rw),
            Container(
              width: 2,
            ),
            Text(
              cityName,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.rsp,
              ),
            ),
            Container(
              width: 5.rw,
            ),
          ],
        ),
      ),
    );
    return Container(
      height: kToolbarHeight,
      color: Colors.transparent,
      // child: ges,
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                leftContainer,
                Expanded(
                  child: ges,
                )
              ],
            ),
            // child: ges,
          ),
          // Spacer()
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      controller: _sliverListController,
      slivers: <Widget>[
        HomeSliverAppBar(
            key: _sliverAppBarGlobalKey,
            actions: _actionsWidget(),
            title: _buildTitle(),
            backgroundColor: AppColor.themeColor,
            expandedHeight: _promotionList == null || _promotionList.length == 0
                ? weatherHeight +
                    bannerHeight +
                    buttonsHeight +
                    t1Height +
                    t23Height +
                (UserManager.instance.isWholesale?50.rw:  t4Height) +
                    rSize(62) +
                    timeHeight +
                    tabbarHeight -
                    ScreenUtil().statusBarHeight -
                    4
                : weatherHeight +
                    bannerHeight +
                    buttonsHeight +
                    t1Height +
                    t23Height +
                (UserManager.instance.isWholesale?50.rw:  t4Height) +
                    rSize(62) +
                    timeHeight +
                    tabbarHeight -
                    ScreenUtil().statusBarHeight +
                    4,
            flexibleSpace: _flexibleSpaceBar(context),
            bottom: _promotionList == null || _promotionList.length == 0
                ? PreferredSize(
                    child: Container(), preferredSize: Size.fromHeight(1))
                // : PreferredSize(preferredSize: Size.fromHeight(40),
                : PreferredSize(
                    preferredSize: Size.fromHeight(tabbarHeight),
                    child: Container(
                      alignment: Alignment.center,
                      color: AppColor.frenchColor,
                      child: HomePageTabbar(
                        promotionList: _promotionList,
                        timerJump: (index) {
                          _tabIndex = index;
                          _homeCountdownController.indexChange(index);
                          // 定时任务回调
                          _tabController.animateTo(index);
                          _getPromotionGoodsList(_promotionList[index].id);
                        },
                        clickItem: (index) {
                          _homeCountdownController.indexChange(index);
                          _getPromotionGoodsList(_promotionList[index].id);
                        },
                        tabController: _tabController,
                      ),
                    ),
                  )),
        UserManager.instance.isWholesale?SliverToBoxAdapter(
          child: Container(
            height: 0.rw,
          ),
        ): SliverList(
          delegate: SliverChildListDelegate(

            List.generate(
                _promotionList == null || _promotionList.length == 0
                    ? 0
                    : _promotionGoodsList.length + 1, (index) {
              if (index == _promotionGoodsList.length) {
                return Container(
                  color: AppColor.frenchColor,
                  alignment: Alignment.center,
                  height: 60,
                  child: Text(
                    '已经到底啦~',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 13 * 2.sp),
                  ),
                );
              }
              if (_promotionGoodsList[index] is PromotionGoodsModel) {
                PromotionGoodsModel model = _promotionGoodsList[index];
                return Container(
                  padding: EdgeInsets.only(bottom: 5),
                  color: AppColor.frenchColor,
                    child: GoodsItemWidget.rowGoods(
                    gifController: _gifController,
                    buildCtx: context,
                    isSingleDayGoods: false,
                    onBrandClick: () {
                      AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                          arguments: BrandGoodsListPage.setArguments(
                              model.brandId, model.brandName));
                    },
                    model: model,
                    buyClick: () {
                      AppRouter.push(context, RouteName.COMMODITY_PAGE,
                          arguments:
                              CommodityDetailPage.setArguments(model.goodsId));
                    },
                  ),
                );
              } else if (_promotionGoodsList[index] is PromotionActivityModel) {
                PromotionActivityModel activityModel =
                    _promotionGoodsList[index];
                return RowActivityItem(
                  model: activityModel,
                  click: () {
                    AppRouter.push(
                      context,
                      RouteName.WEB_VIEW_PAGE,
                      arguments: WebViewPage.setArguments(
                          url: activityModel.activityUrl,
                          title: "活动",
                          hideBar: true),
                    );
                  },
                );
              } else {
                return Container();
              }
            }),


          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            List.generate(
                _promotionList == null || _promotionList.length == 0
                    ? 0
                    : _promotionGoodsList.length, (index) {
              if (_promotionGoodsList[index] is PromotionActivityModel) {
                PromotionActivityModel activityModel =
                    _promotionGoodsList[index];
                return RowActivityItem(
                  model: activityModel,
                  click: () {
                    AppRouter.push(
                      context,
                      RouteName.WEB_VIEW_PAGE,
                      arguments: WebViewPage.setArguments(
                          url: activityModel.activityUrl,
                          title: "活动",
                          hideBar: true),
                    );
                  },
                );
              } else {
                return Container();
              }
            }),
          ),
        ),

         _promotionList.isEmpty||!UserManager.instance.isWholesale
    ? SliverToBoxAdapter(
                child: Container(
                  height: 0.rw,
                ),
              )
            : SliverWaterfallFlow(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (_promotionGoodsList[index] is PromotionGoodsModel) {
                      PromotionGoodsModel model = _promotionGoodsList[index];
                      return MaterialButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Get.to(()=>WholesaleDetailPage(goodsId:model.goodsId,));

                          },
                          child: WholesaleGoodsGrid(
                              goods: WholesaleGood(
                            id: model.goodsId,
                            goodsName: model.goodsName,
                            mainPhotoUrl: model.picture.url,
                            description: model.description,
                            discountPrice: model.price,
                            salePrice: model.salePrice,
                            salesVolume: model.totalSalesVolume,
                          )));
                    } else if (index == _promotionGoodsList.length-1) {
                      return Container(
                        color: AppColor.frenchColor,
                        alignment: Alignment.center,
                        height: 60,
                        child: Text(
                          '已经到底啦~',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 13 * 2.sp),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                  childCount: _promotionGoodsList.length ,
                ),
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                // ItemTagWidget.getSliverGridDelegate(_displayList, context),
              ),

        UserManager.instance.isWholesale?    SliverToBoxAdapter(
          child: Container(
            color: AppColor.frenchColor,
            alignment: Alignment.center,
            height: 60,
            child: Text(
              '已经到底啦~',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 13 * 2.sp),
            ),
          )
        ):SliverToBoxAdapter(
          child: Container(
            height: 0.rw,
          ),
        )
      ],
    );
  }

  FlexibleSpaceBar _flexibleSpaceBar(context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Container(
          //头部整个背景颜色
          height: double.infinity,
          color: AppColor.frenchColor,
          // color: Colors.white,
          child: Stack(
            children: <Widget>[
              AnimatedHomeBackground(
                key: _animatedBackgroundState,
                height: weatherHeight + bannerHeight - 32,
                backgroundColor:
                    _backgroundColor == null ? Colors.white : _backgroundColor,
              ),
              Column(
                children: <Widget>[
                  HomeWeatherWidget(
                    backgroundColor: Colors.white.withAlpha(0),
                    homeWeatherModel: _homeWeatherModel,
                  ),
                  _bannerView(),
                  _buildGoodsCards(),
                  kingCoinListModelList != null
                      ? _buttonTitle(context)
                      : SizedBox(),
                  _activityImageTitle(),
                  UserManager.instance.isWholesale
                      ? _activityImage234()
                      : SizedBox(),
                  UserManager.instance.isWholesale
                      ? SizedBox()
                      : _activityImageRow(),
                  UserManager.instance.isWholesale
                      ? SizedBox()
                      : _activityT4Image(),
                  HomeCountdownWidget(
                    height: timeHeight,
                    controller: _homeCountdownController,
                    promotionList: _promotionList,
                  ),
                ],
              ),
            ],
          )),
    );
  }

  _bannerView() {
    if (_backgroundColor == null &&
        _bannerList != null &&
        _bannerList.length > 0) {
      BannerModel bannerModel = _bannerList[0];
      if (!TextUtils.isEmpty(bannerModel.color)) {
        Color color = ColorsUtil.hexToColor(bannerModel.color);
        _backgroundColor = color;

        _wholesaleState(() {});
        _animatedBackgroundState.currentState.changeColor(color);
        _sliverAppBarGlobalKey.currentState.updateColor(color);
      }
    }
    Widget banner =
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      _bannerState = setState;
      if (_bannerList == null || _bannerList.length == 0) {
        return Container(
          height: bannerHeight,
        );
      }
      BannerListView bannerListView = BannerListView<BannerModel>(
        onPageChanged: (index) {
          int realIndex = index;
          if (realIndex < 0) return;
          if (realIndex >= _bannerList.length) realIndex = 0;
          BannerModel bannerModel = _bannerList[realIndex];
          if (!TextUtils.isEmpty(bannerModel.color)) {
            Color color = ColorsUtil.hexToColor(bannerModel.color);
            _backgroundColor = color;

            _wholesaleState(() {});
            _animatedBackgroundState.currentState.changeColor(color);
            _sliverAppBarGlobalKey.currentState.updateColor(color);
          }
        },
        height: bannerHeight,
        margin: EdgeInsets.symmetric(horizontal: 10),
        radius: 10,
        data: _bannerList,
        builder: (context, bannerModel) {
          return GestureDetector(
            onTap: () {
              if (!TextUtils.isEmpty(
                  (bannerModel as BannerModel).activityUrl)) {
                AppRouter.push(
                  context,
                  RouteName.WEB_VIEW_PAGE,
                  arguments: WebViewPage.setArguments(
                      url: (bannerModel as BannerModel).activityUrl,
                      title: "活动",
                      hideBar: true),
                );
              } else {
                if(UserManager.instance.isWholesale){
                  Get.to(()=>WholesaleDetailPage(goodsId: (bannerModel as BannerModel).goodsId,));
                }

                else{
                  AppRouter.push(context, RouteName.COMMODITY_PAGE,
                      arguments: CommodityDetailPage.setArguments(
                          (bannerModel as BannerModel).goodsId));
                }

              }
            },
            child:
            FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
              image:  Api.getImgUrl(bannerModel.url),
              fit: BoxFit.fill,
            ),
            // child: ExtendedImage.network(Api.getImgUrl(bannerModel.url),
            //     fit: BoxFit.fill, enableLoadState: true),
          );
        },
      );
      return bannerListView;
    });
    return Container(
      width: screenWidth,
      height: bannerHeight,
      color: Colors.white.withAlpha(0),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: _bannerList == null ? Container() : banner,
          )
        ],
      ),
    );
  }

  _activityImageTitle() {
    HomeAcitvityItem item;
    if (_activityMap != null && _activityMap.containsKey('a')) {
      item = _activityMap['a'];
    }
    return GestureDetector(
      onTap: () {
        if (item != null && !TextUtils.isEmpty(item.website)) {
          AppRouter.push(
            context,
            RouteName.WEB_VIEW_PAGE,
            arguments: WebViewPage.setArguments(
                url: item.website, title: "活动", hideBar: true),
          );
        }
      },
      child: Container(
        color: AppColor.frenchColor,
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: ClipRRect(
          child: _activityMap != null && _activityMap.containsKey('a')
              ?
          FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
              image:  Api.getImgUrl(item.logoUrl),
            fit: BoxFit.fill,
            )
          //
          // ExtendedImage.network(
          //         Api.getImgUrl(item.logoUrl),
          //         fit: BoxFit.fill,
          //         enableLoadState: true,
          //       )
              // CustomCacheImage(imageUrl: Api.getImgUrl(item.logoUrl),fit: BoxFit.fill, height: rSize(300),width: MediaQuery.of(context).size.width,)
              : Image.asset(R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,fit: BoxFit.fitWidth,),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        height: t1Height,
        width: screenWidth,
      ),
    );
  }

  _activityT4Image() {
    HomeAcitvityItem itemD;
    if (_activityMap != null && _activityMap.containsKey('d')) {
      itemD = _activityMap['d'];
    }
    Container con = Container(
      width: screenWidth,
      height: t4Height,
      color: AppColor.frenchColor,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        child: _activityMap != null && _activityMap.containsKey('d')
            ?
        // ExtendedImage.network(
        //         Api.getImgUrl(itemD.logoUrl),
        //         fit: BoxFit.fill,
        //         enableLoadState: true,
        //       )
        FadeInImage.assetNetwork(
          placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
          image:  Api.getImgUrl(itemD.logoUrl),
          fit: BoxFit.fill,
        )
            : Image.asset(R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,fit: BoxFit.fitWidth,),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
    return GestureDetector(
      onTap: () {
        if (itemD != null && !TextUtils.isEmpty(itemD.website)) {
          AppRouter.push(
            context,
            RouteName.WEB_VIEW_PAGE,
            arguments: WebViewPage.setArguments(
                url: itemD.website, title: "活动", hideBar: true),
          );
        }
      },
      child: con,
    );
  }

  _activityImageRow() {
    HomeAcitvityItem itemB, itemC;
    if (_activityMap != null && _activityMap.containsKey('b')) {
      itemB = _activityMap['b'];
    }
    if (_activityMap != null && _activityMap.containsKey('c')) {
      itemC = _activityMap['c'];
    }
    return Container(
      color: AppColor.frenchColor,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: t23Height,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (itemB != null && !TextUtils.isEmpty(itemB.website)) {
                        AppRouter.push(
                          context,
                          RouteName.WEB_VIEW_PAGE,
                          arguments: WebViewPage.setArguments(
                              url: itemB.website, title: "活动", hideBar: true),
                        );
                      }
                    },
                    child: Container(
                      child: ClipRRect(
                        child: _activityMap != null &&
                                _activityMap.containsKey('b')
                            ?
                        // ExtendedImage.network(
                        //         Api.getImgUrl(itemB.logoUrl),
                        //         fit: BoxFit.fill,
                        //         enableLoadState: true)
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
                          image:  Api.getImgUrl(itemB.logoUrl),
                          fit: BoxFit.fill,
                        )
                            // CustomCacheImage(imageUrl: Api.getImgUrl(itemB.logoUrl),fit: BoxFit.fill,)
                            : Image.asset(R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,fit: BoxFit.fitWidth,),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      height: t23Height,
                      // width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                Container(
                  width: 8,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (itemC != null && !TextUtils.isEmpty(itemC.website)) {
                        AppRouter.push(
                          context,
                          RouteName.WEB_VIEW_PAGE,
                          arguments: WebViewPage.setArguments(
                              url: itemC.website, title: "活动", hideBar: true),
                        );
                      }
                    },
                    child: Container(
                      child: ClipRRect(
                        child: _activityMap != null &&
                                _activityMap.containsKey('c')
                            ?
                        // ExtendedImage.network(
                        //         Api.getImgUrl(itemC.logoUrl),
                        //         fit: BoxFit.fill,
                        //         enableLoadState: true)
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
                          image:  Api.getImgUrl(itemC.logoUrl),
                          fit: BoxFit.fill,
                        )
                            // CustomCacheImage(imageUrl: Api.getImgUrl(itemC.logoUrl),fit: BoxFit.fill,)
                            : Image.asset(R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,fit: BoxFit.fitWidth,),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      height: t23Height,
                      // width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _activityImage234() {
    HomeAcitvityItem itemB, itemC, itemD;
    if (_activityMap != null && _activityMap.containsKey('b')) {
      itemB = _activityMap['b'];
    }
    if (_activityMap != null && _activityMap.containsKey('c')) {
      itemC = _activityMap['c'];
    }
    if (_activityMap != null && _activityMap.containsKey('d')) {
      itemD = _activityMap['d'];
    }
    return Container(
      color: AppColor.frenchColor,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: t23Height +50.rw,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (itemB != null && !TextUtils.isEmpty(itemB.website)) {
                        AppRouter.push(
                          context,
                          RouteName.WEB_VIEW_PAGE,
                          arguments: WebViewPage.setArguments(
                              url: itemB.website, title: "活动", hideBar: true),
                        );
                      }
                    },
                    child: Container(
                      child: ClipRRect(
                        child: _activityMap != null &&
                                _activityMap.containsKey('b')
                            ?
                        // ExtendedImage.network(
                        //         Api.getImgUrl(itemB.logoUrl),
                        //         fit: BoxFit.fill,
                        //         enableLoadState: true)
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          image:  Api.getImgUrl(itemB.logoUrl),
                          fit: BoxFit.fill,
                        )
                            // CustomCacheImage(imageUrl: Api.getImgUrl(itemB.logoUrl),fit: BoxFit.fill,)
                            : Image.asset(R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,fit: BoxFit.fill,),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      height: t23Height + 50.rw,
                      // width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.wb,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (itemB != null && !TextUtils.isEmpty(itemB.website)) {
                        AppRouter.push(
                          context,
                          RouteName.WEB_VIEW_PAGE,
                          arguments: WebViewPage.setArguments(
                              url: itemB.website, title: "活动", hideBar: true),
                        );
                      }
                    },
                    child: Container(

                      child: ClipRRect(
                        child: _activityMap != null &&
                                _activityMap.containsKey('c')
                            ?
                        // ExtendedImage.network(
                        //         Api.getImgUrl(itemB.logoUrl),
                        //         fit: BoxFit.fill,
                        //         enableLoadState: true)
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,

                          image:  Api.getImgUrl(itemC.logoUrl),
                          fit: BoxFit.fill,
                        )
                            // CustomCacheImage(imageUrl: Api.getImgUrl(itemB.logoUrl),fit: BoxFit.fill,)
                            :Image.asset(R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,fit: BoxFit.fitWidth,width: double.infinity,),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      height: t23Height,
                      // width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                8.hb,
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (itemC != null && !TextUtils.isEmpty(itemC.website)) {
                        AppRouter.push(
                          context,
                          RouteName.WEB_VIEW_PAGE,
                          arguments: WebViewPage.setArguments(
                              url: itemC.website, title: "活动", hideBar: true),
                        );
                      }
                    },
                    child: Container(
                      child: ClipRRect(
                        child: _activityMap != null &&
                                _activityMap.containsKey('d')
                            ?
                        // ExtendedImage.network(
                        //         Api.getImgUrl(itemC.logoUrl),
                        //         fit: BoxFit.fill,
                        //         enableLoadState: true)
                        FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,
                          image:  Api.getImgUrl(itemD.logoUrl),
                          fit: BoxFit.fill,
                        )
                            // CustomCacheImage(imageUrl: Api.getImgUrl(itemC.logoUrl),fit: BoxFit.fill,)
                            : Image.asset(R.ASSETS_PLACEHOLDER_NEW_2X1_A_PNG,fit: BoxFit.fitWidth,width: double.infinity,),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      height: t23Height,
                      // width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buttonTitle(context) {
    Container titles = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buttonTitleRow(
                      kingCoinListModelList[0],
                    ),
                    _buttonTitleRow(
                      kingCoinListModelList[1],
                    ),
                    _buttonTitleRow(
                      kingCoinListModelList[2],
                    ),
                    _buttonTitleRow(
                      kingCoinListModelList[3],
                    ),
                    _buttonTitleRow(
                      kingCoinListModelList[4],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      color: AppColor.frenchColor,
      height: buttonsHeight,
      width: MediaQuery.of(context).size.width,
      child: titles,
    );
  }

  _buttonTitleRow(
    KingCoinListModel kingCoin,
  ) {
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Column(
          children: <Widget>[
            Container(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                width: 48,
                height: 48,
                child: FadeInImage.assetNetwork(
                  placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  image: Api.getImgUrl(kingCoin.data.first.url),
                )),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                kingCoin.data.first.name,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12 * 2.sp,
                    color: Colors.black.withOpacity(0.8)),
              ),
            )
          ],
        ),
        onPressed: () {
          _kingCoinGet(kingCoin.data.first.kingName.name);
        },
      ),
    );
  }

  _kingCoinGet(String name) async {
    switch (name) {
      case '京东优选':
        List<FirstCategory> firstCategoryList = [];
        firstCategoryList = await HomeDao.getJDCategoryList();
        if (firstCategoryList != null) {
          Get.to(() => ClassifyPage(
                jdType: 1,
                data: firstCategoryList,
                initValue: '全部',
              ));
        }
        break;
      case '一键邀请':
        if (!UserManager.instance.haveLogin) {
          AppRouter.push(context, RouteName.LOGIN);
          return;
        }

        ShareTool().inviteShare(context, customTitle: Container());
        break;
      case '热销榜单':
        AppRouter.push(context, RouteName.GOODS_HOT_LIST);
        break;
      case '进口专区':
        List<CountryListModel> countryListModelList;
        countryListModelList = await HomeDao.getCountryList();
        Get.to(ClassifyCountryPage(data: countryListModelList));
        break;
      case '特惠专区':
        Get.to(() => GoodsPreferentialListPage());
        break;
      case '硬核补贴':
        if (!UserManager.instance.haveLogin) {
          ReToast.err(text: '请先登录');
          AppRouter.push(context, RouteName.LOGIN);
          return;
        }
        Get.to(() => VipShopCardPage(
              goToBottom: false,
            ));
        //Get.to(() => GoodsHighCommissionListPage());
        break;
      case '学院':
        UserManager.instance.selectTabbarIndex = 1;
        bool value = UserManager.instance.selectTabbar.value;
        UserManager.instance.selectTabbar.value = !value;
        break;
      case '家居生活':
        AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
            arguments: GoodsListTempPage.setArguments(
                title: "家居生活", type: GoodsListTempType.homeLife));
        break;
      case '数码家电':
        AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
            arguments: GoodsListTempPage.setArguments(
                title: "数码家电", type: GoodsListTempType.homeAppliances));
        break;
      case '日用百货':
        break;
      case '酒饮冲调':
        break;
      case '休闲美食':
        break;
      case '茶米油盐':
        break;
      case '个护清洁':
        break;
      case '家用电器':
        break;
      case '母婴用品':
        break;
      case '美妆护肤':
        break;
      case '全部分类':
        break;
      case '批发商城':

        Get.to(() => WholesaleHomePage());
        break;
        final loadingCancel = ReToast.loading();
        await HomeDao.getCategories(success: (data, code, msg) {
          loadingCancel();
          CRoute.push(
              context,
              ClassifyPage(
                data: data,
                initValue: name,
              ));
        }, failure: (code, msg) {
          Toast.showError(msg);
        });

        break;
    }
  }

  ///首页上方分类功能卡片
  _buildGoodsCards() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: rSize(62),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(left: rSize(10)),
              scrollDirection: Axis.horizontal,
              children: [
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_RICE_PNG, '柴米油盐'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_CLEAN_PNG, '个护清洁'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_DEPARTMENT_PNG, '日用百货'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_WINE_PNG, '酒饮冲调'),
                //_buildSingleGoodsCard(R.ASSETS_HOME_IC_IMPORT_PNG, '进口专区'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_TEA_PNG, '休闲美食'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_FOOD_PNG, '有机食品'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_VEGETABLES_PNG, '蔬果生鲜'),

                _buildSingleGoodsCard(R.ASSETS_HOME_IC_ELECTRICITY_PNG, '家用电器'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_PHONE_PNG, '手机数码'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_BABY_PNG, '母婴用品'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_SPORT_PNG, '运动旅行'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_MEDICALBOX_PNG, '医疗保健'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_HAIR_PNG, '美妆护肤'),

                _buildSingleGoodsCard(R.ASSETS_HOME_IC_BOOK_PNG, '图文教育'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_FURNITURE_PNG, '家具饰品'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_CLOTHES_PNG, '服饰内衣'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_BAG_PNG, '鞋靴箱包'),
                //_buildSingleGoodsCard(R.ASSETS_HOME_IC_MEMBERS_PNG, '会员专享'), 9.23优化更新隐藏
              ],
            ),
          ),
          Container(
            height: rSize(62),
            decoration: BoxDecoration(
              color: AppColor.frenchColor,
              boxShadow: [
                //使用多层阴影的方式实现单边boxShadow
                /// more at [stackoverflow](https://stackoverflow.com/a/65296931/7963151)
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(-5, 0),
                ),
                // BoxShadow(color: AppColor.frenchColor, offset: Offset(0, -16)),
                BoxShadow(color: AppColor.frenchColor, offset: Offset(0, 16)),
                BoxShadow(color: AppColor.frenchColor, offset: Offset(16, 0)),
              ],
            ),
            child: _buildSingleGoodsCard(
                R.ASSETS_HOME_IC_CLASSIFICATION_PNG, '分类'),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleGoodsCard(String path, String name) {
    return MaterialButton(
      minWidth: rSize(54),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () async {
        final loadingCancel = ReToast.loading();
        await HomeDao.getCategories(success: (data, code, msg) {
          loadingCancel();
          CRoute.push(
              context,
              ClassifyPage(
                data: data,
                initValue: name,
              ));
        }, failure: (code, msg) {
          Toast.showError(msg);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            path,
            height: rSize(28),
            width: rSize(28),
          ),
          Text(
            name,
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: rSize(10),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _getKeyWords() async {
    ResultData resultData =
        await HttpManager.post(APIV2.userAPI.getKeyWords, {});
    if (resultData.data != null) {
      if (resultData.data['data'] != null) {
        setState(() {
          keyWords = resultData.data['data'];
        });
      }
      return;
    }
    // BannerListModel model = BannerListModel.fromJson(resultData.data);
    // if (model.code != HttpStatus.SUCCESS) {
    //   showError(model.msg);
    //   return;
    // }
    // _bannerState(() {
    //   _bannerList = model.data;
    // });
  }

  _getBannerList() async {
    ResultData resultData = await HttpManager.post(HomeApi.banner_list, {
      "is_sale": UserManager.instance.isWholesale,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BannerListModel model = BannerListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _bannerState(() {
      _bannerList = model.data;
    });
  }

  _getActiviteList() async {

    ResultData resultData = await HttpManager.post(HomeApi.activity_list, {
      "is_sale": UserManager.instance.isWholesale,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    BaseModel model = BaseModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    if (resultData.data['data'] != null) {
      setState(() {
        HashMap map = HashMap.from(resultData.data['data']);
        Map itemMap = {};
        itemMap.addAll(
            {'a': HomeAcitvityItem(map['a']['logoUrl'], map['a']['website'])});
        itemMap.addAll(
            {'b': HomeAcitvityItem(map['b']['logoUrl'], map['b']['website'])});
        itemMap.addAll(
            {'c': HomeAcitvityItem(map['c']['logoUrl'], map['c']['website'])});
        itemMap.addAll(
            {'d': HomeAcitvityItem(map['d']['logoUrl'], map['d']['website'])});
        _activityMap = itemMap;
      });
    }
  }

  _getPromotionList() async {
    ResultData resultData = await HttpManager.post(HomeApi.promotion_list, {
      "is_sale": UserManager.instance.isWholesale,
    });

    if (_gsRefreshController.isRefresh()) {
      // Future.delayed(Duration(milliseconds: 1500), () {
      _gsRefreshController.refreshCompleted();
      _gsRefreshController.loadNoData();
      // });
    }

    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    PromotionListModel model = PromotionListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    _promotionList = model.data;
    setState(() {});
    if (_promotionList == null || _promotionList.length == 0) {
      _promotionGoodsList = [];
      setState(() {});
      return;
    }
    int _index = 0;
    for (Promotion item in _promotionList) {
      PromotionStatus processStatus = PromotionTimeTool.getPromotionStatus(
          item.startTime, item.getTrueEndTime());
      // DateTime time = DateTime.parse("2020-03-18 23:00:00");
      DateTime time = DateTime.now();
      if (time.hour >= 22 &&
          DateTime.parse(item.startTime).hour == 20 &&
          time.day == DateTime.parse(item.startTime).day) {
        //10点以后定位到8点
        _index = _promotionList.indexOf(item);
      } else if (processStatus == PromotionStatus.start) {
        _index = _promotionList.indexOf(item);
      }
    }
    _homeCountdownController.indexChange(_index);
    _tabController = TabController(
        vsync: this, length: _promotionList.length, initialIndex: _index);
    _tabIndex = _index;
    _getPromotionGoodsList(_promotionList[_index].id);
  }

  _getPromotionGoodsList(int promotionId) async {
    ResultData resultData =
        await HttpManager.post(HomeApi.promotion_goods_list, {
      "timeItemID": promotionId,
      'user_id': UserManager.instance.user.info.id,
          "is_sale": UserManager.instance.isWholesale,
    });
    if (!resultData.result) {
      showError(resultData.msg);
      return;
    }
    PromotionGoodsListModel model =
        PromotionGoodsListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg);
      return;
    }
    List array = [];
    if (model.data.goodsList == null) {
      model.data.goodsList = [];
    } else {
      array.addAll(model.data.goodsList);
    }
    if (model.data.activityList != null && model.data.activityList.length > 0) {
      if (model.data.activityList.first.activitySortId != 0) {
        if (array.length >= model.data.activityList.first.activitySortId) {
          array.insert(model.data.activityList.first.activitySortId - 1,
              model.data.activityList.first);
        } else {
          array.add(model.data.activityList.first);
        }
      } else {
        if (array.length > 3) {
          array.insert(3, model.data.activityList.first);
        } else {
          array.add(model.data.activityList.first);
        }
      }
    }
    _promotionGoodsList = array;
    if (mounted) {
      setState(() {
        double height = weatherHeight +
            bannerHeight +
            buttonsHeight +
            t1Height +
            t23Height +
            t4Height +
            timeHeight +
            tabbarHeight -
            ScreenUtil().statusBarHeight -
            tabbarHeight -
            kToolbarHeight;
        double offset = _sliverListController.offset;
        if (offset > height) {
          _sliverListController.animateTo(height,
              duration: Duration(milliseconds: 300), curve: Curves.linear);
        }
      });
    }
  }

  _getWeather() async {
    // if (_weatherLocation==null)
    //cityid、city和ip参数3选一提交，如果不传，默认返回当前ip城市天气，cityid优先级最高。
    String url =
        "https://v0.yiketianqi.com/api?version=v61&appid=81622428&appsecret=AxKzYWq3";
    if (_weatherCityModel != null && !TextUtils.isEmpty(_weatherCityModel.id)) {
      url = "$url&cityid=${_weatherCityModel.id}";
    } else if (_weatherCityModel != null &&
        !TextUtils.isEmpty(_weatherCityModel.cityZh)) {
      url = "$url&city=${_weatherCityModel.cityZh}";
    } else if (_weatherLocation != null &&
        !TextUtils.isEmpty(_weatherLocation['city'])) {
      // url = "$url&point=gaode&lng=${_weatherLocation.latLng.longitude.toString()}&lat=${_weatherLocation.latLng.latitude.toString()}";
      String city = (_weatherLocation['city'] as String).replaceAll("区", "");
      city = city.replaceAll("市", "");
      url = "$url&city=$city";
    }
    Response res = await HttpManager.netFetchNormal(url, null, null, null);
    if (res == null) {
      return;
    }
    LoggerData.addData(res);
    Map map = json.decode(res.data.toString());
    _homeWeatherModel = HomeWeatherModel.fromJson(map);
    UserManager.instance.homeWeatherModel = _homeWeatherModel;
    if (mounted) setState(() {});
  }

  // _mobShareInit() {
  //   ShareSDKRegister register = ShareSDKRegister();
  //   // register.setupSinaWeibo(
  //   //     "3484799074", "0cc08d31b4d63dc81fbb7a2559999fb3", "https://reecook.cn");
  //   register.setupQQ("101876843", "6f367bfad98978e22c2e11897dd74f00");
  //   SharesdkPlugin.regist(register);
  // }

  Future<bool> requestPermission(bool btn) async {
    if (Platform.isIOS) {
      return true;
    }
    bool permission = await Permission.location.isGranted;
    if (permission) {
      HiveStore.appBox.put('location', true);
    }
    print('${HiveStore.appBox.get('location')}');
    if (HiveStore.appBox.get('location') == null) {
      // bool permission = await Permission.locationWhenInUse.isRestricted;
      // bool permanentDenied =
      // await Permission.locationWhenInUse.isDenied;

      if (!permission) {
        await Permission.location.request();
        bool permanentDenied = await Permission.location.isGranted;
        if (permanentDenied) {
          //await PermissionTool.showOpenPermissionDialog(context, '打开定位权限');
          HiveStore.appBox.put('location', true);
        } else {
          HiveStore.appBox.put('location', false);
        }
        permission = await Permission.location.isGranted;
      }
      return permission;
    } else {
      if (HiveStore.appBox.get('location')) {
        return true;
      } else {
        if (btn) {
          await PermissionTool.showOpenPermissionDialog(
              context, '如果您想要改变您的定位，请先打开定位权限。');
        }
        return false;
      }
    }
  }
}
