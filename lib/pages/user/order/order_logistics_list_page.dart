/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-19  11:17 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/logistic_list_model.dart';
import 'package:recook/pages/user/items/item_logistic.dart';
import 'package:recook/pages/user/mvp/order_list_presenter_impl.dart';
import 'package:recook/pages/user/order/logistic_detail_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/toast.dart';

class OrderLogisticsListPage extends StatefulWidget {
  final Map? arguments;

  const OrderLogisticsListPage({Key? key, this.arguments}) : super(key: key);

  static setArguments({required int? orderId}) {
    return {"orderId": orderId};
  }

  @override
  State<StatefulWidget> createState() {
    return _OrderLogisticsListPageState();
  }
}

class _OrderLogisticsListPageState extends BaseStoreState<OrderLogisticsListPage> {
  late OrderListPresenterImpl _presenter;
  LogisticListModel? _listModel;
  int? _orderId;

  @override
  void initState() {
    super.initState();
    _orderId = widget.arguments!["orderId"];
    _presenter = OrderListPresenterImpl();
    _getLogisticList();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "物流信息",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _listModel == null ? loadingView() : _buildBody(),
      backgroundColor: AppColor.tableViewGrayColor,
    );
  }

  _buildBody() {
    bool noData = _listModel!.data == null || _listModel!.data!.length == 0;
    return noData ? noDataView("没有物流信息哦~") : ListView.builder(
        itemCount:_listModel!.data!.length,
        itemBuilder: (_, index) {
          return CustomImageButton(
            child: LogisticItem(
              model: _listModel!.data![index],
            ),
            onPressed: () {
              if (_listModel!.data==null || _listModel!.data!.length == 0) {
                return;
              }
              AppRouter.push(globalContext!, RouteName.ORDER_LOGISTIC_DETAIL,arguments: LogisticDetailPage.setArguments(detailModel:  _listModel!.data![index]));
            },
          );
        });
  }

  _getLogisticList() async {
    HttpResultModel<LogisticListModel?> resultModel =
        await _presenter.queryLogistic(UserManager.instance!.user.info!.id, _orderId);
    if (!resultModel.result) {
      Toast.showInfo(resultModel.msg??'');
      return;
    }
    setState(() {
      _listModel = resultModel.data;
    });
  }


}
