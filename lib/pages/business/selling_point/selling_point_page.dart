/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/12  3:06 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/models/goods_list_model.dart';
import 'package:recook/pages/business/selling_point/mvp/selling_point_list_presenter_impl.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/items/item_tag_widget.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/widgets/no_data_view.dart';

class SellingPointPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SellingPointPageState();
  }
}

class _SellingPointPageState extends BaseStoreState<SellingPointPage> 
with MvpListViewDelegate<Goods>{
  
  SellingPointListPresenterImpl _presenter;
  MvpListViewController<Goods> _listViewController;
  
  @override
  void initState() {
    super.initState();
    _presenter = SellingPointListPresenterImpl();
    _listViewController = MvpListViewController();
  }
  
  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: "每日上新",
      ),
      body: _buildList(context),
    );
    // return Container(
    //   color: AppColor.frenchColor,
    //   child: _buildList(context),
    // );
  }


  _buildList(BuildContext context) {
    return MvpListView<Goods>(
      delegate: this,
//      padding: EdgeInsets.all(_displayList ? 0 : 10.0),
      autoRefresh: true,
      controller: _listViewController,
      type: ListViewType.grid,
      refreshCallback: () {
        _presenter.fetchList(0,);
      },
      loadMoreCallback: (int page) {
        _presenter.fetchList(page,);
      },
      gridViewBuilder:() => _buildGridView(),
      noDataView: NoDataView(height: 500),
    );
  }

  bool _displayList = true;
  _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: DeviceInfo.bottomBarHeight),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _listViewController.getData().length,
        gridDelegate: ItemTagWidget.getSliverGridDelegate(_displayList, context),
        itemBuilder: (context, index) {
          Goods goods = _listViewController.getData()[index];
          return MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                AppRouter.push(context, RouteName.COMMODITY_PAGE,arguments: CommodityDetailPage.setArguments(goods.id));
              },
              // child: _displayList
              //     ? BrandDetailListItem(goods: goods)
              //     : BrandDetailGridItem(goods: goods)
                  );
        });
  }

  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return Container(
  //     color: AppColor.frenchColor,
  //     child: ListView.builder(
  //         padding: EdgeInsets.symmetric(vertical: 10),
  //         itemCount: 20,
  //         itemBuilder: (_, index) {
  //           return BusinessSellingPointItem();
  //         }),
  //   );  }

  @override
  MvpListViewPresenterI<Goods, MvpView, MvpModel> getPresenter() {
    return _presenter;
  }
}

