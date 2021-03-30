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

  ///彩票下单类型
  String get typeStr {
    if (isDoubleLottery) {
      if (redBalls.length == 6 && blueBalls.length == 1)
        return '单式';
      else if (focusedRedBalls.length != 0 || focusedBlueBalls.length != 0)
        return '胆拖';
      else
        return '复式';
    } else {
      if (redBalls.length == 5 && blueBalls.length == 2)
        return '单式';
      else if (focusedRedBalls.length != 0 || focusedBlueBalls.length != 0)
        return '胆拖';
      else
        return '复式';
    }
  }

  int get lotteryTypeCode {
    if (isDoubleLottery) {
      if (redBalls.length == 6 && blueBalls.length == 1)
        return 101;
      else if (focusedRedBalls.length != 0 || focusedBlueBalls.length != 0)
        return 103;
      else
        return 102;
    } else {
      if (redBalls.length == 5 && blueBalls.length == 2)
        return 101;
      else if (focusedRedBalls.length != 0 || focusedBlueBalls.length != 0)
        return 103;
      else
        return 102;
    }
  }

  ///获取注数
  int get shots => LotteryCartStore.countLotteryBalls(
        type,
        redBalls: redBalls,
        blueBalls: blueBalls,
        focusedRedBalls: focusedRedBalls,
        focusedBlueBalls: focusedBlueBalls,
      );

  ///获取 recook coin
  int get recookCoin => shots * 2;

  ///是否为双色球
  bool get isDoubleLottery => type == LotteryType.DOUBLE_LOTTERY;
}

class LotteryCartStore {
  static List<LotteryCartModel> doubleLotteryModels = [];
  static List<LotteryCartModel> bigLotteryModels = [];
  static add1Shot(LotteryType type, LotteryCartModel model) {
    // int normalType = 0;
    // int multiplyType = 0;
    // int withChildType = 0;

    // int normalTypeBigLottery = 0;
    // int multiplyTypeBigLottery = 0;
    // int withChildTypeBigLottery = 0;

    //TODO：需要重构
    if (type == LotteryType.DOUBLE_LOTTERY) {
      // doubleLotteryModels.forEach((element) {
      //   switch (element.lotteryTypeCode) {
      //     case 101:
      //       normalType++;
      //       break;
      //     case 102:
      //       multiplyType++;
      //       break;
      //     case 103:
      //       withChildType++;
      //       break;
      //   }
      // });
      // if (normalType >= 5 && model.lotteryTypeCode == 101)
      //   showToast('一次只能兑换5注单式彩票');
      // else if (multiplyType >= 1 && model.lotteryTypeCode == 102)
      //   showToast('一次只能兑换1注复式彩票');
      // else if (withChildType >= 1 && model.lotteryTypeCode == 103)
      //   showToast('一次只能兑换1注脱胆彩票');
      // else
        doubleLotteryModels.add(model);
    } else {
      // bigLotteryModels.forEach((element) {
      //   switch (element.lotteryTypeCode) {
      //     case 101:
      //       normalTypeBigLottery++;
      //       break;
      //     case 102:
      //       multiplyTypeBigLottery++;
      //       break;
      //     case 103:
      //       withChildTypeBigLottery++;
      //       break;
      //   }
      // });
      // if (normalTypeBigLottery >= 5 && model.lotteryTypeCode == 101)
      //   showToast('一次只能兑换5注单式彩票');
      // else if (multiplyTypeBigLottery >= 1 && model.lotteryTypeCode == 102)
      //   showToast('一次只能兑换1注复式彩票');
      // else if (withChildTypeBigLottery >= 1 && model.lotteryTypeCode == 103)
      //   showToast('一次只能兑换1注脱胆彩票');
      // else
        bigLotteryModels.add(model);
    }
  }

  static clear(LotteryType type) {
    if (type == LotteryType.DOUBLE_LOTTERY) {
      doubleLotteryModels.clear();
    } else {
      bigLotteryModels.clear();
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
        if ((focusedRedBalls.isNotEmpty && focusedBlueBalls.isNotEmpty) &&
            redBalls.length >= 5)
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
