import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/category_model.dart';
import 'package:recook/pages/home/classify/mvp/goods_list_contact.dart';
import 'package:recook/pages/wholesale/wholeasale_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/filter_tool_bar.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'func/wholesale_func.dart';
import 'models/wholesale_good_model.dart';
import 'more_goods/whoesale_goods_grid.dart';
import 'more_goods/whoesale_goods_normal.dart';

class WholesaleGoodsList extends StatefulWidget {
  final String title;
  final int index;
  final List<SecondCategory> secondCategoryList;
   WholesaleGoodsList(
      {Key key,
      this.title, this.index, this.secondCategoryList,})
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
  SecondCategory _category;
  FilterToolBarController _filterController;
  List<SecondCategory> _secondCategoryList;
  TextEditingController _textEditController;
  SortType _sortType = SortType.comprehensive;
  GSRefreshController _refreshController;
  int _filterIndex = 0;
  List<bool> _barBool = [false,false,false];
  GifController _gifController;
  TabController _tabController;
  ///商品列表
  List<WholesaleGood> _goodsList = [];

  int _page = 0;
  bool isNodata = false;
  String _searchText = '';

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

    _secondCategoryList = widget.secondCategoryList;
    _category = _secondCategoryList[widget.index];
    _tabController = TabController(
        initialIndex: widget.index, length: _secondCategoryList.length, vsync: this);

  }

  @override
  void dispose() {
    _gifController.dispose();
    _textEditController.dispose();
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
            Container(
              height: 34,
              alignment: Alignment.center,
              color: AppThemes.themeDataGrey.appBarTheme.color,
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                  onTap: (index) {
                    _category = _secondCategoryList[index];
                    _refreshController.requestRefresh();
                    // _presenter.fetchList(_category.id, 0, _sortType);
                    setState(() {});
                  },
                  isScrollable: true,
                  labelPadding: EdgeInsets.all(0),
                  controller: _tabController,
                  labelColor: getCurrentThemeColor(),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: rSize(15)),
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: TextStyle(color: Colors.black54),
                  indicatorColor: getCurrentThemeColor(),
                  tabs: _tabItems()),
            ),
            Container(
              color: AppColor.frenchColor,
              height: 5,
            ),
            _buildTitle(),
            Container(
              color: AppColor.frenchColor,
              height: 5,
            ),


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


  List<Widget> _tabItems() {
    return _secondCategoryList.map<Widget>((item) {
      int index = _secondCategoryList.indexOf(item);
      return _tabItem(item, index);
    }).toList();
  }


  Widget _buildTitle() {
    return Container(
      // margin: EdgeInsets.only(right: rSize(10)),
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.search,
                size: 20,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                //autofocus: true,
                keyboardType: TextInputType.text,
                controller: _textEditController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_submitted) {
                  //_contentFocusNode.unfocus();

                  _refreshController.requestRefresh();

                  setState(() {});
                },
                //focusNode: _contentFocusNode,
                onChanged: (text) async {
                  _searchText = text;

                },
                placeholder: "请输入想要搜索的商品",
                placeholderStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
                decoration: BoxDecoration(color: Colors.white.withAlpha(0)),
                style: TextStyle(
                    color: Colors.black,
                    textBaseline: TextBaseline.ideographic),
              ),
            )
          ],
        ));
  }

  _tabItem(SecondCategory secondCategory, int index) {
    Color textColor = index == _tabController.index
        ? getCurrentThemeColor()
        : Colors.black.withOpacity(0.9);
    return Tab(
      child: Container(
        alignment: Alignment.center,
        // color: Colors.white,
        color: AppThemes.themeDataGrey.appBarTheme.color,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              secondCategory.name,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13 * 2.sp,
                  color: textColor),
            ),
          ],
        ),
      ),
    );
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
             _goodsList = [];
             WholesaleFunc.getGoodsList(_page,_sortType,categoryID: _category.id,keyword: _searchText).then((value) {
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
               // _refreshController.resetNoData();
             });
           },
           onLoadMore: () async{
             _page++;
             WholesaleFunc.getGoodsList(_page,_sortType,categoryID: _category.id,keyword: _searchText).then((value) {
               _goodsList.addAll(value);
               setState(() {
               });
               if (value.isEmpty)
                 _refreshController.loadNoData();
               else{
                 _refreshController.loadComplete();
               }
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
                Get.to(()=>WholesaleDetailPage(goodsId: _goodsList[index].id,));
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
