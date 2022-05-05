import 'package:flutter/material.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/guide_order_item_model.dart';
import 'package:recook/pages/user/order/guide_order_card.dart';
import 'package:recook/widgets/refresh_widget.dart';

enum GuideOrderType {
  ///全部
  ALL,

  ///待发货
  DELIVER,

  ///待收货
  CHECKOUT,

  ///已收获
  RECEIPT,
}

class GuideOrderView extends StatefulWidget {
  final GuideOrderType type;
  GuideOrderView({Key key, @required this.type}) : super(key: key);

  @override
  _GuideOrderViewState createState() => _GuideOrderViewState();
}

class _GuideOrderViewState extends State<GuideOrderView> {
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
  List<GuideOrderItemModel> _models = [];
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      controller: _refreshController,
      onRefresh: () async {
        _page = 1;
        _models = await _getItems();
        setState(() {});
        _refreshController.refreshCompleted();
      },
      onLoadMore: () async {
        _page++;
        _models.addAll(await _getItems());
        setState(() {});
        _refreshController.loadComplete();
      },
      body: ListView.separated(
        padding: EdgeInsets.all(15.rw),
        itemBuilder: (context, index) {
          return GuideOrderCard(model: _models[index]);
        },
        separatorBuilder: (context, index) => 10.hb,
        itemCount: _models.length,
      ),
    );
  }

  Future<List<GuideOrderItemModel>> _getItems() async {
    int status = 0;
    switch (widget.type) {
      case GuideOrderType.ALL:
        status = 0;
        break;
      case GuideOrderType.DELIVER:
        status = 1;
        break;
      case GuideOrderType.CHECKOUT:
        status = 2;
        break;
      case GuideOrderType.RECEIPT:
        status = 3;
        break;
    }
    Map<String, dynamic> params = {
      "page": _page,
      "limit": 15,
      "status": status,
    };
    ResultData result = await HttpManager.post(
      APIV2.orderAPI.guideOrderList,
      params,
    );
    if (result?.data == null) return [];
    if (result.data['data'] == null) return [];
    if (result.data['data']['list'] == null) return [];
    return (result.data['data']['list'] as List)
        .map((e) => GuideOrderItemModel.fromJson(e))
        .toList();
  }
}
