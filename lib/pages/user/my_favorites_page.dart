/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-26  14:35 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/my_favorites_list_model.dart';
import 'package:recook/pages/home/classify/commodity_detail_page.dart';
import 'package:recook/pages/user/items/item_my_favorite.dart';
import 'package:recook/pages/user/mvp/my_favorite_contact.dart';
import 'package:recook/pages/user/mvp/my_favorite_presenter_impl.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';
import 'package:recook/widgets/toast.dart';

class MyFavoritesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyFavoritesPageState();
  }
}

class _MyFavoritesPageState extends BaseStoreState<MyFavoritesPage>
    with MvpListViewDelegate<FavoriteModel>
    implements MyFavoriteViewI {
  MyFavoritePresenterImpl _presenter;
  MvpListViewController<FavoriteModel> _controller;
  @override
  MvpListViewPresenterI<FavoriteModel, MvpView, MvpModel> getPresenter() {
    return _presenter;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _presenter = MyFavoritePresenterImpl();
    _presenter.attach(this);
    _controller = MvpListViewController();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        title: "我的收藏",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _buildBody(),
      backgroundColor: AppColor.frenchColor,
    );
  }

  _buildBody() {
    return MvpListView(
      noDataView: noDataView("没有数据..."),
      itemClickListener: (index) {
        AppRouter.push(context, RouteName.COMMODITY_PAGE,
            arguments: CommodityDetailPage.setArguments(
                _controller.getData()[index].goods.id));
      },
      delegate: this,
      controller: _controller,
      refreshCallback: () {
        _presenter.getFavoritesList(UserManager.instance.user.info.id);
      },
      itemBuilder: (context, index) {
        return MyFavoriteItem(
          deleteFunc: () {
            _cancel(_controller.getData()[index]);
          },
          shareFunc: () {
            FavoriteModel favoriteModel = _controller.getData()[index];
            ShareTool().goodsShare(context,
                goodsPrice:
                    favoriteModel.goods.discountPrice.toStringAsFixed(2),
                goodsName: favoriteModel.goods.goodsName,
                goodsDescription: favoriteModel.goods.description,
                miniTitle: favoriteModel.goods.goodsName,
                miniPicurl: favoriteModel.goods.mainPhotoUrl,
                goodsId: favoriteModel.goods.id.toString());
          },
          model: _controller.getData()[index],
        );
      },
      // swipeItemWidthRatio: 0.13,
      // swipeTrailingItems: (int index) {
      //   return [
      //     SwipeItem(
      //       child: Container(
      //         alignment: Alignment.center,
      //         height: double.infinity,
      //         color: Colors.red,
      //         // color: AppColor.themeColor,
      //         child: Text(
      //           "分享",
      //           style: AppTextStyle.generate(15*2.sp, color: Colors.white),
      //         ),
      //       ),
      //       onTap: () {
      //         _showShare(context, _controller.getData()[index]);
      //         // _cancel(_controller.getData()[index]);
      //       },
      //     ),
      //     SwipeItem(
      //       child: Container(
      //         alignment: Alignment.center,
      //         height: double.infinity,
      //         color: Colors.grey[500],
      //         child: Text(
      //           "取消",
      //           style: AppTextStyle.generate(15*2.sp, color: Colors.white),
      //         ),
      //       ),
      //       onTap: () {
      //         _cancel(_controller.getData()[index]);
      //       },
      //     ),
      //   ];
      // },
    );
  }

  _cancel(FavoriteModel favoriteModel) {
    _presenter.favoriteCancel(UserManager.instance.user.info.id, favoriteModel);
  }

  @override
  cancelFavoriteSuccess(FavoriteModel favoriteModel) {
    _controller.deleteItem(favoriteModel);
    Toast.showInfo("取消收藏成功");
  }

  @override
  void onAttach() {}

  @override
  void onDetach() {}
}
