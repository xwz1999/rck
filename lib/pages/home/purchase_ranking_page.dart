


import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/home/items/item_tag_widget.dart';
import 'package:recook/pages/home/mvp/purchase_ranking_presenter_impl.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/models/goods_list_model.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/widgets/no_data_view.dart';


class PurchaseRankingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _PurchaseRankingPageState();
  }
  
}

class _PurchaseRankingPageState extends BaseStoreState<PurchaseRankingPage> 
with MvpListViewDelegate<Goods>{

  PurchaseRankingPresenterImpl _presenter;
  MvpListViewController<Goods> _listViewController;

  @override
  void initState() {
    _presenter = PurchaseRankingPresenterImpl();
    _listViewController = MvpListViewController();
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        themeData: AppThemes.themeDataGrey.appBarTheme,
        title: "每日榜单",
      ),
      body: _buildList(context),
    );
  }

  _buildList(BuildContext context){
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


  @override
  MvpListViewPresenterI<Goods, MvpView, MvpModel> getPresenter() {
    return _presenter;
  }


}