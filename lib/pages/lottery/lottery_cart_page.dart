import 'package:flutter/material.dart';
import 'package:recook/const/resource.dart';
import 'package:recook/constants/app_image_resources.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/pages/home/widget/plus_minus_view.dart';
import 'package:recook/pages/lottery/lottery_cart_model.dart';
import 'package:recook/pages/lottery/widget/lottery_grid_view.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';
import 'package:recook/widgets/custom_image_button.dart';

class LotteryCartPage extends StatefulWidget {
  final dynamic arguments;
  LotteryCartPage({Key key, this.arguments}) : super(key: key);

  @override
  _LotteryCartPageState createState() => _LotteryCartPageState();
}

class _LotteryCartPageState extends State<LotteryCartPage> {
  int multiply = 1;
  @override
  Widget build(BuildContext context) {
    final models = widget.arguments['type']
        ? LotteryCartStore.doubleLotteryModels
        : LotteryCartStore.bigLotteryModels;
    int doubleShots = 0;
    int bigShots = 0;
    LotteryCartStore.doubleLotteryModels.forEach((element) {
      doubleShots += element.shots;
    });
    LotteryCartStore.bigLotteryModels.forEach((element) {
      bigShots += element.shots;
    });
    final countShots = widget.arguments['type'] ? doubleShots : bigShots;
    return LotteryScaffold(
      red: true,
      whiteBg: true,
      title: '双色球',
      bottomNavi: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: true,
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                height: rSize(1),
                thickness: rSize(1),
                color: Color(0xFFEEEEEE),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: rSize(12),
                  horizontal: rSize(16),
                ),
                child: Row(
                  children: [
                    Text(
                      '购买几倍?',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: rSP(14),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: rSize(100),
                      child: PlusMinusView(
                        onValueChanged: (value) {},
                        onInputComplete: (value) {
                          setState(() {
                            multiply = int.parse(value);
                          });
                        },
                        onBeginInput: (text) {},
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: rSize(1),
                thickness: rSize(1),
                color: Color(0xFFEEEEEE),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: rSize(16)),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${countShots * 2}瑞币或$countShots彩票券',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: rSP(12),
                          ),
                        ),
                        Text(
                          '$countShots注$multiply倍',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: rSP(12),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(rSize(20)),
                      ),
                      color: Color(0xFFE02020),
                      splashColor: Colors.black38,
                      onPressed: () {},
                      child: Text(
                        '兑换彩票',
                        style: TextStyle(
                          fontSize: rSP(14),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          if (index == (models.length)) {
            return Container(
              padding: EdgeInsets.all(rSize(16)),
              child: Row(
                children: [
                  CustomImageButton(
                    onPressed: () {
                      if (widget.arguments['type'])
                        LotteryCartStore.doubleLotteryModels.clear();
                      else
                        LotteryCartStore.bigLotteryModels.clear();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          R.ASSETS_LOTTERY_REDEEM_LOTTERY_DELETE_PNG,
                          width: rSize(16),
                          height: rSize(16),
                        ),
                        SizedBox(width: rSize(6)),
                        Text(
                          '清除全部',
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: rSP(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    color: Color(0xFFFFF4F4),
                    splashColor: Colors.black38,
                    child: Text(
                      '+ 继续选号',
                      style: TextStyle(
                        color: Color(0xFFE02020),
                        fontSize: rSP(14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else
            return _buildChildBox(models[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: rSize(1),
            thickness: rSize(1),
            color: Color(0xFFEEEEEE),
          );
        },
        itemCount: models.length + 1,
      ),
    );
  }

  _buildChildBox(LotteryCartModel model) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(rSize(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: LotteryGridView(model: model),
                ),
                SizedBox(width: rSize(34)),
                Icon(
                  AppIcons.icon_next,
                  size: rSize(16),
                  color: Color(0xFF666666),
                ),
              ],
            ),
            Text(
              '${model.typeStr} ${model.shots}注',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: rSize(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
