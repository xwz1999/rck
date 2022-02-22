
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/base_model.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_detail_model_impl.dart';
import 'package:jingyaoyun/pages/home/widget/modify_detail_app_bar.dart';
import 'package:jingyaoyun/pages/home/widget/modify_detail_bottom_bar.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_car_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_customer_page.dart';
import 'package:jingyaoyun/pages/wholesale/wholesale_goods_page.dart';
import 'package:jingyaoyun/utils/share_tool.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/custom_floating_action_button_location.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:jingyaoyun/widgets/progress/re_toast.dart';
import 'package:jingyaoyun/widgets/toast.dart';

import 'Wholesale_modify_detail_bottom_bar.dart';
import 'func/wholesale_func.dart';
import 'models/wholesale_customer_model.dart';
import 'models/wholesale_detail_model.dart';

class WholesaleDetailPage extends StatefulWidget {
  final int goodsId;
  final bool isWholesale;

  const WholesaleDetailPage({
    Key key, this.isWholesale, this.goodsId,
  }) : super(key: key);

  static setArguments(int goodsID,) {
    return {"goodsID": goodsID, };
  }

  @override
  State<StatefulWidget> createState() {
    return _WholesaleDetailPageState();
  }
}

class _WholesaleDetailPageState extends BaseStoreState<WholesaleDetailPage>
    with TickerProviderStateMixin {

  AppBarController _appBarController;
  BottomBarController _bottomBarController;
  ValueNotifier<bool> _openSkuChoosePage = ValueNotifier(false);
  int _goodsId;
  WholesaleDetailModel _goodsDetail;
  bool isWholesale = false;///是否为批发状态 默认不是

  @override
  void initState() {
    super.initState();
    _goodsId = widget.goodsId;

    _appBarController = AppBarController();
    _bottomBarController = BottomBarController();
    if(widget.isWholesale!=null){
      isWholesale = widget.isWholesale;
    }

    _getDetail();

    UserManager.instance.refreshGoodsDetailPromotionState
        .addListener(_refreshPromotionState);
  }

  _refreshPromotionState() {
    _getDetail();
  }

  @override
  void dispose() {

    _bottomBarController?.dispose();
    _appBarController?.dispose();

    UserManager.instance.refreshGoodsDetailPromotionState
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
      floatingActionButtonLocation:CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endDocked, 0, -80.rw),
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
                      child:
                            _goodsDetail!=null?
                            WholesaleGoodsPage(

                              goodsId: _goodsId,
                              openSkuChoosePage: _openSkuChoosePage,
                              goodsDetail: _goodsDetail,
                              isWholesale: true,
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

                            ):SizedBox(),
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


  _customer(){
    return GestureDetector(
      onTap: () async{
        WholesaleCustomerModel model = await
        WholesaleFunc.getCustomerInfo();

        Get.to(()=>WholesaleCustomerPage(model: model,));


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
            Image.asset(R.ASSETS_WHOLESALE_WHOLESALE_CUSTOMER_PNG,width: 20.rw,height: 20.rw,),
            5.hb,
            Text('客服',style: TextStyle(color: Colors.white,fontSize: 10.rw),)
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
      collected: _goodsDetail == null ? false : _goodsDetail.isFavorite,
      // shopCartNum: _goodsDetail == null
      //     ? ''
      //     : _goodsDetail.shoppingTrolleyCount > 99
      //         ? "99+"
      //         : _goodsDetail.shoppingTrolleyCount == 0
      //             ? ""
      //             : _goodsDetail.shoppingTrolleyCount.toString(),
      addToShopCartListener: () {
        Get.to(()=>WholesaleCarPage(canBack: true,));
      },
      collectListener: (bool favorite) {
        ///加入购物车

      },
      buyListener: () {
        _openSkuChoosePage.value = true;

      },
      shareListener: () {
        ///批发首页
        Get.back();
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
        "${_goodsDetail.getPriceString()} | ${_goodsDetail.goodsName} | ${_goodsDetail.description}";
    ShareTool().goodsShare(context,
        goodsPrice: _goodsDetail.getPriceString(),
        miniTitle: goodsTitle,
        goodsName: _goodsDetail.goodsName,
        goodsDescription: _goodsDetail.description,
        miniPicurl: _goodsDetail.mainPhotos.length > 0
            ? _goodsDetail.mainPhotos[0].url
            : "",
        goodsId: _goodsDetail.id.toString(),
        amount: _goodsDetail.price.min.commission > 0
            ? _goodsDetail.price.min.commission.toString()
            : "");
  }

  _getDetail() async {
    _goodsDetail = await WholesaleFunc.getDetailInfo(
        _goodsId, UserManager.instance.user.info.id);

    _bottomBarController.setFavorite(_goodsDetail.isFavorite);
    if(mounted){
      setState(() {});
    }

  }

  _addFavorite() async {
    HttpResultModel<BaseModel> resultModel =
        await GoodsDetailModelImpl.favoriteAdd(
            UserManager.instance.user.info.id, _goodsDetail.id);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    _bottomBarController.setFavorite(true);
  }

  _cancelFavorite() async {
    HttpResultModel<BaseModel> resultModel =
        await GoodsDetailModelImpl.favoriteCancel(
            UserManager.instance.user.info.id, _goodsDetail.id);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg);
      return;
    }
    _bottomBarController.setFavorite(false);
  }


}
