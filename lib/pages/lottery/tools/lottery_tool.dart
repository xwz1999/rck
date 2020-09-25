import 'package:flutter/widgets.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/lottery/lottery_cart_model.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';

///解析球
///
///example:
///
///parseBalls('01,02,03,04,05,06#07')
///
///01,02,03,04,05,06#07 => [1,2,3,4,5,6] or [7]
List<int> parseBalls(String balls, {bool red: true}) {
  if (TextUtils.isEmpty(balls)) {
    return [];
  } else {
    return balls
        .split('#')[red ? 0 : 1]
        .split(',')
        .map(
          (e) => int.parse(e),
        )
        .toList();
  }
}

String convertCartBalls(LotteryCartModel model) {
  return convertBalls(
    redBalls: model.redBalls,
    blueBalls: model.blueBalls,
    focusRedBalls: model.focusedRedBalls,
    focusBlueBalls: model.focusedBlueBalls,
    lotteryType: model.type,
  );
}

///彩票投注号码Convert
String convertBalls({
  @required List<int> redBalls,
  @required List<int> blueBalls,
  List<int> focusRedBalls = const [],
  List<int> focusBlueBalls = const [],
  @required LotteryType lotteryType,
}) {
  StringBuffer ballsBuffer = StringBuffer();
  switch (lotteryType) {
    case LotteryType.DOUBLE_LOTTERY:
      if (focusRedBalls.isNotEmpty) {
        ballsBuffer.write(ballsToString(focusRedBalls));
        ballsBuffer.write('\$');
      }
      ballsBuffer.write(ballsToString(redBalls));
      ballsBuffer.write('#');
      ballsBuffer.write(ballsToString(blueBalls));
      return ballsBuffer.toString();
      break;
    case LotteryType.BIG_LOTTERY:
      return '';
      break;
    default:
      return '';
  }
}

///int => string
///
/// ball to string
String ballToString(int ball) {
  return ball < 10 ? '0$ball' : '$ball';
}

///string => int
///
/// ball to int
int stringToBall(String ball) {
  return int.parse(ball);
}

///List\<int\> => String
///
/// balls to String
String ballsToString(List<int> balls) {
  String focusTemp = "";
  balls.forEach((element) {
    focusTemp += ",${ballToString(element)}";
  });
  return focusTemp.substring(1);
}
