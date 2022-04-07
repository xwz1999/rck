import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/banlance/user_balance_detail_page.dart';
import 'package:jingyaoyun/pages/user/banlance/withdraw_history_page.dart';
import 'package:jingyaoyun/pages/user/banlance/withdraw_page.dart';

import 'package:jingyaoyun/widgets/image_scaffold.dart';
import 'package:jingyaoyun/widgets/recook_back_button.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import '../user_cash_withdraw_page.dart';


class UserBalancePage extends StatefulWidget {
  UserBalancePage({
    Key key,
  }) : super(key: key);

  @override
  _UserBalancePageState createState() => _UserBalancePageState();
}

class _UserBalancePageState extends State<UserBalancePage> {
  GSRefreshController _refreshController =
  GSRefreshController(initialRefresh: true);



  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ImageScaffold(
      systemStyle: SystemUiOverlayStyle.light,
      path: Assets.withdrawalBg.path,
      bodyColor:Colors.white,
      appbar: Container(
        color: Colors.transparent,
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            RecookBackButton(
              white: true,
            ),
            Text(
              "余额提现",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.rsp,
              ),
            ),
            IconButton(
                icon: Icon(
                  AppIcons.icon_back,
                  size: 17,
                  color:  Colors.transparent ,
                ),
                onPressed: () {

                }),
          ],
        ),
      ),


            body: _bodyWidget()



    );

  }

  _bodyWidget() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12.rw),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [

        20.hb,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.rw),
          height: 214.rw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.rw),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),

                color: Color(0x4FD93F37),
                blurRadius: 16.rw,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              72.hb,
              Text(
                '可提现金额(元)',
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
              ),
              50.hb,
              Text(
                TextUtils.getCount1(( UserManager.instance.userBrief.balance ?? 0.0)),
                style: TextStyle(fontSize: 32.rsp, color: Color(0xFF333333),fontWeight: FontWeight.bold),
              ),
              70.hb,

              UserManager.instance.userBrief.isEnterPrise?SizedBox():  Padding(
                padding:  EdgeInsets.symmetric(horizontal:38.rw ),
                child: GestureDetector(
                  onTap: () async{
                    Get.to(()=>WithDrawPage());

                    // if(UserManager.instance.userBrief.balance<=0){
                    //   BotToast.showText(text: '余额不足，无法提现');
                    // }else{
                    //   if(!UserManager.instance.userBrief.isEnterPrise){
                    //     AppRouter.push(context, RouteName.USER_CASH_WITHDRAW_PAGE,
                    //         arguments: UserCashWithdrawPage.setArguments(
                    //             amount: UserManager.instance.userBrief.balance.toDouble()));
                    //   }else{
                    //     Get.to(()=>WithDrawPage());
                    //   }
                    // }




                  },
                  child: Container(
                    height: 36.rw,
                    width: double.infinity,

                    alignment:Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        //渐变位置
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFE05346),
                            Color(0xFFDB1E1E)
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(18.rw)),
                    ),
                    child:       Text(
                    '提现',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.rsp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        32.hb,
        Row(
          children: [
            GestureDetector(
              onTap: (){
                Get.to(()=>UserBalanceDetailPage());
              },
              child: Container(

                width: 172.rw,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.rw),
                  border: Border.all(color: Color(0xFFEEEEEE),width: 1.rw),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.rw,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.balanceDetails.path,width: 48.rw,height: 48.rw,),
                    30.wb,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '余额明细',
                          style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333),fontWeight: FontWeight.bold),
                        ),
                        16.hb,
                        Text(
                          '查看收益来源',
                          style: TextStyle(fontSize: 12.rsp, color: Color(0xFF999999)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            14.wb,
            GestureDetector(
              onTap: (){
                //AppRouter.push(context, RouteName.CASH_WITHDRAW_HISTORY_PAGE);
                Get.to(()=>WithdrawHistoryPage());
              },
              child: Container(
                width: 172.rw,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.rw),
                  border: Border.all(color: Color(0xFFEEEEEE),width: 1.rw),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.rw),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.withdrawalRecord.path,width: 48.rw,height: 48.rw,),
                    30.wb,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '提现记录',
                          style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333),fontWeight: FontWeight.bold),
                        ),
                        16.hb,
                        Text(
                          '查看审核结果',
                          style: TextStyle(fontSize: 12.rsp, color: Color(0xFF999999)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

}
