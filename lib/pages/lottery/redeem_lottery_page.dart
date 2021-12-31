import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/lottery/lottery_history_page.dart';
import 'package:jingyaoyun/pages/lottery/models/lottery_list_model.dart';
import 'package:jingyaoyun/pages/lottery/tools/lottery_tool.dart';
import 'package:jingyaoyun/pages/lottery/widget/lottery_result_boxes.dart';
import 'package:jingyaoyun/pages/lottery/widget/lottery_scaffold.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

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
  List<LotteryListModel> _models;

  @override
  void initState() {
    super.initState();
    HttpManager.post(LotteryAPI.list, {}).then((resultData) {
      setState(() {
        if (resultData.data['code'] == 'FAIL') {
          showToast(resultData.data['mesg']);
          _models = [];
        }
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
      title: '彩票频道',
      // actions: [
      //   MaterialButton(
      //     padding: EdgeInsets.symmetric(horizontal: rSize(16)),
      //     minWidth: rSize(52),
      //     onPressed: () =>
      //         AppRouter.push(context, RouteName.LOTTERY_ORDER_PAGE),
      //     child: Image.asset(
      //       R.ASSETS_LOTTERY_REDEEM_LOTTERY_LIST_PNG,
      //       width: rSize(20),
      //       height: rSize(20),
      //     ),
      //   ),
      // ],
      body: _models == null
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
      redBalls = parseBalls(model.last.bonusCode);
      blueBalls = parseBalls(model.last.bonusCode, red: false);
    }

    return CustomImageButton(
      onPressed: () {
        // CRoute.push(
        //     context,
        //     LotteryPickerPage(
        //       isDouble: model.id == 1,
        //       lotteryListModel: model,
        //     ));
        CRoute.push(
          context,
          LotteryHistoryPage(id: model.id),
        );
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
