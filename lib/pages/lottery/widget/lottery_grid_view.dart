import 'package:flutter/material.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/pages/lottery/lottery_cart_model.dart';
import 'package:recook/pages/lottery/widget/lottery_ball.dart';

class LotteryGridView extends StatelessWidget {
  final LotteryCartModel model;
  const LotteryGridView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> focusRedBalls = model.focusedRedBalls;
    final List<int> redBalls = model.redBalls;
    focusRedBalls.forEach((element) {
      redBalls.remove(element);
    });
    final List<int> focusBlueBalls = model.focusedBlueBalls;
    final List<int> blueBalls = model.blueBalls;
    focusBlueBalls.forEach((element) {
      blueBalls.remove(element);
    });

    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: rSize(10)),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: rSize(12),
        mainAxisSpacing: rSize(12),
      ),
      children: []
        ..addAll(
          focusRedBalls.map(
            (e) => _buildLotteryBox(LotteryColorType.RED, e, true),
          ),
        )
        ..addAll(
          redBalls.map(
            (e) => _buildLotteryBox(LotteryColorType.RED, e, false),
          ),
        )
        ..addAll(
          focusBlueBalls.map(
            (e) => _buildLotteryBox(
              LotteryColorType.BLUE,
              e,
              true,
            ),
          ),
        )
        ..addAll(
          blueBalls.map(
            (e) => _buildLotteryBox(LotteryColorType.BLUE, e, false),
          ),
        ),
    );
  }

  Widget _buildLotteryBox(
      LotteryColorType colorType, int value, bool isFocused) {
    return Container(
      height: rSize(32),
      width: rSize(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorType == LotteryColorType.RED
            ? Color(0xFFE02020)
            : Color(0xFF0E89E7),
        borderRadius: BorderRadius.circular(rSize(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _computeBallDisplayValue(value),
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(14),
              height: 1.02,
            ),
          ),
          isFocused
              ? Text(
                  '胆',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rSP(14),
                    height: 1.02,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  String _computeBallDisplayValue(int ball) {
    if (ball < 10)
      return "0$ball";
    else
      return "$ball";
  }
}
