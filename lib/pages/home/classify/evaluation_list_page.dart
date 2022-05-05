/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-09-01  14:43 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/evaluation_list_model.dart';
import 'package:recook/pages/home/classify/mvp/order_mvp/evaluation_presenter_impl.dart';
import 'package:recook/pages/home/items/item_evaluation.dart';
import 'package:recook/utils/mvp.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view.dart';
import 'package:recook/widgets/mvp_list_view/mvp_list_view_contact.dart';

class EvaluationListPage extends StatefulWidget {
  final Map arguments;

  const EvaluationListPage({Key key, @required this.arguments}) : super(key: key);

  static setArguments({@required int goodsId}) {
    return {
      "goodsId": goodsId
    };
  }

  @override
  State<StatefulWidget> createState() {
    return _EvaluationListPageState();
  }
}

class _EvaluationListPageState extends BaseStoreState<EvaluationListPage> with MvpListViewDelegate<Data> {
  EvaluationPresenterImpl _presenter;
  MvpListViewController<Data> _controller;

  int _goodsId;

  @override
  void initState() {
    super.initState();
    _controller = MvpListViewController();
    _goodsId = widget.arguments["goodsId"];
    _presenter = EvaluationPresenterImpl();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0,
        title: "全部评论",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _buildList(),
      backgroundColor: AppColor.frenchColor,
    );
  }

  _buildList() {
    return MvpListView(
      delegate: this,
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        return EvaluationItem(evaluation: _controller.getData()[index],);
      },
      refreshCallback: () {
        _presenter.getEvaluationList(UserManager.instance.user.info.id, _goodsId, 0);
      },
      loadMoreCallback: (int page) {

      },
      noDataView: noDataView("暂时没有评论哦~"),
    );
  }

  @override
  MvpListViewPresenterI<Data, MvpView, MvpModel> getPresenter() {
    return _presenter;
  }
}
