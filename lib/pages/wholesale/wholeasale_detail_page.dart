import 'dart:convert';

import 'package:bytedesk_kefu/bytedesk_kefu.dart';
import 'package:bytedesk_kefu/util/bytedesk_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:recook/pages/home/widget/modify_detail_app_bar.dart';
import 'package:recook/pages/home/widget/modify_detail_bottom_bar.dart';
import 'package:recook/pages/tabBar/TabbarWidget.dart';
import 'package:recook/pages/wholesale/wholesale_car_page.dart';
import 'package:recook/pages/wholesale/wholesale_goods_page.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_floating_action_button_location.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/toast.dart';

import 'Wholesale_modify_detail_bottom_bar.dart';
import 'func/wholesale_func.dart';
import 'models/wholesale_detail_model.dart';

class WholesaleDetailPage extends StatefulWidget {
  final int? goodsId;

  const WholesaleDetailPage({
    Key? key,
    this.goodsId,
  }) : super(key: key);

  static setArguments(
    int goodsID,
  ) {
    return {
      "goodsID": goodsID,
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _WholesaleDetailPageState();
  }
}

class _WholesaleDetailPageState extends BaseStoreState<WholesaleDetailPage>
    with TickerProviderStateMixin {
  AppBarController? _appBarController;
  BottomBarController? _bottomBarController;
  ValueNotifier<bool> _openSkuChoosePage = ValueNotifier(false);
  int? _goodsId;
  WholesaleDetailModel? _goodsDetail;


  @override
  void initState() {
    super.initState();
    _goodsId = widget.goodsId;

    _appBarController = AppBarController();
    _bottomBarController = BottomBarController();

    _getDetail();

    UserManager.instance!.refreshGoodsDetailPromotionState
        .addListener(_refreshPromotionState);
  }

  _refreshPromotionState() {
    _getDetail();
  }

  @override
  void dispose() {
    _bottomBarController?.dispose();
    _appBarController?.dispose();

    UserManager.instance!.refreshGoodsDetailPromotionState
        .removeListener(_refreshPromotionState);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    Scaffold scaffold = Scaffold(
      floatingActionButton: _customer(),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.endDocked, 0, -80.rw),
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
                      child: _goodsDetail != null
                          ? WholesaleGoodsPage(
                              goodsId: _goodsId,
                              openSkuChoosePage: _openSkuChoosePage,
                              goodsDetail: _goodsDetail,
                              isWholesale: true,
                              onScroll: (notification) {
                                // double maxScroll = notification.metrics.maxScrollExtent;
                                double offset = notification.metrics.pixels;
                                double scale = offset / 180;
                                scale = scale.clamp(0.0, 1.0);
                                _appBarController!.scale.value = scale;
                              },
                            )
                          : SizedBox(),
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
    return CustomAppBar(
      appBackground: Colors.transparent,
      elevation: 0,
      titleSpacing: 20,
      themeData: AppThemes.themeDataGrey.appBarTheme,
      leading: Center(
        child: CustomImageButton(
          icon: Icon(
            AppIcons.icon_back,
            size: 16 * 2.sp,
            color: Colors.white,
          ),
          buttonSize: rSize(30),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          backgroundColor: Color.fromARGB(100, 0, 0, 0),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
    );
  }

  _customer() {
    return GestureDetector(
      onTap: () async {
        // WholesaleCustomerModel? model = await WholesaleFunc.getCustomerInfo();
        //
        // Get.to(() => WholesaleCustomerPage(
        //       model: model,
        //     ));
        if (UserManager.instance!.user.info!.id == 0) {
          AppRouter.pushAndRemoveUntil(context, RouteName.LOGIN);
          Toast.showError('请先登录...');
          return;
        }

        var custom = json.encode({
          "type": BytedeskConstants.MESSAGE_TYPE_COMMODITY, // 不能修改
          "title": _goodsDetail?.goodsName??"", // 可自定义, 类型为字符串
          "content": _goodsDetail?.description??"", // 可自定义, 类型为字符串
          "price": _goodsDetail?.sku?.first?.salePrice?.toStringAsFixed(2), // 可自定义, 类型为字符串
          // "url":
          // "https://item.m.jd.com/product/12172344.html", // 必须为url网址, 类型为字符串
          "imageUrl":
          Api.getImgUrl(_goodsDetail?.sku?.first?.picUrl), //必须为图片网址, 类型为字符串
          "id": _goodsDetail?.sku?.first?.goodsId, // 可自定义
          "categoryCode": _goodsDetail?.sku?.first?.code, // 可自定义, 类型为字符串
          "client": "flutter" // 可自定义, 类型为字符串
        });
        BytedeskKefu.startWorkGroupChatShop(
            context, AppConfig.WORK_GROUP_WID, "客服", custom);
        // BytedeskKefu.startWorkGroupChat(context, AppConfig.WORK_GROUP_WID, "客服");
      },
      child: Container(
        width: 46.rw,
        height: 46.rw,
        decoration: BoxDecoration(
          color: Color(0xFF000000).withOpacity(0.7),
          borderRadius: BorderRadius.all(Radius.circular(23.rw)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              R.ASSETS_WHOLESALE_WHOLESALE_CUSTOMER_PNG,
              width: 20.rw,
              height: 20.rw,
            ),
            5.hb,
            Text(
              '客服',
              style: TextStyle(color: Colors.white, fontSize: 10.rw),
            )
          ],
        ),
      ),
    );
  }

  _bottomBar() {
    return WholesaleDetailBottomBar(
      isWholesale: true,
      goodsDetail: _goodsDetail,
      controller: _bottomBarController,
      collected: _goodsDetail == null ? false : _goodsDetail!.isFavorite,
      // shopCartNum: _goodsDetail == null
      //     ? ''
      //     : _goodsDetail.shoppingTrolleyCount > 99
      //         ? "99+"
      //         : _goodsDetail.shoppingTrolleyCount == 0
      //             ? ""
      //             : _goodsDetail.shoppingTrolleyCount.toString(),
      addToShopCartListener: () {
        Get.to(() => WholesaleCarPage(
              canBack: true,
            ));
      },
      collectListener: (bool favorite) {
        ///加入购物车
      },
      buyListener: () {
        _openSkuChoosePage.value = true;
      },
      shareListener: () {
        ///批发首页
        Get.offAll(() => TabBarWidget());
      },
    );
  }

  // Future<dynamic> _addToShoppingCart(
  //     BuildContext context, WholesaleSkuChooseModel skuModel) async {
  //   ResultData resultData = await _shoppingCartModelImpl.addToShoppingCart(
  //       UserManager.instance.user.info.id,
  //       skuModel.sku.id,
  //       skuModel.des,
  //       skuModel.num);
  //   if (!resultData.result) {
  //     ReToast.err(text: resultData.msg);
  //     Get.back();
  //     return;
  //   }
  //   BaseModel model = BaseModel.fromJson(resultData.data);
  //   if (model.code != HttpStatus.SUCCESS) {
  //     Toast.showError(model.msg);
  //     Get.back();
  //     return;
  //   }
  //   UserManager.instance.refreshShoppingCart.value = true;
  //   UserManager.instance.refreshShoppingCartNumber.value = true;
  //   UserManager.instance.refreshShoppingCartNumberWithPage.value = true;
  //   ReToast.success(text: '加入成功');
  //   Get.back();
  //   Get.back();
  // }

  _showShare(BuildContext context) {
    // if (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Vip ||
    //     UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.None) {
    //   //跳到分享邀请
    //   // _showInviteShare(context);
    //   ShareTool().inviteShare(context);
    //   return;
    // }
    String goodsTitle =
        "${_goodsDetail!.getPriceString()} | ${_goodsDetail!.goodsName} | ${_goodsDetail!.description}";
    ShareTool().goodsShare(context,
        goodsPrice: _goodsDetail!.getPriceString(),
        miniTitle: goodsTitle,
        goodsName: _goodsDetail!.goodsName,
        goodsDescription: _goodsDetail!.description,
        miniPicurl: _goodsDetail!.mainPhotos!.length > 0
            ? _goodsDetail!.mainPhotos![0].url
            : "",
        goodsId: _goodsDetail!.id.toString(),
        amount: _goodsDetail!.price!.min!.commission! > 0
            ? _goodsDetail!.price!.min!.commission.toString()
            : "");
  }

  _getDetail() async {
    _goodsDetail = await WholesaleFunc.getDetailInfo(
        _goodsId, UserManager.instance!.user.info!.id);

    _bottomBarController!.setFavorite(_goodsDetail!.isFavorite);
    if (mounted) {
      setState(() {});
    }
  }

  _addFavorite() async {
    HttpResultModel<BaseModel?> resultModel =
        await GoodsDetailModelImpl.favoriteAdd(
            UserManager.instance!.user.info!.id, _goodsDetail!.id as int?);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    _bottomBarController!.setFavorite(true);
  }

  _cancelFavorite() async {
    HttpResultModel<BaseModel?> resultModel =
        await GoodsDetailModelImpl.favoriteCancel(
            UserManager.instance!.user.info!.id, _goodsDetail!.id as int?);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    _bottomBarController!.setFavorite(false);
  }
}
