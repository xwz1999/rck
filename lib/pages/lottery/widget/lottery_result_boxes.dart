import 'package:flutter/material.dart';
import 'package:recook/pages/lottery/widget/lottery_ball.dart';

class LotteryResultBoxes extends StatelessWidget {
  final List<int> redBalls;
  final List<int> blueBalls;
  final bool small;
  const LotteryResultBoxes({
    Key key,
    this.redBalls,
    this.blueBalls,
    this.small = false,
  }) : super(key: key);

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
