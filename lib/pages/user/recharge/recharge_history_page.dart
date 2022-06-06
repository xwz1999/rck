import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/models/recharge_record_mdel.dart';
import 'package:recook/pages/user/recharge/recharge_result_page.dart';
import 'package:recook/widgets/custom_app_bar.dart';
import 'package:recook/widgets/refresh_widget.dart';
import 'package:recook/widgets/toast.dart';

class RechargeHistoryPage extends StatefulWidget {
  @override
  _RechargeHistoryPageState createState() => _RechargeHistoryPageState();
}

class _RechargeHistoryPageState extends BaseStoreState<RechargeHistoryPage> {
  GSRefreshController? _refreshController;
  late RechargeRecordModel _withdrawHistoryModel;
  List<RechargeRecord>? list;

  int _page = 0;
  bool _onLoad = true;

  @override
  void initState() {
    super.initState();
    _refreshController = GSRefreshController(initialRefresh: true);
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      backgroundColor: AppColor.frenchColor,
      appBar: CustomAppBar(
        title: "审核记录",
        themeData: AppThemes.themeDataGrey.appBarTheme,
        elevation: 0,
        background: AppColor.frenchColor,
        appBackground: AppColor.frenchColor,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 1,
            color: AppColor.frenchColor,
          ),
          Expanded(
              child: RefreshWidget(
                  controller: _refreshController,
                  onRefresh: () {
                    _page = 1;
                    getWithdrawHistoryList().then((models) {
                      setState(() {
                        list = models;
                        _onLoad = false;
                      });
                      _refreshController!.refreshCompleted();
                    });
                  },
                  onLoadMore: () {
                    _page++;
                    if (list!.length >=
                        _withdrawHistoryModel.data!.total!) {
                      _refreshController!.loadComplete();
                      _refreshController!.loadNoData();
                    }else{
                      getWithdrawHistoryList().then((models) {
                        setState(() {
                          list!.addAll(models!);
                        });
                        _refreshController!.loadComplete();
                      });
                    }

                  },
                  body:
                  _onLoad?SizedBox():
                  list == null || list!.length == 0
                      ? noDataView("没有记录...")
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: list!.length,
                          itemBuilder: (BuildContext context, int index) {
                            RechargeRecord data = list![index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => RechargeResultPage(history: data,));
                                // AppRouter.push(context,
                                //     RouteName.CASH_WITHDRAW_RESULT_PAGE,
                                //     arguments:
                                //         CashWithdrawResultPage.setArguments(
                                //             id: data.id));
                              },
                              child: _itemWidget(data),
                            );
                          },
                        )))
        ],
      ),
    );
  }

  _itemWidget(RechargeRecord model) {
    return Container(
      color: Colors.white,
      height: 88,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 4.rw,
                  color: model.state == 1
                      ? Color(0xFFFF9628)
                      : model.state == 2
                          ? Color(0xFFD5101A)
                          : model.state == 99
                              ? Color(0xFFAAAAAA)
                              : Color(0xFFAAAAAA),
                ),
                Flexible(
                  child: Row(
                    children: <Widget>[
                      34.wb,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                "充值 ",
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 16.rsp),
                              ),
                              Text(
                                "¥${model.amount}",
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 16.rsp),
                              ),
                            ],
                          ),
                          Container(
                            height: 3,
                          ),
                          Text(
                            "${ DateUtil.formatDate(DateTime.parse("${model.createdAt!.substring(0,19)}"), format: 'yyyy-MM-dd HH:mm') }",
                            style: TextStyle(
                                color: Color(0xFF7F7F7F),
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        model.state == 1
                            ? "待审核"
                            : model.state == 2
                                ? "充值成功"
                                    : model.state == 99
                                        ? '已驳回'
                                        : '',
                        style: TextStyle(
                            color: model.state == 1
                                ? Color(0xFFFF9628)
                                : model.state == 2
                                    ? Color(0xFFD5101A)
                                    : model.state == 99
                                        ? Color(0xFFAAAAAA)
                                        : Color(0xFFAAAAAA),
                            fontSize: 15),
                      ),
                      34.wb,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8.rw,
            color: AppColor.frenchColor,
          )
        ],
      ),
    );
  }

  Future<List<RechargeRecord>?> getWithdrawHistoryList() async {
    ResultData resultData =
        await HttpManager.post(APIV2.userAPI.depositList, {
      'page': _page,
      'limit': 10,
    });
    if (!resultData.result) {
      Toast.showError(resultData.msg);
      return [];
    }
    RechargeRecordModel model =
    RechargeRecordModel.fromJson(resultData.data);
    if (model.code != HttpStatus.SUCCESS) {
      Toast.showError(model.msg);
      return [];
    }
    _withdrawHistoryModel = model;
    return model.data!.list;
  }
}
