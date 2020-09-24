import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/lottery/models/lottery_list_model.dart';
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
  List<LotteryListModel> _models = [];

  @override
  void initState() {
    super.initState();
    HttpManager.post(LotteryAPI.list, {}).then((resultData) {
      setState(() {
        _models = resultData.data['data'] == null
            ? []
            : (resultData.data['data'] as List)
                .map((e) => LotteryListModel.fromJson(e))
                .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      title: '彩票兑换',
      actions: [
        MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: rSize(16)),
          minWidth: rSize(52),
          onPressed: () =>
              AppRouter.push(context, RouteName.LOTTERY_ORDER_PAGE),
          child: Image.asset(
            R.ASSETS_LOTTERY_REDEEM_LOTTERY_LIST_PNG,
            width: rSize(20),
            height: rSize(20),
          ),
        ),
      ],
      body: _models.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: _models
                  .map(
                    (e) => _lotteryCard(model: e),
                  )
                  .toList(),
            ),
    );
  }

  Widget _lotteryCard({@required LotteryListModel model}) {
    String asset;
    switch (model.id) {
      case 1:
        asset = R.ASSETS_LOTTERY_REDEEM_DOUBLE_LOTTERY_PNG;
        break;
      case 2:
        asset = R.ASSETS_LOTTERY_REDEEM_BIG_LOTTERY_PNG;
        break;
      default:
        asset = R.ASSETS_LOTTERY_REDEEM_DOUBLE_LOTTERY_PNG;
    }
    List<int> redBalls, blueBalls;
    if (TextUtils.isNotEmpty(model.last.bonusCode)) {
      redBalls = model.last.bonusCode
          .split('#')[0]
          .split(',')
          .map((e) => int.parse(e))
          .toList();

      blueBalls = model.last.bonusCode
          .split('#')[1]
          .split(',')
          .map((e) => int.parse(e))
          .toList();
    }

    return CustomImageButton(
      onPressed: () {
        AppRouter.push(context, RouteName.LOTTERY_PICKER_PAGE,
            arguments: {'type': model.id == 1});
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
                      model.name,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(16),
                      ),
                    ),
                    Text(
                      '第${model.last.number}\期',
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
            redBalls == null
                ? SizedBox()
                : Row(
                    children: [
                      Expanded(
                        child: LotteryResultBoxes(
                          redBalls: redBalls ?? [],
                          blueBalls: blueBalls ?? [],
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
