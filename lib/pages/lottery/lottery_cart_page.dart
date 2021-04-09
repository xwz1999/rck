import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oktoast/oktoast.dart';

import 'package:recook/const/resource.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/home/widget/plus_minus_view.dart';
import 'package:recook/pages/lottery/lottery_cart_model.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/pages/lottery/tools/lottery_tool.dart';
import 'package:recook/pages/lottery/widget/lottery_grid_view.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_image_button.dart';

class LotteryCartPage extends StatefulWidget {
  final bool isDouble;
  LotteryCartPage({Key key, @required this.isDouble}) : super(key: key);

  @override
  _LotteryCartPageState createState() => _LotteryCartPageState();
}

class _LotteryCartPageState extends State<LotteryCartPage> {
  int multiply = 1;
  @override
  Widget build(BuildContext context) {
    final models = widget.isDouble
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
    final countShots = widget.isDouble ? doubleShots : bigShots;
    return LotteryScaffold(
      red: true,
      whiteBg: true,
      title: widget.isDouble ? '双色球' : '大乐透',
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
                          '${countShots * 2 * multiply}瑞币',
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => NormalContentDialog(
                            title: '兑换彩票',
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '确定使用${countShots * 2.0 * multiply}瑞币',
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: rSP(16),
                                  ),
                                ),
                                Text(
                                  '当前瑞币余额：${UserManager.instance.userBrief.myAssets.coinNum}',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: rSP(15),
                                  ),
                                ),
                              ],
                            ),
                            items: ['取消', '确定'],
                            listener: (index) {
                              switch (index) {
                                case 0:
                                  Navigator.pop(context);
                                  break;
                                case 1:
                                  if (UserManager
                                          .instance.userBrief.myAssets.coinNum <
                                      countShots * 2.0) {
                                    Navigator.pop(context);
                                    showToast('瑞币余额不足,无法兑换');
                                  } else {
                                    _redeemLottery();
                                  }

                                  break;
                              }
                            },
                          ),
                        );
                      },
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
                      if (widget.isDouble)
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
    return Slidable(
      child: InkWell(
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
                  // Icon(
                  //   AppIcons.icon_next,
                  //   size: rSize(16),
                  //   color: Color(0xFF666666),
                  // ),
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
      ),
      secondaryActions: [
        SlideAction(
          color: Color(0xFFFF4D4F),
          child: Text(
            '删除',
            style: TextStyle(
              color: Colors.white,
              fontSize: rSP(15),
            ),
          ),
          onTap: () {
            final models = widget.isDouble
                ? LotteryCartStore.doubleLotteryModels
                : LotteryCartStore.bigLotteryModels;
            models.remove(model);
            setState(() {});
          },
        ),
      ],
      actionPane: SlidableDrawerActionPane(),
    );
  }

  _redeemLottery() async {
    GSDialog.of(context).showLoadingDialog(context, '兑换中');
    Map<String, dynamic> params = {
      'lotteryId': widget.isDouble ? 1 : 2,
      'num': multiply,
    };
    params.putIfAbsent('item', () {
      List<Map> item = [];
      List<Map> singleLottery = lotteryItem(101);
      List<Map> multiLottery = lotteryItem(102);
      List<Map> childLottery = lotteryItem(103);
      if (singleLottery != null && singleLottery.isNotEmpty) {
        singleLottery.forEach((element) {
          item.add(element);
        });
      }
      if (multiLottery != null && multiLottery.isNotEmpty) {
        multiLottery.forEach((element) {
          item.add(element);
        });
      }
      if (childLottery != null && childLottery.isNotEmpty) {
        childLottery.forEach((element) {
          item.add(element);
        });
      }
      return item;
    });
    ResultData resultData = await HttpManager.post(
      LotteryAPI.redeem_shots,
      params,
    );
    if (resultData.data['code'] == "SUCCESS") {
      GSDialog.of(context).dismiss(context);
      showToast('下单成功');
      LotteryCartStore.clear(widget.isDouble
          ? LotteryType.DOUBLE_LOTTERY
          : LotteryType.BIG_LOTTERY);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      GSDialog.of(context).dismiss(context);
      showToast('兑换失败');
    }
  }

  List<Map> lotteryItem(int code) {
    final models = widget.isDouble
        ? LotteryCartStore.doubleLotteryModels
        : LotteryCartStore.bigLotteryModels;

    List<Map> result = [];
    List<LotteryCartModel> cartTempModels = [];
    models.forEach((element) {
      if (element.lotteryTypeCode == code) {
        cartTempModels.add(element);
      }
    });
    if (code == 101) {
      int rangeIndex = 0;
      for (int i = 0; i < cartTempModels.length; i += 5) {
        List<String> tempBalls = [];
        int money = 0;
        cartTempModels
            .getRange(
                rangeIndex,
                (rangeIndex + 5) >= cartTempModels.length
                    ? cartTempModels.length
                    : (rangeIndex + 5))
            .forEach((element) {
          money += element.shots * 2;
          tempBalls.add(convertCartBalls(element));
        });
        rangeIndex += 5;
        result.add({
          'anteCode': tempBalls,
          'playType': code,
          'money': money,
        });
      }
    } else {
      cartTempModels.forEach((element) {
        result.add({
          'anteCode': [convertCartBalls(element)],
          'playType': code,
          'money': element.shots * 2,
        });
      });
    }
    return result;
  }
}
