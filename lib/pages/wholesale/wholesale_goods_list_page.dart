import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/models/goods_simple_list_model.dart';
import 'package:jingyaoyun/pages/home/classify/brandgoods_list_page.dart';
import 'package:jingyaoyun/pages/home/classify/commodity_detail_page.dart';
import 'package:jingyaoyun/pages/home/classify/mvp/goods_list_contact.dart';
import 'package:jingyaoyun/pages/home/items/item_brand_detail_grid.dart';
import 'package:jingyaoyun/pages/wholesale/wholeasale_detail_page.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/filter_tool_bar.dart';
import 'package:jingyaoyun/widgets/goods_item.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'func/wholesale_func.dart';
import 'models/wholesale_good_model.dart';
import 'more_goods/whoesale_goods_grid.dart';
import 'more_goods/whoesale_goods_normal.dart';

class WholesaleGoodsList extends StatefulWidget {
  final String title;
  final int activityId;

  const WholesaleGoodsList(
      {Key key,
      this.title,
      this.activityId,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WholesaleGoodsListState();
  }
}

class _WholesaleGoodsListState extends BaseStoreState<WholesaleGoodsList>
    with TickerProviderStateMixin {
  /// 切换展示形式  true 为 List， false 为grid
  bool _displayList = false;//默认排列方式改为瀑布流

  FilterToolBarController _filterController;


  SortType _sortType = SortType.comprehensive;
  GSRefreshController _refreshController;
  int _filterIndex = 0;
  List<bool> _barBool = [false,false,false];
  GifController _gifController;

  ///商品列表
  List<WholesaleGood> _goodsList = [];

  int _page = 0;
  bool isNodata = false;


  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );

    _filterController = FilterToolBarController();
    _refreshController = GSRefreshController(initialRefresh: true);

  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
        backgroundColor: AppColor.frenchColor,
        appBar: CustomAppBar(
          themeData: AppThemes.themeDataGrey.appBarTheme,
          elevation: 0,
          title: widget.title,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: FilterToolBarResultContainer(
                controller: _filterController,
                body: Column(
                  children: <Widget>[
                    _filterToolBar(context),
                    // Container(
                    //   color: AppColor.frenchColor,
                    //   height: 5,
                    // ),
                    Expanded(child:  _buildList(), )
                  ],
                ),
              ),
            )
          ],
        ));
  }


  _filterToolBar(BuildContext context) {
    return FilterToolBar(
      controller: _filterController,
      height: rSize(40),
      fontSize: 13 * 2.sp,
      titles: [
        FilterItemModel(type: FilterItemType.normal, title: "综合",selectedList:_barBool),
        FilterItemModel(type: FilterItemType.double, title: "价格",selectedList:_barBool),
        FilterItemModel(type: FilterItemType.double, title: "销量",selectedList:_barBool),
//        FilterItemModel(type: FilterItemType.normal, title: "特卖优先")
      ],
      trialing: _displayIcon(),
      selectedColor: Theme.of(context).primaryColor,
      listener: (index, item) {
        if ((index != 1 && index != 2) && _filterIndex == index) {
          return;
        }
        _filterIndex = index;
        switch (index) {
          case 0:
            _sortType = SortType.comprehensive;
            break;
          case 1:
            if (item.topSelected) {
              _sortType = SortType.priceAsc;
            } else {
              _sortType = SortType.priceDesc;
            }
            break;
          case 2:
            if (item.topSelected) {
              _sortType = SortType.salesAsc;
            } else {
              _sortType = SortType.salesDesc;
            }
            // _sortType = SortType.sales;
            break;

        }
        _refreshController.requestRefresh();

      },
    );
  }

  /// 切换排列按钮
  Container _displayIcon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _displayList = !_displayList;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 1,
              height: 15,
              margin: EdgeInsets.only(right: 8),
              color: Colors.grey[700],
            ),
            Text(
              "排列",
              style: AppTextStyle.generate(13 * 2.sp,
                  color: Colors.grey[700], fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Icon(
                _displayList
                    ? AppIcons.icon_list_collection
                    : AppIcons.icon_list_normal,
                color: Colors.grey[700],
                size: 20 * 2.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildList(){
     return RefreshWidget(
           controller: _refreshController,
           onRefresh: () async {
             _page = 0;
             WholesaleFunc.getGoodsList(_page,_sortType,activity_id: widget.activityId,).then((value) {
               _goodsList = value;
               if(_goodsList.isEmpty){
                 isNodata = true;
               }else{
                 isNodata = false;
               }

               if (mounted) {
                 setState(() {});
               }
               // if (value.isEmpty)
               //   _refreshController.isNoData;
               // else
                 _refreshController.refreshCompleted();
             });

           },
           onLoadMore: () async{
             _page++;
             WholesaleFunc.getGoodsList(_page,_sortType,activity_id: widget.activityId,).then((value) {
               _goodsList.addAll(value);
               setState(() {

               });
               if (value.isEmpty)
                 _refreshController.loadNoData();
               else
                 _refreshController.loadComplete();
             });
           },
           body: isNodata? noDataView('没有找到商品哦~'):

           _buildGridView(),

     );
  }

  _buildGridView() {
    return WaterfallFlow.builder(
        padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _goodsList.length,
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: _displayList ? 1 : 2,
          crossAxisSpacing: _displayList ? 5 : 7,
          mainAxisSpacing: _displayList ? 0 : 0,
        ),
        itemBuilder: (context, index) {

          return _goodsList.isNotEmpty?MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.to(()=>WholesaleDetailPage(goodsId: _goodsList[index].id,isWholesale: true,));
              },
              child: _displayList
                  // ? BrandDetailListItem(goods: goods)
                  ? WholesaleGoodsItem.normalGoodsItem(
                model: _goodsList[index],
                buildCtx: context,
              ) : WholesaleGoodsGrid(goods: _goodsList[index])):SizedBox();
        });
  }

}
