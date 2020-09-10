import 'package:flutter/material.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';

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
}
