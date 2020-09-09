import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/lottery/widget/lottery_scaffold.dart';

class LotteryOrderDetailPage extends StatefulWidget {
  final dynamic arguments;
  LotteryOrderDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  _LotteryOrderDetailPageState createState() => _LotteryOrderDetailPageState();
}

class _LotteryOrderDetailPageState extends State<LotteryOrderDetailPage> {
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
                Text('双色球'),
                VerticalDivider(
                  color: Color(0xFFF8DCCF),
                  width: rSize(14),
                  thickness: rSize(1),
                  indent: rSize(10),
                  endIndent: rSize(10),
                ),
                Text('第20200823期'),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          _childBox(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '-',
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
                        '未出票',
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
                        '90',
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
                  '2020-08-22 21:15:00',
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
                      '60注 1倍',
                      style: TextStyle(
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
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
                      _childList('订单编号', 'TE20202020010023012'),
                      _childList('下单时间', '2020-08-20 13:22:08'),
                      _childList('用户姓名', '邓嵘嵘'),
                      _childList('用户身份证号', '330***********5016'),
                      _childList('凭证手机号', '13609391873'),
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
}
