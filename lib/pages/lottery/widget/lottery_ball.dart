import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

enum LotteryColorType {
  RED,
  BLUE,
}

class LotteryBall extends StatelessWidget {
  final LotteryColorType type;
  final int ball;
  const LotteryBall({
    Key key,
    @required this.type,
    @required this.ball,
  }) : super(key: key);

  String _computeBallDisplayValue() {
    if (ball < 10)
      return "0$ball";
    else
      return "$ball";
  }

  @override
  Widget build(BuildContext context) {
    final isRed = type == LotteryColorType.RED;
    return Container(
      height: rSize(32),
      width: rSize(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rSize(16)),
        color: isRed ? Color(0xFFE02020) : Color(0xFF0E89E7),
      ),
      alignment: Alignment.center,
      child: Text(
        _computeBallDisplayValue(),
        style: TextStyle(
          color: Colors.white,
          fontSize: rSP(14),
        ),
      ),
    );
  }
}
