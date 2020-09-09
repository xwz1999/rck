import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
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
      whiteBg: true,
      title: '我的订单',
      body: ListView.separated(
        itemBuilder: (context, index) {
          return _buildLotteryCard();
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: rSize(1),
            thickness: rSize(1),
            color: Color(0xFFEEEEEE),
          );
        },
        itemCount: 10,
      ),
    );
  }

  _buildLotteryCard() {
    return InkWell(
      onTap: () => AppRouter.push(context, RouteName.LOTTERY_ORDER_DETAIL_PAGE),
      child: Container(
        padding: EdgeInsets.all(rSize(16)),
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
                    '大乐透',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Text('2020-08-19 23：25:58'),
                ],
              ),
              SizedBox(height: rSize(10)),
              Row(
                children: [
                  Text('期号：20200823'),
                  Spacer(),
                  Text(
                    '未出票',
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
}
