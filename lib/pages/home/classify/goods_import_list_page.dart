/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  5:35 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/category_list_model.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/home/classify/brandgoods_list_page.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/items/item_brand_detail_grid.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/filter_tool_bar.dart';
import 'package:recook/widgets/goods_item.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'mvp/goods_list_contact.dart';
import 'mvp/goods_list_presenter_impl.dart';

class GoodsImportListPage extends StatefulWidget {
  final String title;
  final int index;
  final int countryId;
  final List<First> secondCategoryList;
  const GoodsImportListPage(
      {Key key,
      this.title,
      this.index,
      this.secondCategoryList,
      this.countryId})
      : super(key: key);

  // static setArguments(
  //     {String title, int index, List<Country> secondCategoryList}) {
  //   return {
  //     "title": title,
  //     "index": index,
  //     "secondCategoryList": secondCategoryList
  //   };
  //}

  @override
  State<StatefulWidget> createState() {
    return _GoodsImportListPageState();
  }
}

class _GoodsImportListPageState extends BaseStoreState<GoodsImportListPage>
    with MvpListViewDelegate<GoodsSimple>, TickerProviderStateMixin {
  /// 切换展示形式  true 为 List， false 为grid
  bool _displayList = false;//默认排列方式改为瀑布流

  FilterToolBarController _filterController;

  First _category;
  List<First> _secondCategoryList;
  GoodsListPresenterImpl _presenter;
  TabController _tabController;

  MvpListViewController<GoodsSimple> _listViewController;

  SortType _sortType = SortType.comprehensive;

  int _filterIndex = 0;
  List<bool> _barBool = [false,false,false];
  GifController _gifController;
  TextEditingController _textEditController;
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
    int index = widget.index;
    //DPrint.printf("index=$index");
    _secondCategoryList = widget.secondCategoryList;
    print(_secondCategoryList);
    _category = _secondCategoryList[index];
    _tabController = TabController(
        initialIndex: index, length: _secondCategoryList.length, vsync: this);
    _filterController = FilterToolBarController();

    _presenter = GoodsListPresenterImpl();
    _listViewController = MvpListViewController();
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
            Container(
              height: 34,
              alignment: Alignment.center,
              color: AppThemes.themeDataGrey.appBarTheme.color,
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                  onTap: (index) {
                    _category = _secondCategoryList[index];
                    _listViewController.stopRefresh();
                    _listViewController.requestRefresh();
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
                    Expanded(child: _buildList(context))
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

  _tabItem(First secondCategory, int index) {
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
                  _presenter.fetchList(_category.id, 0, _sortType, widget.countryId,keyword: _searchText);

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
        // if (index != 1 && _filterIndex == index) {
        //   return;
        // }
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
//          case 3:
//            print("特卖优先");
//            break;
        }
        // _presenter.fetchList(widget.category.id, 0, _sortType);
        // _presenter.fetchList(_category.id, 0, _sortType);
        _listViewController.stopRefresh();
        _listViewController.requestRefresh();
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

  _buildList(BuildContext context) {
    return MvpListView<GoodsSimple>(
      delegate: this,
      noDataView: noDataView("没有找到商品!"),
//      padding: EdgeInsets.all(_displayList ? 0 : 10.0),
      controller: _listViewController,
      type: ListViewType.grid,
      refreshCallback: () {
        // _presenter.fetchList(widget.category.id, 0, _sortType);
        _presenter.fetchList(_category.id, 0, _sortType, widget.countryId);
      },
      loadMoreCallback: (int page) {
        // _presenter.fetchList(widget.category.id, page, _sortType);
        _presenter.fetchList(_category.id, page, _sortType, widget.countryId);
      },
      gridViewBuilder: () => _buildGridView(),
    );
  }

  _buildGridView() {
    // return WaterfallFlow.builder(

    //       itemBuilder: ,
    // );
    return WaterfallFlow.builder(
        padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _listViewController.getData().length,
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: _displayList ? 1 : 2,
          crossAxisSpacing: _displayList ? 5 : 10,
          mainAxisSpacing: _displayList ? 5 : 10,
        ),
        itemBuilder: (context, index) {
          GoodsSimple goods = _listViewController.getData()[index];
          // goods.inventory = 0;
          // goods.tags = ["新人特惠", "限时特卖", "限时特卖", "限时特卖", "限时特卖"];
          return MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                AppRouter.push(context, RouteName.COMMODITY_PAGE,
                    arguments: CommodityDetailPage.setArguments(goods.id));
              },
              child: _displayList
                  // ? BrandDetailListItem(goods: goods)
                  ? GoodsItemWidget.normalGoodsItem(
                gifController: _gifController,
                      onBrandClick: () {
                        AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                            arguments: BrandGoodsListPage.setArguments(
                                goods.brandId, goods.brandName));
                      },
                      model: goods,
                      buildCtx: context,
                    )
                  // ? NormalGoodsItem(model: goods, buildCtx: context,)
                  : BrandDetailGridItem(goods: goods));
        });
  }

  @override
  MvpListViewPresenterI<GoodsSimple, MvpView, MvpModel> getPresenter() {
    return _presenter;
  }
}
