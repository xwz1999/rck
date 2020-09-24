import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/lottery/models/lottery_history_model.dart';
import 'package:recook/pages/lottery/tools/lottery_tool.dart';
import 'package:recook/pages/lottery/widget/lottery_result_boxes.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';

class LotteryHistoryPage extends StatefulWidget {
  final int id;
  LotteryHistoryPage({Key key, @required this.id}) : super(key: key);

  @override
  _LotteryHistoryPageState createState() => _LotteryHistoryPageState();
}

class _LotteryHistoryPageState extends State<LotteryHistoryPage> {
  List<LotteryHistoryModel> _models = [];
  int page = 1;
  GSRefreshController _refreshController = GSRefreshController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _refreshController.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      title: widget.id == 1 ? '双色球' : '大乐透',
      red: true,
      appBarBottom: PreferredSize(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: rSize(16),
          ),
          height: rSize(40),
          color: Colors.white,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.id == 1 ? '每周二、四、日21:15开奖' : '每周一、三、六20:30开奖',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: rSP(14),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(rSize(40)),
      ),
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          page = 1;
          getHistory().then((models) {
            _refreshController.refreshCompleted();
            setState(() {
              _models = models;
            });
          });
        },
        onLoadMore: () async {
          page++;
          getHistory().then((models) {
            if (models.isEmpty)
              _refreshController.loadNoData();
            else {
              _refreshController.loadComplete();
              setState(() {
                _models.addAll(models);
              });
            }
          });
        },
        body: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              height: rSize(1),
              color: Color(0xFFEEEEEE),
              thickness: rSize(1),
            );
          },
          padding: EdgeInsets.only(top: rSize(10)),
          itemBuilder: (context, index) {
            return _buildLotteryCard(_models[index]);
          },
          itemCount: _models.length,
        ),
      ),
    );
  }

  _buildLotteryCard(LotteryHistoryModel model) {
    return Container(
      padding: EdgeInsets.all(rSize(16)),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '第${model.number}期',
            style: TextStyle(
              fontSize: rSP(14),
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: rSize(16)),
          Row(
            children: [
              Expanded(
                child: LotteryResultBoxes(
                  redBalls: parseBalls(model.bonusCode),
                  blueBalls: parseBalls(model.bonusCode, red: false),
                ),
              ),
              SizedBox(width: rSize(64)),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<LotteryHistoryModel>> getHistory() async {
    ResultData resultData = await HttpManager.post(LotteryAPI.history, {
      'lotteryId': widget.id,
      "limit": 10,
      "page": page,
    });

    return resultData.data['data'] == null
        ? []
        : resultData.data['data']['data'] == null
            ? []
            : (resultData.data['data']['data'] as List)
                .map((e) => LotteryHistoryModel.fromJson(e))
                .toList();
  }
}
