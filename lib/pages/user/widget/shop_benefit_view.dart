import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/constants.dart';
import 'package:jingyaoyun/pages/user/functions/user_benefit_func.dart';
import 'package:jingyaoyun/pages/user/model/user_benefit_model.dart';
import 'package:jingyaoyun/pages/user/user_benefit_page.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';

class ShopBenefitView extends StatefulWidget {
  ShopBenefitView({Key key}) : super(key: key);

  @override
  ShopBenefitViewState createState() => ShopBenefitViewState();
}

class ShopBenefitViewState extends State<ShopBenefitView> {
  UserBenefitModel _model = UserBenefitModel.zero();

  Future updateBenefit() async {
    _model = await UserBenefitFunc.update();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateBenefit();
  }

  @override
  Widget build(BuildContext context) {
    return CustomImageButton(
      padding: EdgeInsets.zero,
      onPressed: () => CRoute.push(context, UserBenefitPage()),
      child: VxBox(
        child: <Widget>[
          <Widget>[
            '我的收益'
                .text
                .color(Color(0xFF333333))
                .size(16.rsp)
                .bold
                .make()
                .p(10.rw),
            Spacer(),
            Icon(Icons.keyboard_arrow_right,
                size: 22, color: Color(0xff999999)),
            10.wb,
          ].row(),
          Divider(
            color: Color(0xFFE6E6E6),
            height: 1.rw,
            thickness: 1.rw,
          ),
          SizedBox(
            height: 66.rw,
            child: Row(
              children: [
                <Widget>[
                  (_model?.data?.monthExpect ?? 0)
                      .toStringAsFixed(2)
                      .text
                      .size(18.rsp)
                      .color(Color(0xFF333333))
                      .make(),
                  6.hb,
                  '本月预估'.text.size(12.rsp).color(Color(0xFF333333)).make(),
                ].column().expand(),
                VerticalDivider(
                  color: Color(0xFFE6E6E6),
                  width: 1.rw,
                  thickness: 1.rw,
                  indent: 16.rw,
                  endIndent: 16.rw,
                ),
                <Widget>[
                  (_model?.data?.dayExpect ?? 0)
                      .toStringAsFixed(2)
                      .text
                      .size(18.rsp)
                      .color(Color(0xFF333333))
                      .make(),
                  6.hb,
                  '今日预估'.text.size(12.rsp).color(Color(0xFF333333)).make(),
                ].column().expand(),
              ],
            ),
          ),
          Divider(
            color: Color(0xFFE6E6E6),
            height: 1.rw,
            thickness: 1.rw,
          ),
          <Widget>[
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  '上月结算'.text.size(12.rsp).color(Color(0xFF666666)).make(),
                  '¥${_model?.data?.lastMonthIncome ?? 0.toStringAsFixed(2)}'
                      .text
                      .size(12.rsp)
                      .color(Color(0xFFD7BE8E))
                      .make(),
                ]).expand(),
            30.hb,
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  '上月预估'.text.size(12.rsp).color(Color(0xFF666666)).make(),
                  '¥${_model?.data?.lastMonthExpect ?? 0.toStringAsFixed(2)}'
                      .text
                      .size(12.rsp)
                      .color(Color(0xFFD7BE8E))
                      .make(),
                ]).expand(),
          ].row(),
        ].column(crossAlignment: CrossAxisAlignment.start),
      ).color(Colors.white).withRounded(value: 10).make(),
    ).pOnly(left: 10, right: 10, bottom: 10);
  }
}
