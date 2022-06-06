import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/recharge/recharge_history_page.dart';
import 'package:recook/pages/user/recharge/recharge_page.dart';
import 'package:recook/pages/user/recharge/user_recharge_detail_page.dart';
import 'package:recook/widgets/image_scaffold.dart';
import 'package:recook/widgets/recook_back_button.dart';
import 'package:recook/widgets/refresh_widget.dart';


class UserRechargePage extends StatefulWidget {
  UserRechargePage({
    Key? key,
  }) : super(key: key);

  @override
  _UserRechargePageState createState() => _UserRechargePageState();
}

class _UserRechargePageState extends State<UserRechargePage> {
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
              "预存款",
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
                '预存款金额(元)',
                style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333)),
              ),
              50.hb,
              Text(
                TextUtils.getCount1(( UserManager.instance!.userBrief!.deposit ?? 0.0))!,
                style: TextStyle(fontSize: 32.rsp, color: Color(0xFF333333),fontWeight: FontWeight.bold),
              ),
              70.hb,

              Padding(
                padding:  EdgeInsets.symmetric(horizontal:38.rw ),
                child: GestureDetector(
                  onTap: () async{
                    Get.to(()=>RechargePage());

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
                      '充值',
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
                Get.to(()=>UserRechargeDetailPage());
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
                          '交易明细',
                          style: TextStyle(fontSize: 14.rsp, color: Color(0xFF333333),fontWeight: FontWeight.bold),
                        ),
                        16.hb,
                        Text(
                          '查看金额流水',
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
                Get.to(()=>RechargeHistoryPage());
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
                          '充值记录',
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
