import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/brandgoods_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/items/item_brand_like_grid.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/goods_item.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'function/shopping_cart_fuc.dart';

class SimilarGoodsPage extends StatefulWidget {
  final int goodsId;
  //final List<GoodsSimple> similarGoodsList;
  const SimilarGoodsPage({Key key, this.goodsId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SimilarGoodsPageState();
  }
}

class _SimilarGoodsPageState extends BaseStoreState<SimilarGoodsPage> with TickerProviderStateMixin {
  GoodsSimpleListModel goodsSimpleListModel;
  List<GoodsSimple> _likeGoodsList = [];
  List<GoodsSimple> _similarGoodsList = [];
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  @override
  void initState() {
    super.initState();
    //_similarGoodsList = widget.similarGoodsList;
    Future.delayed(Duration.zero, () async {
      int userid;
      if (UserManager.instance.user.info.id == null) {
        userid = 0;
      } else {
        userid = UserManager.instance.user.info.id;
      }
      _likeGoodsList = await ShoppingCartFuc.getLikeGoodsList(userid);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.tableViewGrayColor,
      appBar: CustomAppBar(
        appBackground: Color(0xFFC92219),
        elevation: 0,
        leading: RecookBackButton(white: true),
        title: Text(
          '找相似',
          style: TextStyle(fontSize: 18.rsp, color: Colors.white),
        ),
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _buildList(),
    );
  }

  _buildLikeTitle() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22.rw,
            height: 2.rw,
            decoration: BoxDecoration(color: Color(0xFFC92219)),
          ),
          Container(
            width: 6.rw,
            height: 6.rw,
            decoration: BoxDecoration(
                color: Color(0xFFC92219),
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
          ),
          20.wb,
          Text(
            '您可能还喜欢',
            style: TextStyle(color: Color(0xFFC92219), fontSize: 14.rsp),
          ),
          20.wb,
          Container(
            width: 6.rw,
            height: 6.rw,
            decoration: BoxDecoration(
                color: Color(0xFFC92219),
                borderRadius: BorderRadius.all(Radius.circular(6.rw))),
          ),
          Container(
            width: 22.rw,
            height: 2.rw,
            decoration: BoxDecoration(color: Color(0xFFC92219)),
          ),
        ],
      ),
    );
  }

  _buildLikeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.rw),
      height: _likeGoodsList?.length * 378.rw / 2,
      width: double.infinity,
      child: Column(
        children: [
          35.hb,
          _buildLikeTitle(),
          50.hb,
          WaterfallFlow.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight),
              physics: NeverScrollableScrollPhysics(),
              itemCount: _likeGoodsList?.length,
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                GoodsSimple goods = _likeGoodsList[index];

                return MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      AppRouter.push(context, RouteName.COMMODITY_PAGE,
                          arguments:
                              CommodityDetailPage.setArguments(goods.id));
                    },
                    child: BrandLikeGridItem(
                      goods: goods,
                      onBrandClick: () {
                        AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                            arguments: BrandGoodsListPage.setArguments(
                                goods.brandId, goods.brandName));
                      },
                    ));
              }),
          40.hb,
          Container(
            alignment: Alignment.center,
            child: Text(
              '已经到底啦~',
              style: TextStyle(color: Color(0xFF999999), fontSize: 14.rsp),
            ),
          ),
        ],
      ),
    );
  }

  _buildExtraItem(GoodsSimple goods, int index) {
    return Column(
      children: [
        MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              AppRouter.push(context, RouteName.COMMODITY_PAGE,
                  arguments: CommodityDetailPage.setArguments(goods.id));
            },
            child: GoodsItemWidget.normalGoodsItem(
              gifController: GifController(vsync: this)
                ..repeat(
                  min: 0,
                  max: 20,
                  period: Duration(milliseconds: 700),
                ),
              onBrandClick: () {
                AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                    arguments: BrandGoodsListPage.setArguments(
                        goods.brandId, goods.brandName));
              },
              buildCtx: context,
              model: goods,
              type: 4,
            )),
        _likeGoodsList != null ? _buildLikeWidget() : SizedBox(),
      ],
    );
  }

  _buildList() {
    return RefreshWidget(
      controller: _refreshController,
      //noData: '抱歉，没有找相似商品',
      noDataText: '抱歉，没有到找相似商品',
      onRefresh: () async {
        //Function cancel = ReToast.loading();
        if (_similarGoodsList.isNotEmpty) {
          _similarGoodsList = [];
        }

        _similarGoodsList =
            await ShoppingCartFuc.getSimilarGoodsList(widget.goodsId);

        setState(() {});
        _refreshController.refreshCompleted();
        //cancel();
      },
      body: _similarGoodsList.isNotEmpty
          ? _buildSimilarList()
          : noDataView('抱歉，没有到找相似商品'),
      //
    );
  }

  noDataView(String text, {Widget icon}) {
    return ListView(
      //height: double.infinity,
      children: <Widget>[
        100.hb,
        icon ??
            Image.asset(
              R.ASSETS_NODATA_PNG,
              width: rSize(80),
              height: rSize(80),
            ),
//          Icon(AppIcons.icon_no_data_search,size: rSize(80),color: Colors.grey),
        SizedBox(
          height: 8,
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            text,
            style: AppTextStyle.generate(14 * 2.sp, color: Colors.grey),
          ),
        ),

        SizedBox(
          height: rSize(30),
        ),
        _buildLikeWidget(),
      ],
    );
  }

  _buildSimilarList() {
    return ListView.builder(
        //padding: EdgeInsets.only(bottom: 80.rw),
        padding: EdgeInsets.only(top: 10.rw),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _similarGoodsList?.length,
        itemBuilder: (context, index) {
          GoodsSimple goods = _similarGoodsList[index];
          return index != _similarGoodsList.length - 1
              ? MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    AppRouter.push(context, RouteName.COMMODITY_PAGE,
                        arguments: CommodityDetailPage.setArguments(goods.id));
                  },
                  child: GoodsItemWidget.normalGoodsItem(
                    gifController: GifController(vsync: this)
                      ..repeat(
                        min: 0,
                        max: 20,
                        period: Duration(milliseconds: 700),
                      ),
                    onBrandClick: () {
                      AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                          arguments: BrandGoodsListPage.setArguments(
                              goods.brandId, goods.brandName));
                    },
                    buildCtx: context,
                    model: goods,
                    type: 4,
                  ))
              : _buildExtraItem(_similarGoodsList[index], index);
        });
  }
}
