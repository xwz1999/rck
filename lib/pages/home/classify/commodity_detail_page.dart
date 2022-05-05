
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/models/goods_detail_model.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/home/classify/goods_page.dart';
import 'package:recook/pages/home/classify/material_page.dart' as MP;
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/widget/modify_detail_app_bar.dart';
import 'package:recook/pages/home/widget/modify_detail_bottom_bar.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/cache_tab_bar_view.dart';
import 'package:recook/widgets/toast.dart';

class CommodityDetailPage extends StatefulWidget {
  final Map arguments;

  const CommodityDetailPage({
    Key key,
    this.arguments,
  }) : super(key: key);

  static setArguments(int goodsID, {int liveStatus, int roomId,String invite}) {
    return {"goodsID": goodsID, 'liveStatus': liveStatus, 'roomId': roomId,'invite':invite};
  }

  @override
  State<StatefulWidget> createState() {
    return _CommodityDetailPageState();
  }
}

class _CommodityDetailPageState extends BaseStoreState<CommodityDetailPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  AppBarController _appBarController;
  BottomBarController _bottomBarController;
  ValueNotifier<bool> _openSkuChoosePage = ValueNotifier(false);
  int _goodsId;
  GoodsDetailModel _goodsDetail;
  String invite;

  @override
  void initState() {
    super.initState();
    _goodsId = widget.arguments["goodsID"];
    invite = widget.arguments["invite"];

    _tabController = TabController(length: 2, vsync: this);
    _appBarController = AppBarController();
    _bottomBarController = BottomBarController();


    _tabController.addListener(() {
      if (_tabController.index == 1||_tabController.index == 2) {
        _bottomBarController.hidden.value = true;
      } else {
        _bottomBarController.hidden.value = false;
      }
    });
    _getDetail();
    UserManager.instance.refreshShoppingCartNumberWithPage
        .addListener(_refreshShoppingCartNumberWithPageListener);
    UserManager.instance.refreshGoodsDetailPromotionState
        .addListener(_refreshPromotionState);
  }

  _refreshPromotionState() {
    _getDetail();
  }

  _refreshShoppingCartNumberWithPageListener() {
    _updateShoppingCartNum();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _bottomBarController?.dispose();
    _appBarController?.dispose();
    UserManager.instance.refreshShoppingCartNumberWithPage
        .removeListener(_refreshShoppingCartNumberWithPageListener);
    UserManager.instance.refreshGoodsDetailPromotionState
        .removeListener(_refreshPromotionState);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateShoppingCartNum();
  }

  _updateShoppingCartNum() async {
    if (UserManager.instance.refreshShoppingCartNumber.value ||
        UserManager.instance.refreshShoppingCartNumberWithPage.value) {
      UserManager.instance.refreshShoppingCartNumber.value = false;
      UserManager.instance.refreshShoppingCartNumberWithPage.value = false;
      GoodsDetailModel model = await GoodsDetailModelImpl.getDetailInfo(
          _goodsId, UserManager.instance.user.info.id);
      if (model.code != HttpStatus.SUCCESS) {
        return;
      }
      _goodsDetail.data.shoppingTrolleyCount = model.data.shoppingTrolleyCount;
      setState(() {});
    } else {}
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    Scaffold scaffold = Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: CacheTabBarView(
                          controller: _tabController,
                          children: [
                            _goodsDetail!=null?
                            GoodsPage(

                              openbrandList: () {
                                // _goodsDetail.data.brandId;
                                AppRouter.push(
                                    context, RouteName.BRANDGOODS_LIST_PAGE,
                                    arguments: BrandGoodsListPage.setArguments(
                                        _goodsDetail.data.brand.id,
                                        _goodsDetail.data.brand.name));
                              },
                              goodsId: _goodsId,
                              openSkuChoosePage: _openSkuChoosePage,
                              goodsDetail: _goodsDetail,
                              onScroll: (notification) {
                                // double maxScroll = notification.metrics.maxScrollExtent;
                                double offset = notification.metrics.pixels;
                                double scale = offset / 180;
                                scale = scale.clamp(0.0, 1.0);

                                _appBarController.scale.value = scale;

                                // if (offset > maxScroll + 5) {
                                //   _tabController.animateTo(1);
                                // }
                              },
                              invite: invite,
                            ):SizedBox(),
                            // DetailPage(
                            //   goodsID: _goodsId,
                            // ),
                            MP.MaterialPage(
                              goodsID: _goodsId,
                            ),
                            // GoodsReportPage(goodsId: _goodsId,),
                          ]),
                    ),
                    _bottomBar()
                  ],
                )),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: _buildCustomAppBar(context),
              // child: Container(),
            ),
          ],
        ),
      ),
    );
    //黑色
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    // return scaffold;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: scaffold,
    );
  }

  _buildCustomAppBar(BuildContext context) {
    return DetailAppBar(
      tabBar: _buildTabBar(),
      controller: _appBarController,
      // onShareClick: () {
      //   _showShare(context);
      // },
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        indicatorColor: AppColor.themeColor,
        indicatorSize: TabBarIndicatorSize.label,
        controller: _tabController,
        tabs: [
          Text("商品", style: TextStyle(color: Colors.black)),
          // Text("详情", style: TextStyle(color: Colors.black)),
          Text(
            "发现",
            style: TextStyle(color: Colors.black),
          ),
          // Text(
          //   "产品画像",
          //   style: TextStyle(color: Colors.black),
          // ),
        ]);
  }

  _bottomBar() {
    return DetailBottomBar(
      goodsDetail: _goodsDetail,
      controller: _bottomBarController,
      collected: _goodsDetail == null ? false : _goodsDetail.data.isFavorite,
      shopCartNum: _goodsDetail?.data == null
          ? ''
          : _goodsDetail.data.shoppingTrolleyCount > 99
              ? "99+"
              : _goodsDetail.data.shoppingTrolleyCount == 0
                  ? ""
                  : _goodsDetail.data.shoppingTrolleyCount.toString(),
      addToShopCartListener: () {
        AppRouter.push(context, RouteName.GOODS_SHOPPING_CART);
      },
      collectListener: (bool favorite) {
        if (favorite) {
          if (UserManager.instance.user.info.id == 0) {
            AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
            Toast.showError('请先登录...');
            return;
          }
          _addFavorite();
        } else {
          _cancelFavorite();
        }
      },
      buyListener: () {
        num coupon = 0;
        if (_goodsDetail.data.sku != null && _goodsDetail.data.sku.length > 0) {
          coupon = _goodsDetail.data.sku[0].coupon;
          _goodsDetail.data.sku.forEach((element) {
            if (coupon > element.coupon) coupon = element.coupon;
          });
        } else {
          coupon = 0;
        }
        if(coupon>0){
          Toast.showInfo('$coupon元优惠券已领');
        }
        _openSkuChoosePage.value = true;

      },
      shareListener: () {
        _showShare(context);
      },
    );
  }

  _showShare(BuildContext context) {
    // if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip ||
    //     UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None) {
    //   //跳到分享邀请
    //   // _showInviteShare(context);
    //   ShareTool().inviteShare(context);
    //   return;
    // }
    String goodsTitle =
        "${_goodsDetail.data.getPriceString()} | ${_goodsDetail.data.goodsName} | ${_goodsDetail.data.description}";
    ShareTool().goodsShare(context,
        goodsPrice: _goodsDetail.data.getPriceString(),
        miniTitle: goodsTitle,
        goodsName: _goodsDetail.data.goodsName,
        goodsDescription: _goodsDetail.data.description,
        miniPicurl: _goodsDetail.data.mainPhotos.length > 0
            ? _goodsDetail.data.mainPhotos[0].url
            : "",
        goodsId: _goodsDetail.data.id.toString(),
        amount: _goodsDetail.data.price.min.commission > 0
            ? _goodsDetail.data.price.min.commission.toString()
            : "");
  }

  _getDetail() async {
    _goodsDetail = await GoodsDetailModelImpl.getDetailInfo(
        _goodsId, UserManager.instance.user.info.id);
    if (_goodsDetail.code != HttpStatus.SUCCESS) {
      Toast.showError(_goodsDetail.msg);
      return;
    }
    _bottomBarController.setFavorite(_goodsDetail.data.isFavorite);
    setState(() {});
  }

  _addFavorite() async {
    HttpResultModel<BaseModel> resultModel =
        await GoodsDetailModelImpl.favoriteAdd(
            UserManager.instance.user.info.id, _goodsDetail.data.id);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    _bottomBarController.setFavorite(true);
  }

  _cancelFavorite() async {
    HttpResultModel<BaseModel> resultModel =
        await GoodsDetailModelImpl.favoriteCancel(
            UserManager.instance.user.info.id, _goodsDetail.data.id);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    _bottomBarController.setFavorite(false);
  }
}
