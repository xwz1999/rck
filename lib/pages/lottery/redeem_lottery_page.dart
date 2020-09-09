import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/lottery/widget/lottery_result_boxes.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';
import 'package:recook/widgets/custom_image_button.dart';

enum LotteryType {
  DOUBLE_LOTTERY,
  BIG_LOTTERY,
}

class RedeemLotteryPage extends StatefulWidget {
  RedeemLotteryPage({Key key}) : super(key: key);

  @override
  _RedeemLotteryPageState createState() => _RedeemLotteryPageState();
}

class _RedeemLotteryPageState extends State<RedeemLotteryPage> {
  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      title: '彩票兑换',
      actions: [
        MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: rSize(16)),
          minWidth: rSize(52),
          onPressed: () {},
          child: Image.asset(
            R.ASSETS_LOTTERY_REDEEM_LOTTERY_LIST_PNG,
            width: rSize(20),
            height: rSize(20),
          ),
        ),
      ],
      body: ListView(
        children: [
          _lotteryCard(
            type: LotteryType.DOUBLE_LOTTERY,
            redBalls: [2, 6, 11, 14, 18, 22],
            blueBalls: [02],
          ),
          _lotteryCard(
            type: LotteryType.BIG_LOTTERY,
            redBalls: [2, 6, 11, 14, 18],
            blueBalls: [7, 12],
          ),
        ],
      ),
    );
  }

  _lotteryCard({
    LotteryType type,
    List<int> redBalls,
    List<int> blueBalls,
  }) {
    String title = type == LotteryType.DOUBLE_LOTTERY ? "双色球" : "大乐透";
    String asset = type == LotteryType.DOUBLE_LOTTERY
        ? R.ASSETS_LOTTERY_REDEEM_DOUBLE_LOTTERY_PNG
        : R.ASSETS_LOTTERY_REDEEM_BIG_LOTTERY_PNG;

    return CustomImageButton(
      onPressed: () {
        AppRouter.push(context, RouteName.LOTTERY_PICKER_PAGE,
            arguments: {'type': type == LotteryType.DOUBLE_LOTTERY});
      },
      child: Container(
        padding: EdgeInsets.all(rSize(16)),
        margin: EdgeInsets.symmetric(
          vertical: rSize(8),
          horizontal: rSize(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rSize(4)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset(
                  asset,
                  width: rSize(36),
                  height: rSize(36),
                ),
                SizedBox(width: rSize(10)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                      ),
                    ),
                    Text(
                      'DATE',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: rSP(12),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFD7D7D7),
                  size: rSize(16),
                ),
              ],
            ),
            SizedBox(height: rSize(20)),
            Row(
              children: [
                Expanded(
                  child: LotteryResultBoxes(
                    type: type,
                    redBalls: redBalls,
                    blueBalls: blueBalls,
                  ),
                ),
                SizedBox(width: rSize(34)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
