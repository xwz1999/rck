/*
 * ====================================================
 * package   : pages.home
 * author    : Created by nansi.
 * time      : 2019/5/5  4:36 PM 
 * remark    : 
 * ====================================================
 */

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response;
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:power_logger/power_logger.dart';
import 'package:recook/models/category_model.dart';
import 'package:recook/models/country_list_model.dart';
import 'package:recook/pages/buy_tickets/choose_tickets_type_page.dart';
import 'package:recook/pages/home/widget/good_high_commission_page.dart';
import 'package:recook/pages/home/widget/good_preferential_list_page.dart';
import 'package:recook/pages/home/widget/goods_hot_list_page.dart';
import 'package:recook/pages/live/models/king_coin_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:recook/utils/storage/hive_store.dart';
import 'package:sharesdk_plugin/sharesdk_plugin.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/daos/home_dao.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/meiqia_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/banner_list_model.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/home_weather_model.dart';
import 'package:recook/models/promotion_goods_list_model.dart';
import 'package:recook/models/promotion_list_model.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/home/classify/classify_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/home_page_tabbar.dart';
import 'package:recook/pages/home/items/item_row_acitivity.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/pages/home/widget/animated_home_background.dart';
import 'package:recook/pages/home/widget/goods_list_temp_page.dart';
import 'package:recook/pages/home/widget/home_countdown_widget.dart';
import 'package:recook/pages/home/widget/home_sliver_app_bar.dart';
import 'package:recook/pages/home/widget/home_weather_view.dart';
import 'package:recook/pages/live/live_stream/live_stream_view_page.dart';
import 'package:recook/pages/noticeList/notice_list_model.dart';
import 'package:recook/pages/noticeList/notice_list_tool.dart';
import 'package:recook/pages/tabBar/rui_code_listener.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_page_v2.dart';
import 'package:recook/third_party/wechat/wechat_utils.dart';
import 'package:recook/utils/android_back_desktop.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/color_util.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/banner.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/goods_item.dart';
import 'package:recook/widgets/home_gif_header.dart';
import 'package:recook/widgets/progress/re_toast.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/toast.dart';
import 'package:recook/widgets/weather_page/weather_city_model.dart';
import 'package:recook/widgets/weather_page/weather_city_page.dart';
import 'package:recook/widgets/webView.dart';
import '../../utils/text_utils.dart';
import 'classify/classify_country_page.dart';

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
  bool _displayExtraFunction = false;

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
  double buttonsHeight = 100;
  double t1Height = 0;
  double t23Height = 0;
  double t4Height = 0;
  double timeHeight = 60;
  double tabbarHeight = 48;
  HomeCountdownController _homeCountdownController;
  Color _backgroundColor;
  StateSetter _bannerState;
  GlobalKey<AnimatedHomeBackgroundState> _animatedBackgroundState = GlobalKey();
  GlobalKey<HomeSliverAppBarState> _sliverAppBarGlobalKey = GlobalKey();

  GifController _gifController;
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

  _openInstallGoodsIdListener() {
    _handleOpenInstallEvents();
  }

  ///监听剪切板

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );
    bool notificationPermission = HiveStore.appBox.get('notification') ?? false;
    if (!notificationPermission) {
      JPush().isNotificationEnabled().then((bool value) {
        if (!value) {
          HiveStore.appBox.put('notification', true);
          PermissionTool.showOpenPermissionDialog(
              context, "我们为您准备了精彩的内容推荐，试试看吧！");
        }
      }).catchError((onError) {
        print(onError);
      });
    }

    kingCoinListModelList = UserManager.instance.kingCoinListModelList;
    //已在native配置
    // AMapFlutterLocation.setApiKey(
    //     '7225bca14fe7493f9f469315a933f99c', 'e8a8057cfedcdcadcf4e8f2c7f8de982');
    _amapFlutterLocation = AMapFlutterLocation();

    requestPermission().then((value) {
      if (value) {
        //监听要在设置参数之前 否则无法获取定位
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
      } else {
        //ReToast.err(text: '未获取到定位权限，请先在设置中打开定位权限');
      }
    });

    // 分享注册
    _mobShareInit();
    // 判断微信是否登录
    WeChatUtils.initial();
    // meiqia注册
    MQManager.initial();
    ShareTool.init();
    // _backgroundColor = AppColor.themeColor;
    _homeCountdownController = HomeCountdownController();

    UserManager.instance.openInstallGoodsId
        .addListener(_openInstallGoodsIdListener);

    UserManager.instance.openInstallLive.addListener(() {
      if (getStore().state.openinstall.type == 'live') {
        CRoute.push(
            context,
            LiveStreamViewPage(
                id: int.parse(getStore().state.openinstall.itemId)));
      }
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
    _updateSource();
    _sliverListController = ScrollController();
    _gsRefreshController = GSRefreshController();
    _tabController = TabController(length: _promotionList.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (getStore().state.goodsId != null && getStore().state.goodsId > 0) {
        //跳到商品详情页面
        AppRouter.push(context, RouteName.COMMODITY_PAGE,
            arguments:
                CommodityDetailPage.setArguments(getStore().state.goodsId));
        getStore().state.goodsId = 0;
      }
      _handleOpenInstallEvents();
      //  Alert.show(
      //    context,
      //    NormalTextDialog(
      //      type: NormalTextDialogType.delete,
      //      title: "提示",
      //      content: "同意隐私协议",
      //      items: ["确认"],
      //      listener: (index) {
      //        SharesdkPlugin.uploadPrivacyPermissionStatus(1, (bool success) {
      //          if(success == true) {
      //            showSuccess("隐私协议授权提交成功");
      //          } else {
      //            showError("隐私协议授权提交失败");
      //          }
      //        });
      //      },
      //      deleteItem: "取消",
      //      deleteListener: () {
      //        Alert.dismiss(context);
      //      },
      //    ));
    });
    WidgetsBinding.instance.addObserver(this);
    // 抽奖功能
    _userLottery();
    _getNoticeList();
    _userCardNoticeList();
  }

  // 获取当前页面需要刷新的数据
  _updateSource() {
    _getActiviteList();
    _getBannerList();
    _getPromotionList();
  }

  _handleOpenInstallEvents() {
    if (!TextUtils.isEmpty(getStore().state.openinstall.goodsid)) {
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
                header: HomeGifHeader(),
                isInNest: true,
                headerTriggerDistance: ScreenUtil().statusBarHeight,
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
    GestureDetector scanCon = GestureDetector(
        onTap: () async {
          if (Platform.isIOS) {
            AppRouter.push(context, RouteName.BARCODE_SCAN);
            //Get.to(QRViewExample());
            return;
          }
          bool canUseCamera = await PermissionTool.haveCameraPermission();
          bool canUsePhoto = await PermissionTool.havePhotoPermission();
          bool canNotification =
              await PermissionTool.haveNotificationPermission();
          if (!canNotification) {
            PermissionTool.showOpenPermissionDialog(context, "没有相机权限,请先授予相机权限");
          }
          if (!canUseCamera) {
            PermissionTool.showOpenPermissionDialog(context, "没有相机权限,请先授予相机权限");
            return;
          } else if (!canUsePhoto) {
            PermissionTool.showOpenPermissionDialog(context, "没有照片权限,请先授予照片权限");
            return;
          } else {
            AppRouter.push(context, RouteName.BARCODE_SCAN);
            //Get.to(QRViewExample());
          }
        },
        child: Container(
          color: Colors.black.withAlpha(1),
          height: kToolbarHeight,
          child: Column(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/navigation_scan.png",
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                ),
              ),
              Spacer(),
            ],
          ),
        ));
    return <Widget>[
      Container(
        height: kToolbarHeight,
        child: Column(
          children: <Widget>[
            CustomImageButton(
              buttonSize: 40,
              padding: EdgeInsets.all(0),
              icon: ImageIcon(AssetImage("assets/navigation_msg.png")),
              color: getCurrentAppItemColor(),
              onPressed: () {
                if (UserManager.instance.haveLogin) {
                  MQManager.goToChat(
                      userId: UserManager.instance.user.info.id.toString(),
                      userInfo: <String, String>{
                        "name": UserManager.instance.user.info.nickname ?? "",
                        "gender": UserManager.instance.user.info.gender == 1
                            ? "男"
                            : "女",
                        "mobile": UserManager.instance.user.info.mobile ?? ""
                      });
                } else {
                  AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                  // showError("请先登录!");
                  Toast.showError("请先登录");
                }
              },
            ),
            Spacer(),
          ],
        ),
      ),
      scanCon,
      Container(
        width: 10,
      ),
    ];
  }

  Widget _buildTitle() {
    double iconSize = 18;
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
              "厨房小工具",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13 * 2.sp,
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
      onTap: () {
        AppRouter.push(context, RouteName.SEARCH);
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
      onTap: () {
        requestPermission();
        AppRouter.push(context, RouteName.WEATHER_CITY_PAGE,
                arguments: WeatherCityPage.setArguments(locationCityName))
            .then((model) {
          if (model is WeatherCityModel) {
            _weatherCityModel = model;
            _getWeather();
          }
        });
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.place,
              color: Colors.white,
              size: 17,
            ),
            Container(
              width: 2,
            ),
            Text(
              cityName,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Container(
              width: 5,
            ),
          ],
        ),
      ),
    );
    return Container(
      height: kToolbarHeight,
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
                    t4Height +
                    rSize(62) +
                    timeHeight +
                    tabbarHeight -
                    ScreenUtil().statusBarHeight -
                    tabbarHeight +
                    4
                : weatherHeight +
                    bannerHeight +
                    buttonsHeight +
                    t1Height +
                    t23Height +
                    t4Height +
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
        SliverList(
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
                  _activityImageRow(),
                  _activityT4Image(),
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
          int realIndex = index - 1;
          if (realIndex < 0) return;
          if (realIndex >= _bannerList.length) realIndex = 0;
          BannerModel bannerModel = _bannerList[realIndex];
          if (!TextUtils.isEmpty(bannerModel.color)) {
            Color color = ColorsUtil.hexToColor(bannerModel.color);
            _backgroundColor = color;
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
                AppRouter.push(context, RouteName.COMMODITY_PAGE,
                    arguments: CommodityDetailPage.setArguments(
                        (bannerModel as BannerModel).goodsId));
              }
            },
            child: ExtendedImage.network(Api.getImgUrl(bannerModel.url),
                fit: BoxFit.fill, enableLoadState: false),
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
              ? ExtendedImage.network(
                  Api.getImgUrl(item.logoUrl),
                  fit: BoxFit.fill,
                  enableLoadState: false,
                )
              // CustomCacheImage(imageUrl: Api.getImgUrl(item.logoUrl),fit: BoxFit.fill, height: rSize(300),width: MediaQuery.of(context).size.width,)
              : Container(),
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
            ? ExtendedImage.network(
                Api.getImgUrl(itemD.logoUrl),
                fit: BoxFit.fill,
                enableLoadState: false,
              )
            : Container(),
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
                            ? ExtendedImage.network(
                                Api.getImgUrl(itemB.logoUrl),
                                fit: BoxFit.fill,
                                enableLoadState: false)
                            // CustomCacheImage(imageUrl: Api.getImgUrl(itemB.logoUrl),fit: BoxFit.fill,)
                            : Container(),
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
                            ? ExtendedImage.network(
                                Api.getImgUrl(itemC.logoUrl),
                                fit: BoxFit.fill,
                                enableLoadState: false)
                            // CustomCacheImage(imageUrl: Api.getImgUrl(itemC.logoUrl),fit: BoxFit.fill,)
                            : Container(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buttonTitleRow(

                    // AppConfig.getShowCommission()
                    //     ? R.ASSETS_HOME_MENU_A_PNG
                    //     : R.ASSETS_LISTTEMP_RECOOKMAKE_ICON_PNG,
                    //Api.getImgUrl(kingCoinListModelList[0].url),
                    AppConfig.commissionByRoleLevel
                        ? Api.getImgUrl(kingCoinListModelList[5].url)
                        : Api.getImgUrl(kingCoinListModelList[0].url),
                    AppConfig.commissionByRoleLevel ? "京东优选" : "京东优选",
                    onPressed: () async{
                  if (AppConfig.commissionByRoleLevel) {
                    if (!UserManager.instance.haveLogin) {
                      AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                      return;
                    }
                    //我的权益内容
                    // AppRouter.push(
                    //   globalContext,
                    //   RouteName.SHOP_PAGE_USER_RIGHTS_PAGE,
                    // );

                    List<FirstCategory> firstCategoryList = [];
                    firstCategoryList = await HomeDao.getJDCategoryList();
                    if(firstCategoryList!=null){
                      Get.to(() => ClassifyPage(
                        jdType: 1,
                        data: firstCategoryList,
                        initValue: '全部',
                      ));
                    }
                  } else {
                    //京东优选
                    List<FirstCategory> firstCategoryList = [];
                    firstCategoryList = await HomeDao.getJDCategoryList();
                    if(firstCategoryList!=null){
                      Get.to(() => ClassifyPage(
                        jdType: 1,
                        data: firstCategoryList,
                        initValue: '全部',
                      ));
                    }
                    // AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
                    //     arguments: GoodsListTempPage.setArguments(
                    //         title: "瑞库制品", type: GoodsListTempType.recookMake));
                    // AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                  }
                  // return;
                  // AppRouter.push(context, RouteName.NEW_USER_DISCOUNT_PAGE);
                }),
                _buttonTitleRow(
                  // R.ASSETS_LOTTERY_REDEEM_LOTTERY_ICON_PNG,
                  // AppConfig.getShowCommission()
                  //     ? R.ASSETS_HOME_MENU_AIR_PNG
                  //     : R.ASSETS_LISTTEMP_HOMELIFE_ICON_PNG,
                  AppConfig.commissionByRoleLevel
                      ? Api.getImgUrl(kingCoinListModelList[6].url)
                      : Api.getImgUrl(kingCoinListModelList[1].url),
                  AppConfig.commissionByRoleLevel ? "高佣特推" : "家居生活",
                  // '彩票兑换',
                  //2021 7,27 ios彩票审核不通过 隐藏彩票
                  //'精彩发现',
                  //'出行服务',
                  onPressed: () async {
                    if (AppConfig.commissionByRoleLevel) {
                      Get.to(()=>GoodsHighCommissionListPage());

                      //AppRouter.push(context, RouteName.REDEEM_LOTTERY_PAGE);

                      // UserManager.instance.selectTabbarIndex = 2;
                      // bool value = UserManager.instance.selectTabbar.value;
                      // UserManager.instance.selectTabbar.value = !value; 精彩发现

                      //Get.to(() => ChooseTicketsTypePage()); //机票
                      //setState(() {});
                    } else {
                      AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
                          arguments: GoodsListTempPage.setArguments(
                              title: "家居生活", type: GoodsListTempType.homeLife));
                    }
                  },

                  //   () {
                  // if (AppConfig.getShowCommission()) {
                  //   bool value = UserManager.instance.selectTabbar.value;
                  //   UserManager.instance.selectTabbar.value = !value;
                  //   UserManager.instance.selectTabbarIndex = 1;
                  // } else {
                  //   AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
                  //       arguments: GoodsListTempPage.setArguments(
                  //           title: "家居生活", type: GoodsListTempType.homeLife));
                  // }
                  // },
                ),
                _buttonTitleRow(
                    // AppConfig.getShowCommission()
                    //     ? R.ASSETS_HOME_INVITE_WEBP_S_PNG
                    //     : R.ASSETS_LISTTEMP_HOMEAPPLIANCES_ICON_PNG,
                    AppConfig.commissionByRoleLevel
                        ? Api.getImgUrl(kingCoinListModelList[7].url)
                        : Api.getImgUrl(kingCoinListModelList[2].url),
                    AppConfig.commissionByRoleLevel
                        // ? "升级店主"
                        ? "特惠专区"
                        : "特惠专区", onPressed: () {
                  if (AppConfig.commissionByRoleLevel) {
                    Get.to(()=>GoodsPreferentialListPage());

                    //ShareTool().inviteShare(context, customTitle: Container()); 一键邀请的代码
                  } else {
                    Get.to(()=>GoodsPreferentialListPage());
                    // AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
                    //     arguments: GoodsListTempPage.setArguments(
                    //         title: "数码家电",
                    //         type: GoodsListTempType.homeAppliances));
                    // AppRouter.push(context, RouteName.Member_BENEFITS_PAGE,);
                  }
                }),
                _buttonTitleRow(
                    //R.ASSETS_HOME_MENU_DD_PNG,
                    Api.getImgUrl(kingCoinListModelList[3].url),
                    "热销榜单", onPressed: () {
                  AppRouter.push(context, RouteName.GOODS_HOT_LIST);
                }),
                _buttonTitleRow(
                    //R.ASSETS_HOME_MENU_EE_PNG,
                    Api.getImgUrl(kingCoinListModelList[4].url),
                    "进口专区", onPressed: () async {
                  // HomeDao.getCategories(success: (data, code, msg) {
                  //   CRoute.push(
                  //       context,
                  //       ClassifyPage(
                  //         data: data,
                  //       ));
                  // }, failure: (code, msg) {
                  //   Toast.showError(msg);
                  // });

                  //8.9更新金刚区 增加进口专区
                  List<CountryListModel> countryListModelList;
                  countryListModelList = await HomeDao.getCountryList();
                  Get.to(ClassifyCountryPage(data: countryListModelList));
                }),
              ],
            ),
          ),
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      color: AppColor.frenchColor,
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: titles,
    );
  }

  _buttonTitleRow(icon, title, {onPressed}) {
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
              child:
                  // FadeInImage.assetNetwork(
                  //     placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                  //     image: icon)
                  // Image.asset(
                  //   icon,
                  //   fit: BoxFit.fill,
                  // ),
                  CachedNetworkImage(
                      imageUrl: icon,
                      placeholder: (context, url) => Image.asset(
                            R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                            fit: BoxFit.fill,
                          )),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12 * 2.sp,
                    color: Colors.black.withOpacity(0.8)),
              ),
            )
          ],
        ),
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
        },
      ),
    );
  }

  _placeholder() {
    return Image.asset(
      R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
      fit: BoxFit.fill,
    );
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
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_DEPARTMENT_PNG, '日用百货'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_WINE_PNG, '酒饮冲调'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_IMPORT_PNG, '进口专区'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_TEA_PNG, '休闲美食'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_FOOD_PNG, '有机食品'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_VEGETABLES_PNG, '蔬果生鲜'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_RICE_PNG, '柴米油盐'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_ELECTRICITY_PNG, '家用电器'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_PHONE_PNG, '手机数码'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_BABY_PNG, '母婴用品'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_SPORT_PNG, '运动旅行'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_MEDICALBOX_PNG, '医疗保健'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_HAIR_PNG, '美妆护肤'),
                _buildSingleGoodsCard(R.ASSETS_HOME_IC_CLEAN_PNG, '个护清洁'),
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

  _getBannerList() async {
    ResultData resultData = await HttpManager.post(HomeApi.banner_list, {});
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
    ResultData resultData = await HttpManager.post(HomeApi.activity_list, {});
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
    RUICodeListener(context).clipboardListener();
    ResultData resultData = await HttpManager.post(HomeApi.promotion_list, {});

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

      //   if (array.length > 3) {

      //   array.insert(3, model.data.activityList.first);
      // } else {
      //   array.add(model.data.activityList.first);
      // }
    }
    // _promotionGoodsList = model.data.goodsList;
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

  _mobShareInit() {
    ShareSDKRegister register = ShareSDKRegister();
    // register.setupSinaWeibo(
    //     "3484799074", "0cc08d31b4d63dc81fbb7a2559999fb3", "https://reecook.cn");
    register.setupQQ("101876843", "6f367bfad98978e22c2e11897dd74f00");
    SharesdkPlugin.regist(register);
  }

  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      return true;
    }
    bool permission = await Permission.locationWhenInUse.isRestricted;
    bool permanentDenied =
        await Permission.locationWhenInUse.isPermanentlyDenied;
    if (!permission) {
      await Permission.locationWhenInUse.request();
      if (permanentDenied) {
        await PermissionTool.showOpenPermissionDialog(context, '打开定位权限');
      }
      permission = await Permission.locationWhenInUse.isGranted;
    }
    return permission;
  }

  //抽奖功能
  _userLottery() async {
    //暂时移除抽奖功能（大概率以后用不到）
    // ResultData resultData = await HttpManager.post(
    //   UserApi.user_lottery,
    //   {'userID': UserManager.instance.user.info.id},
    // );
    // if (resultData.data != null && resultData.data['data'] != null) {
    //   if (resultData.data['data']['result'] == 0) {
    //     ResultData lottery = await HttpManager.post(UserApi.user_do_lottery,
    //         {'userID': UserManager.instance.user.info.id});
    //     await Future.delayed(Duration(milliseconds: 500));
    //     await Navigator.push(
    //       context,
    //       PageRouteBuilder(
    //           opaque: false,
    //           pageBuilder: (BuildContext context, Animation<double> animation,
    //               Animation<double> secondaryAnimation) {
    //             return LotteryPage(
    //               cardIndex: lottery.data['data']['result'],
    //             );
    //           }),
    //     );
    //   }
    // }

    //店铺角色变动

    bool firstTag = false;
    ResultData shopLevel = await HttpManager.post(
      APIV2.userAPI.userLottery,
      {'userID': UserManager.instance.user.info.id},
    );
    if (shopLevel.data != null &&
        shopLevel.data['data'] != null &&
        shopLevel.data['code'] == 'SUCCESS') {
      int oldLevel = shopLevel.data['data']['oldRoleLevel'];
      int nowLevel = shopLevel.data['data']['nowRoleLevel'];

      if (oldLevel == 400 && nowLevel == 400) return;

      if ((oldLevel == 0 || oldLevel == 500) && nowLevel == 400) {
        firstTag = true;
        await showDialog(
          context: context,
          builder: (context) => Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(R.ASSETS_USER_BE_THE_MASTER_WEBP),
            ),
          ),
        );
        await HttpManager.post(APIV2.userAPI.agreeLottery, {});
        await UserManager.instance.updateUserBriefInfo(getStore());
      }
      String img;
      //用户升级
      if (oldLevel > nowLevel) {
        switch (UserLevelTool.roleLevelEnum(nowLevel)) {
          case UserRoleLevel.Diamond_1:
          case UserRoleLevel.Diamond_2:
          case UserRoleLevel.Diamond_3:
            // img = R.ASSETS_USER_UPGRADE_DIAMOND_PNG_WEBP;
            img = R.ASSETS_USER_UPGRADABLE_DIAMOND_PNG_WEBP;
            break;
          case UserRoleLevel.Gold:
            // img = R.ASSETS_USER_UPGRADE_GOLD_PNG_WEBP;
            img = R.ASSETS_USER_UPGRADABLE_GOLD_PNG_WEBP;
            break;
          case UserRoleLevel.Silver:
            // img = R.ASSETS_USER_UPGRADE_SILVER_PNG_WEBP;
            img = R.ASSETS_USER_UPGRADABLE_SILVER_PNG_WEBP;
            break;
          case UserRoleLevel.Master:
            img = R.ASSETS_USER_UPGRADABLE_MASTER_PNG_WEBP;
            break;
          default:
            break;
        }
      }
      //用户降级
      if (oldLevel < nowLevel) {
        switch (UserLevelTool.roleLevelEnum(nowLevel)) {
          case UserRoleLevel.Silver:
            img = R.ASSETS_USER_DOWNGRADE_SILVER_WEBP;
            break;
          case UserRoleLevel.Master:
            img = R.ASSETS_USER_DOWNGRADE_MASTER_WEBP;
            break;
          default:
            break;
        }
      }
      if (img != null && !firstTag) {
        await showDialog(
          context: context,
          builder: (context) => Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Image.asset(img),
              ),
            ),
          ),
        );
        await HttpManager.post(APIV2.userAPI.agreeLottery, {});
      }
    }
  }

  _getNoticeList() async {
    if (!UserManager.instance.haveLogin) return;
    ResultData resultData = await HttpManager.post(
        HomeApi.notice_list, {"uid": UserManager.instance.user.info.id});
    if (resultData.data == null) return;
    NoticeListModel noticeListModel = NoticeListModel.fromJson(resultData.data);
    if (noticeListModel.data != null && noticeListModel.data.length > 0) {
      for (NoticeData noticeData in noticeListModel.data) {
        // 1钻石推荐的提示,2 23层会员登录的提示，3首次改昵称，4需要填写快递的提示
        if (noticeData.type == 1)
          await NoticeListTool.diamondRecommendation(context,
              title: noticeData.content);
        if (noticeData.type == 2 &&
            (AppConfig.getShowCommission())) if (noticeData.type == 3)
          await NoticeListTool.perfectInformation(context, getStore());
        if (noticeData.type == 4)
          await NoticeListTool.inputExpressInformation(context);
      }
    }
  }

  _userCardNoticeList() async {
    await Future.delayed(Duration(milliseconds: 300));

    ResultData resultData =
        await HttpManager.post(APIV2.userAPI.userCardNoticeList, {});
    if (resultData.data != null && resultData.data['data'] != null) {
      List<dynamic> noticeList = resultData.data['data'];
      for (var item in noticeList) {
        final int gold = item['gold'];
        final int silver = item['silver'];
        final int id = item['id'];
        String goldValue = '';
        String silverValue = '';
        if (gold != null && gold != 0) goldValue = '$gold张黄金卡';
        if (silver != null && silver != 0) silverValue = '$silver张白银卡';
        String result = '';
        if (goldValue.isNotEmpty && silverValue.isNotEmpty)
          result = '$goldValue,$silverValue';
        else {
          result = '$goldValue$silverValue';
        }
        await Get.dialog(Center(
          child: GestureDetector(
            onTap: () async {
              await HttpManager.post(
                APIV2.userAPI.confirmUserCardChange,
                {"noticeId": id},
              );
              await Get.to(UpgradeCardPageV2());
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50.rw),
              child: Center(
                  child: Material(
                color: Colors.transparent,
                child: Transform.translate(
                  offset: Offset(0, 20.rw),
                  child: Text(
                    '您有$result已退至您的卡包',
                    style: TextStyle(
                      fontSize: 14.rsp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(R.ASSETS_USER_NOTICE_CARD_PNG),
                ),
              ),
            ),
          ),
        ));
      }
    }
  }
}
