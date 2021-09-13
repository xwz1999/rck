/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  5:35 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/category_model.dart';
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
import 'mvp/goods_list_contact.dart';
import 'mvp/goods_list_presenter_impl.dart';

class GoodsListPage extends StatefulWidget {
  // final SecondCategory category;
  final Map arguments;

  const GoodsListPage({Key key, this.arguments}) : super(key: key);

  static setArguments(
      {String title,
      int index,
      List<SecondCategory> secondCategoryList,
      bool isJD = false}) {
    return {
      "title": title,
      "index": index,
      "secondCategoryList": secondCategoryList,
      'isJD': isJD
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _GoodsListPageState();
  }
}

class _GoodsListPageState extends BaseStoreState<GoodsListPage>
    with MvpListViewDelegate<GoodsSimple>, TickerProviderStateMixin {
  /// 切换展示形式  true 为 List， false 为grid
  bool _displayList = true;

  FilterToolBarController _filterController;

  SecondCategory _category;
  List<SecondCategory> _secondCategoryList;
  GoodsListPresenterImpl _presenter;
  TabController _tabController;

  MvpListViewController<GoodsSimple> _listViewController;

  SortType _sortType = SortType.comprehensive;

  int _jDType = 0; // 0 默认数据 1传回全部JD数据 2为JD自营数据 3为JD pop数据
  bool _isJD = false;
  String _jdTypeText = '全部';
  int _filterIndex = 0;
  List<bool> _barBool = [false,false,false];
  GifController _gifController;

  @override
  void initState() {
    if (widget.arguments['isJD'] != null) {
      _isJD = widget.arguments['isJD'];
    }
    if (_isJD) {
      _jDType = 1;
      _sortType = SortType.priceAsc;
      _barBool = [false,false];
    }
    int index = widget.arguments["index"];
    _gifController = GifController(vsync: this)
      ..repeat(
        min: 0,
        max: 20,
        period: Duration(milliseconds: 700),
      );
    DPrint.printf("index=$index");
    _secondCategoryList = widget.arguments["secondCategoryList"];
    _category = _secondCategoryList[index];
    _tabController = TabController(
        initialIndex: index, length: _secondCategoryList.length, vsync: this);
    _filterController = FilterToolBarController();
    super.initState();
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
          title: widget.arguments["title"],
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
              height: 10,
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
      titles: _isJD
          ? [

              FilterItemModel(type: FilterItemType.double, title: "价格",selectedList:_barBool),
              FilterItemModel(type: FilterItemType.double, title: "销量",selectedList:_barBool),
//        FilterItemModel(type: FilterItemType.normal, title: "特卖优先")
            ]
          : [
              FilterItemModel(type: FilterItemType.normal, title: "综合",selectedList:_barBool),
              FilterItemModel(type: FilterItemType.double, title: "价格",selectedList:_barBool),
              FilterItemModel(type: FilterItemType.double, title: "销量",selectedList:_barBool),
//        FilterItemModel(type: FilterItemType.normal, title: "特卖优先")
            ],
      trialing: _displayIcon(),
      startWidget: _jdTypeWidget(),
      selectedColor: Theme.of(context).primaryColor,
      listener: (index, item) {
        print(index);
        if(!_isJD){
          if ((index != 1 && index != 2) && _filterIndex == index) {
          return;
          }
        }else{
        if ((index != 1 && index != 2&& index != 0) && _filterIndex == index) {
          return;
        }
      }

        // if (index != 1 && _filterIndex == index) {
        //   return;
        // }
        _filterIndex = index;
        if (_isJD) {
          switch (index) {
            case 0:
            print(item.topSelected);
              if (item.topSelected) {
                _sortType = SortType.priceAsc;
              } else {
                _sortType = SortType.priceDesc;
              }
              break;
            case 1:
              print(item.topSelected);
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
        } else {
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

  Widget _jdTypeWidget() {
    return PopupMenuButton(
        offset: Offset(0, 10),
        color: Colors.white,
        child: Row(
          children: [
            Text(_jdTypeText,
                style: TextStyle(
                  fontSize: 14.rsp,
                  color: Color(0xFFD5101A),
                )),
            Icon(
              Icons.arrow_drop_down,
              color: Color(0xFFD5101A),
            ),
          ],
        ),
        onSelected: (String value) {
          setState(() {
            _jdTypeText = value;
            if (value == '全部') {
              _jDType = 1;
            } else if (value == '京东自营') {
              _jDType = 2;
            } else if (value == '京东POP') {
              _jDType = 3;
            }
            print(value);
            setState(() {});
            _listViewController.stopRefresh();
            _listViewController.requestRefresh();
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem(
                  value: "全部",
                  child: Text("全部",
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      ))),
              PopupMenuItem(
                  value: "京东自营",
                  child: Text("京东自营",
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      ))),
              PopupMenuItem(
                  value: "京东POP",
                  child: Text("京东POP",
                      style: TextStyle(
                        fontSize: 14.rsp,
                        color: Color(0xFF333333),
                      ))),
            ]);
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
        _presenter.fetchList(_category.id, 0, _sortType, null, JDType: _jDType);
        setState(() {

        });
      },
      loadMoreCallback: (int page) {
        // _presenter.fetchList(widget.category.id, page, _sortType);
        _presenter.fetchList(_category.id, page, _sortType, null,
            JDType: _jDType);
        setState(() {

        });
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
                      type: _isJD?3:0,
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
