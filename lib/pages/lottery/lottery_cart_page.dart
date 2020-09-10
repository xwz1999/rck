import 'package:flutter/material.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';

class LotteryCartPage extends StatefulWidget {
  final dynamic arguments;
  LotteryCartPage({Key key, this.arguments}) : super(key: key);

  @override
  _LotteryCartPageState createState() => _LotteryCartPageState();
}

class _LotteryCartPageState extends State<LotteryCartPage> {
  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      title: '双色球',
      body: SizedBox(),
    );
  }
}
