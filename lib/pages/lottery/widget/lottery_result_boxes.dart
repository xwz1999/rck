import 'package:flutter/material.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/pages/lottery/widget/lottery_ball.dart';

class LotteryResultBoxes extends StatelessWidget {
  final LotteryType type;
  final List<int> redBalls;
  final List<int> blueBalls;
  final bool small;
  const LotteryResultBoxes({
    Key key,
    this.type,
    this.redBalls,
    this.blueBalls,
    this.small = false,
  })  
  //红球数量限制
  : assert(redBalls.length == (type == LotteryType.DOUBLE_LOTTERY ? 6 : 5),
            "红球数量错误"),
        //篮球数量限制
        assert(
            blueBalls.length == (type == LotteryType.DOUBLE_LOTTERY ? 1 : 2)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: redBalls
          .map(
            (element) => LotteryBall(
              type: LotteryColorType.RED,
              ball: element,
              small: small,
            ),
          )
          .toList()
            ..addAll(
              blueBalls.map(
                (e) => LotteryBall(
                  type: LotteryColorType.BLUE,
                  ball: e,
                  small: small,
                ),
              ),
            ),
    );
  }
}
