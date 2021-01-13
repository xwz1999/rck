/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/27  5:35 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_simple_list_model.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/items/item_brand_detail_grid.dart';
import 'package:recook/pages/home/items/item_tag_widget.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/filter_tool_bar.dart';
import 'package:recook/widgets/goods_item.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'mvp/goods_list_contact.dart';
import 'mvp/goods_list_presenter_impl.dart';

class BrandGoodsListPage extends StatefulWidget {
  // final int brandId;
  // final String brandName;
  final Map argument;

  const BrandGoodsListPage({Key key, this.argument}) : super(key: key);

  static setArguments(int brandId, String brandName) {
    return {"brandId": brandId, "brandName": brandName};
  }

  @override
  State<StatefulWidget> createState() {
    return _BrandGoodsListPageState();
  }
}

class _BrandGoodsListPageState extends BaseStoreState<BrandGoodsListPage>
    with MvpListViewDelegate<GoodsSimple> {
  /// 切换展示形式  true 为 List， false 为grid
  bool _displayList = true;

  FilterToolBarController _filterController;

  GoodsListPresenterImpl _brandPresenter;

  MvpListViewController<GoodsSimple> _brandListViewController;

  SortType _sortType = SortType.comprehensive;

  int _filterIndex = 0;

  @override
  void initState() {
    _filterController = FilterToolBarController();
    super.initState();
    _brandPresenter = GoodsListPresenterImpl();
    _brandListViewController = MvpListViewController();
    // _brandPresenter.fetchBrandList(widget.argument["brandId"], 0, SortType.comprehensive);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
        title: widget.argument["brandName"],
      ),
      body: FilterToolBarResultContainer(
        controller: _filterController,
        body: Column(
          children: <Widget>[
            _filterToolBar(context),
            Expanded(
              child: _buildList(context),
            )
          ],
        ),
      ),
    );
  }

  _filterToolBar(BuildContext context) {
    return FilterToolBar(
      controller: _filterController,
      height: rSize(40),
      fontSize: ScreenAdapterUtils.setSp(15),
      titles: [
        FilterItemModel(type: FilterItemType.normal, title: "综合"),
        FilterItemModel(type: FilterItemType.double, title: "价格"),
        FilterItemModel(type: FilterItemType.double, title: "销量"),
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
            break;
//          case 3:
//            print("特卖优先");
//            break;
        }
        _brandListViewController.stopRefresh();
        _brandListViewController.requestRefresh();
        // _brandPresenter.fetchBrandList(widget.argument["brandId"], 0, _sortType);
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
              style: AppTextStyle.generate(ScreenAdapterUtils.setSp(15),
                  color: Colors.grey[700], fontWeight: FontWeight.w300),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Icon(
                _displayList
                    ? AppIcons.icon_list_collection
                    : AppIcons.icon_list_normal,
                color: Colors.grey[700],
                size: ScreenAdapterUtils.setSp(20),
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
      controller: _brandListViewController,
      type: ListViewType.grid,
      refreshCallback: () {
        _brandPresenter.fetchBrandList(
            widget.argument["brandId"], 0, _sortType);
      },
      loadMoreCallback: (int page) {
        _brandPresenter.fetchBrandList(
            widget.argument["brandId"], page, _sortType);
      },
      gridViewBuilder: () => _buildGridView(),
      // gridViewBuilder:() => _buildGridView(),
    );
  }

  _buildGridView() {
    return WaterfallFlow.builder(
        padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _brandListViewController.getData().length,
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: _displayList ? 1 : 2,
          crossAxisSpacing: _displayList ? 5 : 10,
          mainAxisSpacing: _displayList ? 5 : 10,
        ),
        itemBuilder: (context, index) {
          GoodsSimple goods = _brandListViewController.getData()[index];
          return MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                AppRouter.push(context, RouteName.COMMODITY_PAGE,
                    arguments: CommodityDetailPage.setArguments(goods.id));
              },
              child: _displayList
                  // ? BrandDetailListItem(goods: goods)
                  // ? NormalGoodsItem(model: goods, buildCtx: context,)
                  ? GoodsItemWidget.normalGoodsItem(
                      onBrandClick: () {
                        AppRouter.push(context, RouteName.BRANDGOODS_LIST_PAGE,
                            arguments: BrandGoodsListPage.setArguments(
                                goods.brandId, goods.brandName));
                      },
                      buildCtx: context,
                      model: goods,
                    )
                  : BrandDetailGridItem(goods: goods));
        });
  }

  @override
  MvpListViewPresenterI<GoodsSimple, MvpView, MvpModel> getPresenter() {
    return _brandPresenter;
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}

  @override
  failure(String msg) {
    return null;
  }
}
