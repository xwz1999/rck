/*
 * ====================================================
 * package   : pages.home
 * author    : Created by nansi.
 * time      : 2019/5/5  4:36 PM 
 * remark    : 
 * ====================================================
 */
import 'package:async/async.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/meiqia_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/banner_list_model.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/home_weather_model.dart';
import 'package:recook/models/promotion_goods_list_model.dart';
import 'package:recook/models/promotion_list_model.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/home_page_tabbar.dart';
import 'package:recook/pages/home/items/item_column_goods.dart';
import 'package:recook/pages/home/items/item_row_acitivity.dart';
import 'package:recook/pages/home/items/item_row_goods.dart';
import 'package:recook/pages/home/promotion_time_tool.dart';
import 'package:recook/pages/home/widget/goods_list_temp_page.dart';
import 'package:recook/pages/home/widget/home_color_animation_widget.dart';
import 'package:recook/pages/home/widget/home_countdown_widget.dart';
import 'package:recook/pages/home/widget/home_weather_view.dart';
import 'package:recook/pages/noticeList/notice_list_model.dart';
import 'package:recook/pages/noticeList/notice_list_tool.dart';
import 'package:recook/third_party/wechat/wechat_utils.dart';
import 'package:recook/utils/android_back_desktop.dart';
import 'package:recook/utils/app_router.dart';
import 'package:recook/utils/color_util.dart';
import 'package:recook/utils/permission_tool.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/banner.dart';
import 'package:recook/widgets/bottom_sheet/bottom_share_dialog.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/goods_item.dart';
import 'package:recook/widgets/home_gif_header.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/toast.dart';
import 'package:recook/widgets/weather_page/weather_city_model.dart';
import 'package:recook/widgets/weather_page/weather_city_page.dart';
import 'package:recook/widgets/webView.dart';
import 'package:recook/pages/home/widget/home_app_bar.dart' as homeAppBar;
import 'package:recook/pages/home/lottery_page.dart';
import 'package:sharesdk_plugin/sharesdk_plugin.dart';

import '../../utils/text_utils.dart';

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
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends BaseStoreState<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Location _weatherLocation;
  TabController _tabController;
  int _tabIndex = 0;

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
  GlobalKey<HomeColorAnimationWidgetState> _colorAnimationState = GlobalKey();
  GlobalKey<homeAppBar.SliverAppBarState> _sliverAppBarGlobalKey = GlobalKey();
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

  @override
  void initState() {
    super.initState();
    // 分享注册
    _mobShareInit();
    // 高德定位注册
    _amapInit();
    // 判断微信是否登录
    WeChatUtils.initial();
    // meiqia注册
    MQManager.initial();
    ShareTool.init();
    // _backgroundColor = AppColor.themeColor;
    _homeCountdownController = HomeCountdownController();

    UserManager.instance.openInstallGoodsId
        .addListener(_openInstallGoodsIdListener);
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
  }

  // 获取当前页面需要刷新的数据
  _updateSource() {
    _getWeather();
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
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DPrint.printf("后台返回前台");
      _updateSource();
      // _handleOpenInstallEvents();
    }
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    super.build(context);

    screenWidth = MediaQuery.of(context).size.width;
    weatherHeight = (76 + ScreenUtil.statusBarHeight);
    bannerHeight = (screenWidth - 20) / 2.34;
    t1Height = (screenWidth - 20) * 0.3429;
    t23Height = ((screenWidth - 28) / 2) * 0.5 + 10;
    t4Height = (screenWidth - 20) * 0.2714;

    return WillPopScope(
        onWillPop: () async {
          Alert.show(
              context,
              NormalTextDialog(
                type: NormalTextDialogType.delete,
                title: "提示",
                content: "是否要跳转到桌面?",
                items: ["确认"],
                listener: (index) {
                  AndroidBackTop.backDeskTop(); //设置为返回不退出app
                  Alert.dismiss(context);
                },
                deleteItem: "取消",
                deleteListener: () {
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
                headerTriggerDistance: ScreenUtil.statusBarHeight,
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
            return;
          }
          bool canUseCamera = await PermissionTool.haveCameraPermission();
          bool canUsePhoto = await PermissionTool.havePhotoPermission();
          if (!canUseCamera) {
            PermissionTool.showOpenPermissionDialog(context, "没有相机权限,请先授予相机权限");
            return;
          } else if (!canUsePhoto) {
            PermissionTool.showOpenPermissionDialog(context, "没有照片权限,请先授予照片权限");
            return;
          } else {
            AppRouter.push(context, RouteName.BARCODE_SCAN);
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
              width: ScreenAdapterUtils.setWidth(iconSize),
              height: ScreenAdapterUtils.setWidth(iconSize),
              child: Image.asset(
                'assets/home_tab_search.png',
                width: ScreenAdapterUtils.setWidth(iconSize),
                height: ScreenAdapterUtils.setWidth(iconSize),
              ),
            ),
            Container(
              width: 6,
            ),
            Text(
              "厨房小工具",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: ScreenAdapterUtils.setSp(13),
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
        _weatherLocation != null && !TextUtils.isEmpty(_weatherLocation.city)
            ? _weatherLocation.city
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
        homeAppBar.SliverAppBar(
            key: _sliverAppBarGlobalKey,
            titleSpacing: 3,
            actions: _actionsWidget(),
            title: _buildTitle(),
            floating: false,
            pinned: true,
            snap: false,
            elevation: 0,
            backgroundColor: AppColor.themeColor,
            // backgroundColor: getCurrentThemeColor(),
            // expandedHeight: weatherHeight + bannerHeight + buttonsHeight + t1Height + t23Height + t4Height + timeHeight + tabbarHeight - ScreenUtil.statusBarHeight ,
            expandedHeight: _promotionList == null || _promotionList.length == 0
                ? weatherHeight +
                    bannerHeight +
                    buttonsHeight +
                    t1Height +
                    t23Height +
                    t4Height +
                    timeHeight +
                    tabbarHeight -
                    ScreenUtil.statusBarHeight -
                    tabbarHeight +
                    4
                : weatherHeight +
                    bannerHeight +
                    buttonsHeight +
                    t1Height +
                    t23Height +
                    t4Height +
                    timeHeight +
                    tabbarHeight -
                    ScreenUtil.statusBarHeight +
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
                        fontSize: ScreenAdapterUtils.setSp(13)),
                  ),
                );
              }
              if (_promotionGoodsList[index] is PromotionGoodsModel) {
                PromotionGoodsModel model = _promotionGoodsList[index];
                return Container(
                  padding: EdgeInsets.only(bottom: 5),
                  color: AppColor.frenchColor,
                  child: GoodsItemWidget.rowGoods(
                    onBrandClick: () {
                      AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                          arguments: BrandGoodsListPage.setArguments(
                              model.brandId, model.brandName));
                    },
                    model: model,
                    shareClick: () {
                      String goodsTitle =
                          "${model.priceDesc} | ${model.goodsName} | ${model.description}";
                      ShareTool().goodsShare(context,
                          goodsPrice: model.price.toStringAsFixed(2),
                          goodsName: model.goodsName,
                          goodsDescription: model.description,
                          miniTitle: goodsTitle,
                          miniPicurl: model.picture.url,
                          amount: model.commission.toString(),
                          goodsId: model.goodsId.toString());
                    },
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
              HomeColorAnimationWidget(
                key: _colorAnimationState,
                width: screenWidth,
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
                  _buttonTitle(context),
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
      BannerModel bannerModel = _bannerList[_bannerList.length - 1];
      if (!TextUtils.isEmpty(bannerModel.color)) {
        Color color = ColorsUtil.hexToColor(bannerModel.color);
        _backgroundColor = color;
        _colorAnimationState.currentState.changeBackgroundColor(color);
        _sliverAppBarGlobalKey.currentState.changeBackgroundColor(color);
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
            _colorAnimationState.currentState.changeBackgroundColor(color);
            _sliverAppBarGlobalKey.currentState.changeBackgroundColor(color);
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
                // _buttonTitleRow("assets/home_menu_a.png", "我的权益",
                _buttonTitleRow(
                    AppConfig.getShowCommission()
                        ? "assets/home_menu_a.png"
                        : "assets/listtemp_recookmake_icon.png",
                    AppConfig.getShowCommission() ? "我的权益" : "瑞库制品",
                    onPressed: () {
                  if (AppConfig.getShowCommission()) {
                    if (!UserManager.instance.haveLogin) {
                      AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                      return;
                    }
                    AppRouter.push(
                      globalContext,
                      RouteName.SHOP_PAGE_USER_RIGHTS_PAGE,
                    );
                  } else {
                    AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
                        arguments: GoodsListTempPage.setArguments(
                            title: "瑞库制品", type: GoodsListTempType.recookMake));
                    // AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
                  }
                  // return;
                  // AppRouter.push(context, RouteName.NEW_USER_DISCOUNT_PAGE);
                }),
                _buttonTitleRow(
                  AppConfig.getShowCommission()
                      ? "assets/home_menu_bb.png"
                      : "assets/listtemp_homelife_icon.png",
                  AppConfig.getShowCommission() ? "我的店铺" : "家居生活",
                  onPressed: () {
                    showToast('⚠️需要处理打开逻辑');
                    AppRouter.push(context, RouteName.REDEEM_LOTTERY_PAGE);
                  },
                  // () {
                  //   if (AppConfig.getShowCommission()) {
                  //     bool value = UserManager.instance.selectTabbar.value;
                  //     UserManager.instance.selectTabbar.value = !value;
                  //     UserManager.instance.selectTabbarIndex = 2;
                  //   } else {
                  //     AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
                  //         arguments: GoodsListTempPage.setArguments(
                  //             title: "家居生活", type: GoodsListTempType.homeLife));
                  //   }
                  // },
                ),
                _buttonTitleRow(
                    AppConfig.getShowCommission()
                        ? "assets/home_menu_cc.png"
                        : "assets/listtemp_homeappliances_icon.png",
                    AppConfig.getShowCommission()
                        // ? "升级店主"
                        ? "一键邀请"
                        : "数码家电", onPressed: () {
                  if (AppConfig.getShowCommission()) {
                    ShareTool().inviteShare(context, customTitle: Container());
                  } else {
                    AppRouter.push(context, RouteName.GOODS_LIST_TEMP,
                        arguments: GoodsListTempPage.setArguments(
                            title: "数码家电",
                            type: GoodsListTempType.homeAppliances));
                    // AppRouter.push(context, RouteName.Member_BENEFITS_PAGE,);
                  }
                }),

                _buttonTitleRow("assets/home_menu_dd.png", "热销榜单",
                    onPressed: () {
                  AppRouter.push(context, RouteName.GOODS_HOT_LIST);
                }),
                _buttonTitleRow("assets/home_menu_ee.png", "全部分类",
                    onPressed: () {
                  AppRouter.push(context, RouteName.CLASSIFY);
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
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Container(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: 48,
              height: 48,
              child: Image.asset(
                icon,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenAdapterUtils.setSp(12),
                    color: Colors.black.withOpacity(0.8)),
              ),
            )
          ],
        ),
        onTap: () {
          if (onPressed != null) {
            onPressed();
          }
        },
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
      if (array.length > 3) {
        array.insert(3, model.data.activityList.first);
      } else {
        array.add(model.data.activityList.first);
      }
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
            ScreenUtil.statusBarHeight -
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

    if (await requestPermission())
      _weatherLocation = await AmapLocation.fetchLocation();

    String url =
        "https://tianqiapi.com/api?version=v61&appid=81622428&appsecret=AxKzYWq3";
    if (_weatherCityModel != null && !TextUtils.isEmpty(_weatherCityModel.id)) {
      url = "$url&cityid=${_weatherCityModel.id}";
    } else if (_weatherCityModel != null &&
        !TextUtils.isEmpty(_weatherCityModel.cityZh)) {
      url = "$url&city=${_weatherCityModel.cityZh}";
    } else if (_weatherLocation != null &&
        !TextUtils.isEmpty(_weatherLocation.city)) {
      // url = "$url&point=gaode&lng=${_weatherLocation.latLng.longitude.toString()}&lat=${_weatherLocation.latLng.latitude.toString()}";
      String city = _weatherLocation.city.replaceAll("区", "");
      city = city.replaceAll("市", "");
      url = "$url&city=$city";
    }
    Response res = await HttpManager.netFetchNormal(url, null, null, null);
    if (res == null) {
      return;
    }
    Map map = json.decode(res.toString());
    _homeWeatherModel = HomeWeatherModel.fromJson(map);
    UserManager.instance.homeWeatherModel = _homeWeatherModel;
    if (mounted) setState(() {});
  }

  _mobShareInit() {
    ShareSDKRegister register = ShareSDKRegister();
    register.setupSinaWeibo("3484799074", "0cc08d31b4d63dc81fbb7a2559999fb3",
        "https://www.reecook.cn");
    register.setupQQ("101876843", "6f367bfad98978e22c2e11897dd74f00");
    SharesdkPlugin.regist(register);
  }

  _amapInit() {
    AmapCore.init("e8a8057cfedcdcadcf4e8f2c7f8de982");
  }

  Future<bool> requestPermission() async {
    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  _userLottery() {
    //抽奖功能
    HttpManager.post(
      UserApi.user_lottery,
      {'userID': UserManager.instance.user.info.id},
    ).then((value) {
      if (value.data != null) {
        Map map = value.data;
        if (!map.containsKey("data")) return;
        if (value.data['data']['result'] == 0) {
          HttpManager.post(UserApi.user_do_lottery,
              {'userID': UserManager.instance.user.info.id}).then((result) {
            Future.delayed(Duration(milliseconds: 500), () {
              Navigator.push(
                context,
                PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return LotteryPage(
                        cardIndex: result.data['data']['result'],
                      );
                    }),
              );
            });
          });
        }
      }
    });
  }

  _getNoticeList() async {
    // // await NoticeListTool.diamondRecommendation(context, title: "您成功推荐了X位大咖,恭喜获得X张升级卡和保级卡");
    // // await NoticeListTool.vipAlert(context);
    // await NoticeListTool.perfectInformation(context, getStore());
    // // await NoticeListTool.inputExpressInformation(context);
    // return;

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
        if (noticeData.type == 2 && (AppConfig.getShowCommission()))
        //await NoticeListTool.vipAlert(context);
        if (noticeData.type == 3)
          await NoticeListTool.perfectInformation(context, getStore());
        if (noticeData.type == 4)
          await NoticeListTool.inputExpressInformation(context);
      }
    }
  }
}
