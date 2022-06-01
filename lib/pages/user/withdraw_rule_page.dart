import 'package:flutter/material.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/constants/styles.dart';
import 'package:recook/widgets/custom_app_bar.dart';

class WithdrawRulePage extends StatefulWidget {
  final int type;

  ///1为个人纳税规则 2 一般纳税人 3小规模纳税人

  const WithdrawRulePage({Key key, @required this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WithdrawRulePageState();
  }
}

class _WithdrawRulePageState extends BaseStoreState<WithdrawRulePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Scaffold(
      // backgroundColor: AppColor.frenchColor,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        elevation: 0,
        title: "税费规则",
        themeData: AppThemes.themeDataGrey.appBarTheme,
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.rw),
      child: ListView(
        children: <Widget>[
          40.hb,
          Text('税费计算公式',
              style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16.rsp,
                  fontWeight: FontWeight.bold)),
          24.hb,
          Text(
              widget.type == 1
                  ? '提现金额*综合税率\n货物类综合税率=13%(含增值税、增值税附加税、个人所得税\n服务类综合税率=7%(含增值税、增值税附加税、个人所得税)'
                  : widget.type == 2
                      ? '结算金额/（1+增值税税率）*（增值税税率-6%）*（1+12%）'
                      : '结算金额/（1+增值税税率）*增值税税率*（1+12%）',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 14.rsp,
               )),
          48.hb,
          Text('1.增值税',
              style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16.rsp,
                  fontWeight: FontWeight.bold)),
          24.hb,
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE8E8E8), width: 1.rw)),
            child: Column(
              children: [
                getRow('类型', '税率', false, isTitle: true),
                getRow('货物', '13%', true, isTitle: false),
                getRow('服务', '6%', false, isTitle: false),
              ],
            ),
          ),
          48.hb,
          Text('2.增值税附加税（增值税*12%）',
              style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16.rsp,
                  fontWeight: FontWeight.bold)),
          24.hb,
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE8E8E8), width: 1.rw)),
            child: Column(
              children: [
                getRow('类型', '税率', false, isTitle: true),
                getRow('城市维护建设税', '7%', true),
                getRow('地方教育附加税', '2%', false),
                getRow('教育费附加', '3%', true),
                getRow('小计', '12%', false),
              ],
            ),
          ),
          widget.type == 1?48.hb:SizedBox(),
          widget.type == 1?  Text('3.个人所得税的综合税率',
              style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16.rsp,
                  fontWeight: FontWeight.bold)):SizedBox(),
          widget.type == 1?24.hb:SizedBox(),
          widget.type == 1?Text('综合税率：1%',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 14.rsp,
              )):SizedBox(),
        ],
      ),
    );
  }

  getRow(String a, String b, bool isWhite, {bool isTitle = false}) {
    return Container(
      height: 48.rw,
      child: Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isWhite ? Colors.white : Color(0xFFF9F9F9)),
            child: Text(a,
                style: isTitle
                    ? TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14.rsp,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14.rsp,
                      )),
          )),
          Container(
            height: double.infinity,
            width: 1.rw,
            color: Color(0xFFE8E8E8),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isWhite ? Colors.white : Color(0xFFF9F9F9)),
            child: Text(b,
                style: isTitle
                    ? TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14.rsp,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14.rsp,
                      )),
          )),
        ],
      ),
    );
  }
}
