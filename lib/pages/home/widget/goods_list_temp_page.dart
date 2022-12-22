import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/goods_hot_sell_list_model.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/wholesale/more_goods/whoesale_goods_normal.dart';
import 'package:recook/widgets/goods_item.dart';

enum GoodsListTempType { recookMake, homeAppliances, homeLife ,highCommission,preferential }//瑞库制品  数码家电 家居生活  高佣特推 特惠专区

class GoodsListTempPage extends StatefulWidget {
  final Map? arguments;

  const GoodsListTempPage({Key? key, this.arguments}) : super(key: key);
  static setArguments(
      {String? title, GoodsListTempType type = GoodsListTempType.recookMake}) {
    return {"title": title, "type": type};
  }

  @override
  State<StatefulWidget> createState() {
    return _GoodsListTempPageState();
  }
}

class _GoodsListTempPageState extends BaseStoreState<GoodsListTempPage> with TickerProviderStateMixin {
  GoodsHotSellListModel? _listModel;
  // String? _title;
  GoodsListTempType? _goodsListTempType;
  @override
  void initState() {
    super.initState();
    _goodsListTempType = widget.arguments!["type"];
    //_title = widget.arguments!['title'];
    _getGoodsHotSellList();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    Scaffold scaffold = Scaffold(
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        body: SafeArea(
          top: false,
          bottom: false,
          child: _listModel == null ? Container() : _bodyWidget(),
        ));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: scaffold,
    );
  }

  _bodyWidget() {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: _titleWidget(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.width / 1125 * 350,
            child: _listModel == null ? Container() : _listWidget(),
          )
        ],
      ),
    );
  }

  _titleWidget() {
    //1125 603
    double width = MediaQuery.of(context).size.width;
    double height = width / 1125 * 603;
    return Container(
        width: width,
        height: height,
        child: Stack(
          children: <Widget>[
            Image.asset(
              _goodsListTempType == GoodsListTempType.recookMake
                  ? R.ASSETS_LIST_TEMP_MARKET_TITLE_BG_WEBP
                  : _goodsListTempType == GoodsListTempType.homeAppliances
                      ? R.ASSETS_LIST_TEMP_HOME_APP_BG_WEBP
                      : R.ASSETS_LIST_TEMP_HOME_LIFE_TITLE_WEBP,
              fit: BoxFit.fill,
            ),
            Positioned(
              top: ScreenUtil().statusBarHeight + (kToolbarHeight - 24) / 2,
              left: (ScreenUtil().screenWidth - 117) / 2,
              child: Container(
                width: 117,
                height: 24,
                child: Image.asset(
                    _goodsListTempType == GoodsListTempType.recookMake
                        ? "assets/listtemp_recookmaketitle.png"
                        : _goodsListTempType == GoodsListTempType.homeAppliances
                            ? "assets/listtemp_homeappliances.png"
                            : "assets/listtemp_homelifetitle.png"),
              ),
            ),
            Positioned(
              child: _backButton(context),
              left: 0,
              top: ScreenUtil().statusBarHeight,
            )
          ],
        ));
  }

  _backButton(context) {
    Widget? lead;
    if (Navigator.canPop(context)) {
      lead = IconButton(
          icon: Icon(
            AppIcons.icon_back,
            size: 17,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          });
    }
    return lead;
  }

  _listWidget() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(
            left: 0, top: 0, right: 0, bottom: ScreenUtil().bottomBarHeight),
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              AppRouter.push(context, RouteName.COMMODITY_PAGE,
                  arguments: CommodityDetailPage.setArguments(
                      _listModel!.data![index].id));
            },
            child: _itemWidget(_listModel!.data![index]),
          );
        },
        itemCount: _listModel!.data!.length,
      ),
    );
  }

  _itemWidget(Data data) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      constraints: BoxConstraints(minWidth: 150),
      child: Stack(
        children: <Widget>[

          UserManager.instance!.isWholesale?
          WholesaleGoodsItem.hotList(
            buildCtx: context,
            data: data,
          ):
          GoodsItemWidget.hotList(
            gifController: GifController(vsync: this)
              ..repeat(
                min: 0,
                max: 20,
                period: Duration(milliseconds: 700),
              ),
            onBrandClick: () {
              AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                  arguments: BrandGoodsListPage.setArguments(
                      data.brandId as int?, data.brandName));
            },
            buildCtx: context,
            data: data,
          ),
        ],
      ),
    );
  }

  _getGoodsHotSellList() async {
    Map<String, dynamic> data = {};
    if (UserManager.instance!.isWholesale) {
      data.putIfAbsent('is_sale', () => true);
    }

    ResultData resultData = await HttpManager.post(
        _goodsListTempType == GoodsListTempType.recookMake
            ? HomeApi.recook_make
            : _goodsListTempType == GoodsListTempType.homeAppliances
                ? HomeApi.digital_list
                : HomeApi.home_live_list,
        data);
    if (!resultData.result) {
      showError(resultData.msg??'');
      return;
    }
    GoodsHotSellListModel model =
        GoodsHotSellListModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      showError(model.msg??'');
      return;
    }
    for (Data data in model.data!) {
      data.index = model.data!.indexOf(data);
    }
    _listModel = model;
    setState(() {});
  }
}
