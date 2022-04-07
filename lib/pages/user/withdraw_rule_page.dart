import 'package:flutter/material.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/constants/styles.dart';
import 'package:jingyaoyun/pages/user/user_set_password_again.dart';
import 'package:jingyaoyun/widgets/custom_app_bar.dart';
import 'package:jingyaoyun/widgets/keyboard/CustomBoxPasswordFieldWidget.dart';
import 'package:jingyaoyun/widgets/keyboard/keyboard_widget.dart';
import 'package:jingyaoyun/widgets/keyboard/pay_password.dart';
import 'package:jingyaoyun/widgets/toast.dart';

class WithdrawRulePage extends StatefulWidget {
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

          Text(
              '1.计算公式',style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16.rsp,
              fontWeight: FontWeight.bold
          )
          ),
          24.hb,

          Text(
              '提现金额*税率',style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 14.rsp,

          )
          ),
          48.hb,

          Text(
              '2.增值税',style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16.rsp,
              fontWeight: FontWeight.bold
          )
          ),
          24.hb,


          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFE8E8E8),width: 1.rw)
            ),
            child: Column(
              children: [
                getRow('类型','税率',false,isTitle: true),
                getRow('货物','13%',true,isTitle: false),
                getRow('服务','6%',false,isTitle: false),

              ],
            ),
          ),


          48.hb,

          Text(
              '3.增值税附加税（增值税*12%）',style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16.rsp,
              fontWeight: FontWeight.bold
          )
          ),
          24.hb,

          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE8E8E8),width: 1.rw)
            ),
            child: Column(
              children: [
                getRow('类型','税率',false,isTitle: true),
                getRow('城市维护建设税','7%',true),
                getRow('地方教育附加税','2%',false),
                getRow('教育费附加','3%',true),
                getRow('小计','12%',false),
              ],
            ),
          ),
          48.hb,
          Text(
              '4.个人所得税的综合税率',style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16.rsp,
              fontWeight: FontWeight.bold
          )
          ),
          24.hb,

          Text(
              '综合税率：1%',style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 14.rsp,

          )
          ),

        ],
      ),
    );
  }




  getRow(String a,String b,bool isWhite,{bool isTitle = false}){
    return Container(
      height: 48.rw,
      child: Row(
        children: [
          Expanded(child: Container(

              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isWhite?Colors.white:Color(0xFFF9F9F9)
              ),
              child: Text(
                a,style: isTitle? TextStyle(
                  color: Color(0xFF333333),
                fontSize: 14.rsp,
                fontWeight: FontWeight.bold
              ):TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14.rsp,
              )
              ),
          )),
          Container(
            height: double.infinity,
            width: 1.rw,
            color: Color(0xFFE8E8E8),
          ),

          Expanded(child: Container(

            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isWhite?Colors.white:Color(0xFFF9F9F9)
            ),
            child: Text(
                b,style: isTitle? TextStyle(
                color: Color(0xFF333333),
                fontSize: 14.rsp,
                fontWeight: FontWeight.bold
            ):TextStyle(
              color: Color(0xFF333333),
              fontSize: 14.rsp,
            )
            ),
          )),
        ],
      ),
    );
  }

}
