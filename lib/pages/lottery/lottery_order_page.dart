import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/lottery/models/lottery_redeem_history_model.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';

class LotteryOrderPage extends StatefulWidget {
  LotteryOrderPage({Key key}) : super(key: key);

  @override
  _LotteryOrderPageState createState() => _LotteryOrderPageState();
}

class _LotteryOrderPageState extends State<LotteryOrderPage> {
  int page = 1;
  List<LotteryRedeemHistoryModel> _models = [];
  GSRefreshController _refreshController = GSRefreshController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      _refreshController.requestRefresh();
    });
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      red: true,
      whiteBg: true,
      title: '我的订单',
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          page = 1;
          getModels().then((models) {
            setState(() {
              _models = models;
              _refreshController.refreshCompleted();
            });
          });
        },
        onLoadMore: () async {
          page++;
          getModels().then((models) {
            if (models.isEmpty) {
              _refreshController.loadNoData();
            } else
              setState(() {
                _models.addAll(models);
                _refreshController.loadComplete();
              });
          });
        },
        body: ListView.separated(
          itemBuilder: (context, index) {
            return _buildLotteryCard(_models[index]);
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: rSize(1),
              thickness: rSize(1),
              color: Color(0xFFEEEEEE),
            );
          },
          itemCount: _models.length,
        ),
      ),
    );
  }

  _buildLotteryCard(LotteryRedeemHistoryModel model) {
    return InkWell(
      onTap: () => AppRouter.push(context, RouteName.LOTTERY_ORDER_DETAIL_PAGE),
      child: Container(
        padding: EdgeInsets.all(rSize(16)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFEEEEEE),
              width: rSize(1),
            ),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: rSP(14),
            color: Color(0xFF999999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    model.lotteryName,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Text(model.betTime),
                ],
              ),
              SizedBox(height: rSize(10)),
              Row(
                children: [
                  Text('期号：${model.number}'),
                  Spacer(),
                  Text(
                    statusValue[model.status],
                    style: TextStyle(
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<int, String> statusValue = {
    1: "未出票",
    2: "待开奖",
    3: "未中奖",
    4: "已中奖",
  };

  Future<List<LotteryRedeemHistoryModel>> getModels() async {
    ResultData resultData = await HttpManager.post(
      LotteryAPI.redeem_history,
      {
        'page': page,
        'limit': 10,
      },
    );
    return resultData.data['data'] == null
        ? []
        : resultData.data['data']['data'] == null
            ? []
            : (resultData.data['data']['data'] as List)
                .map((e) => LotteryRedeemHistoryModel.fromJson(e))
                .toList();
  }
}
