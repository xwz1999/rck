import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/pages/lottery/widget/lottery_result_boxes.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';

class LotteryHistoryPage extends StatefulWidget {
  final dynamic arguments;
  LotteryHistoryPage({Key key, this.arguments}) : super(key: key);

  @override
  _LotteryHistoryPageState createState() => _LotteryHistoryPageState();
}

class _LotteryHistoryPageState extends State<LotteryHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      title: widget.arguments['type'] ? '双色球' : '大乐透',
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
            widget.arguments['type'] ? '每周二、四、日21:15开奖' : '每周一、三、六20:30开奖',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: rSP(14),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(rSize(40)),
      ),
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
          return _buildLotteryCard();
        },
        itemCount: 10,
      ),
    );
  }

  _buildLotteryCard() {
    return Container(
      padding: EdgeInsets.all(rSize(16)),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '第20200820',
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
                  type: LotteryType.DOUBLE_LOTTERY,
                  redBalls: [1, 2, 3, 4, 5, 6],
                  blueBalls: [7],
                ),
              ),
              SizedBox(width: rSize(64)),
            ],
          ),
        ],
      ),
    );
  }
}
