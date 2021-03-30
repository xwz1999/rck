import 'package:flutter/material.dart';

import 'package:recook/constants/header.dart';

enum LotteryColorType {
  RED,
  BLUE,
}

class LotteryBall extends StatelessWidget {
  final LotteryColorType type;
  final int ball;
  final bool small;
  const LotteryBall({
    Key key,
    @required this.type,
    @required this.ball,
    this.small = false,
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
      height: small ? rSize(24) : rSize(32),
      width: small ? rSize(24) : rSize(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rSize(16)),
        color: isRed ? Color(0xFFE02020) : Color(0xFF0E89E7),
      ),
      alignment: Alignment.center,
      child: Text(
        _computeBallDisplayValue(),
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? rSP(12) : rSP(14),
        ),
      ),
    );
  }
}
