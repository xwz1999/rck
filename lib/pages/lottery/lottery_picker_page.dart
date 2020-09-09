import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';

class LotteryPickerPage extends StatefulWidget {
  LotteryPickerPage({Key key}) : super(key: key);

  @override
  _LotteryPickerPageState createState() => _LotteryPickerPageState();
}

class _LotteryPickerPageState extends State<LotteryPickerPage> {
  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      red: true,
      title: Column(
        children: [
          Text(
            '双色球',
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(18),
            ),
          ),
          Text(
            '明日',
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(12),
            ),
          ),
        ],
      ),
      actions: [
        MaterialButton(
          minWidth: rSize(20),
          onPressed: () {},
          child: Image.asset(
            R.ASSETS_LOTTERY_REDEEM_LOTTERY_DETAIL_PNG,
            width: rSize(20),
            height: rSize(20),
          ),
        ),
        MaterialButton(
          minWidth: rSize(20),
          onPressed: () {},
          child: Image.asset(
            R.ASSETS_LOTTERY_REDEEM_LOTTERY_HISTORY_PNG,
            width: rSize(20),
            height: rSize(20),
          ),
        ),
      ],
      body: SizedBox(),
    );
  }
}
