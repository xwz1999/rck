import 'package:flutter/material.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';

class LotteryOrderPage extends StatefulWidget {
  LotteryOrderPage({Key key}) : super(key: key);

  @override
  _LotteryOrderPageState createState() => _LotteryOrderPageState();
}

class _LotteryOrderPageState extends State<LotteryOrderPage> {
  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      red: true,
      title: '我的订单',
    );
  }
}
