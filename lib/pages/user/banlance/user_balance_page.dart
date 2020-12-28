import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/user_cash_withdraw_page.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/constants/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class UserBalancePage extends StatefulWidget {
  UserBalancePage({Key key}) : super(key: key);

  @override
  _UserBalancePageState createState() => _UserBalancePageState();
}

class _UserBalancePageState extends State<UserBalancePage> {
  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '我的余额',
      whiteBg: true,
      actions: [
        CustomImageButton(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          onPressed: () {
            AppRouter.push(context, RouteName.USER_CASH_WITHDRAW_PAGE,
                arguments: UserCashWithdrawPage.setArguments(
                    amount: UserManager.instance.userBrief.balance.toDouble()));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/rui_page_balance.png",
                width: 12.w,
                height: 12.w,
              ),
              3.wb,
              '余额提现'.text.size(10.sp).black.make(),
            ],
          ),
        ),
      ],
      body: Column(
        children: [
          VxBox(
            child: [
              16.wb,
              104.hb,
              [
                '可使用(元)'.text.size(14.sp).color(Color(0xFF333333)).make(),
                4.hb,
                '680.00X'.text.size(30).color(Color(0xFFD40000)).make(),
              ].column(crossAlignment: CrossAxisAlignment.start),
              Spacer(),
              [
                '累计提现(元)'.text.size(14.sp).color(Color(0xFF333333)).make(),
                4.hb,
                '680.00X'.text.size(30).black.make(),
              ].column(crossAlignment: CrossAxisAlignment.end),
              16.wb,
            ].row(),
          ).color(Colors.white).make(),
          <Widget>[
            64.hb,
            16.wb,
            MaterialButton(
              color: Colors.white,
              shape: StadiumBorder(),
              elevation: 0,
              onPressed: () {},
              child: [
                'TEST'.text.color(Color(0xFF333333)).size(13.sp).make(),
                Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFFBEBEBE),
                ),
              ].row(),
            ),
            Spacer(),
            MaterialButton(
              color: Colors.white,
              shape: StadiumBorder(),
              elevation: 0,
              onPressed: () {},
              child: [
                'TEST年TEST月'.text.color(Color(0xFF333333)).size(13.sp).make(),
                Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFFBEBEBE),
                ),
              ].row(),
            ),
            16.wb,
          ].row().material(color: Color(0xFFF5F5F5)),
          ListView().material(color: Color(0xFFF9F9FB)).expand(),
        ],
      ),
    );
  }
}
