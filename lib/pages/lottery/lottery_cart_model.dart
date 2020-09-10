import 'package:flutter/material.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/utils/math/recook_math.dart';

class LotteryCartModel {
  LotteryType type;
  List<int> redBalls = [];
  List<int> blueBalls = [];
  List<int> focusedRedBalls = [];
  List<int> focusedBlueBalls = [];
  LotteryCartModel({
    @required this.type,
    @required this.redBalls,
    @required this.blueBalls,
    @required this.focusedRedBalls,
    @required this.focusedBlueBalls,
  });
}

class LotteryCartStore {
  static List<LotteryCartModel> doubleLotteryModels = [];
  static List<LotteryCartModel> bigLotteryModels = [];
  static add1Shot(LotteryType type, LotteryCartModel model) {
    switch (type) {
      case LotteryType.DOUBLE_LOTTERY:
        doubleLotteryModels.add(model);
        break;
      case LotteryType.BIG_LOTTERY:
        bigLotteryModels.add(model);
        break;
    }
  }

  static int countLotteryBalls(
    LotteryType type, {
    @required List<int> redBalls,
    @required List<int> blueBalls,
    @required List<int> focusedRedBalls,
    @required List<int> focusedBlueBalls,
  }) {
    switch (type) {
      case LotteryType.DOUBLE_LOTTERY:
        if (focusedRedBalls.length >= 1 && redBalls.length > 6)
          return RecookMath.combination(6 - focusedRedBalls.length,
                  redBalls.length - focusedRedBalls.length) *
              RecookMath.combination(1, blueBalls.length);
        else
          return RecookMath.combination(6, redBalls.length) *
              RecookMath.combination(1, blueBalls.length);
        break;
      case LotteryType.BIG_LOTTERY:
        if ((focusedRedBalls.length >= 1 || focusedBlueBalls.length >= 1) &&
            redBalls.length > 5)
          return RecookMath.combination(5 - focusedRedBalls.length,
                  redBalls.length - focusedRedBalls.length) *
              RecookMath.combination(2 - focusedBlueBalls.length,
                  blueBalls.length - focusedBlueBalls.length);
        else
          return RecookMath.combination(5, redBalls.length) *
              RecookMath.combination(2, blueBalls.length);
        break;
    }
    return 0;
  }
}
