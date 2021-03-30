import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/lottery/lottery_cart_model.dart';
import 'package:recook/pages/lottery/models/lottery_redeem_detail_model.dart';
import 'package:recook/pages/lottery/models/lottery_redeem_history_model.dart';
import 'package:recook/pages/lottery/redeem_lottery_page.dart';
import 'package:recook/pages/lottery/tools/lottery_tool.dart';
import 'package:recook/pages/lottery/widget/lottery_grid_view.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';

class LotteryOrderDetailPage extends StatefulWidget {
  final LotteryRedeemHistoryModel model;
  LotteryOrderDetailPage({Key key, @required this.model}) : super(key: key);

  @override
  _LotteryOrderDetailPageState createState() => _LotteryOrderDetailPageState();
}

class _LotteryOrderDetailPageState extends State<LotteryOrderDetailPage> {
  LotteryRedeemDetailModel model;
  @override
  void initState() {
    super.initState();
    HttpManager.post(LotteryAPI.lottery_order_detail, {
      'orderId': widget.model.orderId,
    }).then((resultData) {
      if (resultData.data['data'] == null) {
        showToast(resultData.data['msg']);
        Navigator.pop(context);
      } else {
        model = LotteryRedeemDetailModel.fromJson(resultData.data['data']);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LotteryScaffold(
      title: '我的订单',
      red: true,
      appBarBottom: PreferredSize(
        preferredSize: Size.fromHeight(rSize(40)),
        child: Container(
          height: rSize(40),
          color: Color(0xFFFFF9ED),
          padding: EdgeInsets.symmetric(horizontal: rSize(15)),
          alignment: Alignment.centerLeft,
          child: DefaultTextStyle(
            style: TextStyle(
              color: Color(0xFFE02020),
              fontSize: rSP(14),
            ),
            child: Row(
              children: [
                Text(widget.model.lotteryName),
                VerticalDivider(
                  color: Color(0xFFF8DCCF),
                  width: rSize(14),
                  thickness: rSize(1),
                  indent: rSize(10),
                  endIndent: rSize(10),
                ),
                Text('第${widget.model.number}期'),
              ],
            ),
          ),
        ),
      ),
      body: model == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                _childBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              redeemNotDone ? '-' : model.ticketMoney,
                              style: TextStyle(
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: rSize(10)),
                            Text('中奖金额(元)'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              statusMap[model.status],
                              style: TextStyle(
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: rSize(10)),
                            Text('订单状态'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              model.money,
                              style: TextStyle(
                                color: Color(0xFFDB2D2D),
                              ),
                            ),
                            SizedBox(height: rSize(10)),
                            Text('投注金额(元)'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: rSize(8)),
                _childBox(
                  child: Row(
                    children: [
                      Text('预计开奖'),
                      Spacer(),
                      Text(
                        model.stopTime,
                        style: TextStyle(
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: rSize(8)),
                _childBox(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('投注信息'),
                          Spacer(),
                          Text(
                            '${(int.parse(model.money) / model.num) ~/ 2}注 ${model.num}倍',
                            style: TextStyle(
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _childBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: rSize(20),
                        ),
                        child: Text(
                          typeMap[model.betType],
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: rSP(14),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: model.code
                              .map(
                                (e) => Container(
                                  child: LotteryGridView(
                                    model: LotteryCartModel(
                                      type: model.lotteryName == "双色球"
                                          ? LotteryType.DOUBLE_LOTTERY
                                          : LotteryType.BIG_LOTTERY,
                                      redBalls: ParseBall(e).redBalls,
                                      blueBalls: ParseBall(e).blueBalls,
                                      focusedRedBalls:
                                          ParseBall(e).focusRedBalls,
                                      focusedBlueBalls:
                                          ParseBall(e).focusBlueBalls,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: rSize(8)),
                _childBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '订单详情',
                        style: TextStyle(color: Color(0xFF333333)),
                      ),
                      SizedBox(height: rSize(10)),
                      Container(
                        height: rSize(128),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _childList('订单编号', model.orderId),
                            _childList('下单时间', model.betTime),
                            _childList('用户姓名', model.userProfile.name),
                            _childList(
                                '用户身份证号',
                                '${model.userProfile.idCard.substring(
                                  0,
                                  3,
                                )}***********${model.userProfile.idCard.substring(
                                  model.userProfile.idCard.length - 4,
                                )}'),
                            _childList('凭证手机号', model.userProfile.mobile),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  _childBox({@required Widget child}) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: rSP(14),
        color: Color(0xFF999999),
      ),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(rSize(16)),
        child: child,
      ),
    );
  }

  _childList(String prefix, String suffix) {
    return Row(
      children: [
        Text(prefix),
        Spacer(),
        Text(
          suffix,
          style: TextStyle(
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Map<int, String> statusMap = {
    1: "未出票",
    2: "待开奖",
    3: "未中奖",
    4: "已中奖",
    5: "出票失败已退回",
  };

  Map<int, String> typeMap = {
    101: "单式",
    102: "复式",
    103: "胆拖",
  };

  bool get redeemNotDone =>
      model.status == 1 || model.status == 2 || model.status == 5;
}
