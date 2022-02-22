
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/pages/user/banlance/user_balance_page.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';

class CapitalView extends StatefulWidget {
  final Function() listener;

  const CapitalView({Key key, this.listener,})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CapitalViewState();
  }
}

class _CapitalViewState extends BaseStoreState<CapitalView> {
  @override
  bool needStore() {
    return true;
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return _new();
  }

  _new() {
    return Container(
      height: 62.rw,
      margin: EdgeInsets.only(top: 12.rw, left: 15.rw, right: 15.rw),
      padding:
          EdgeInsets.only(left: 15.rw, right: 15.rw, top: 10.rw, bottom: 10.rw),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(R.ASSETS_USER_USER_WITHDRAWAL_BG_PNG),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.rw), topRight: Radius.circular(8.rw)),
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                R.ASSETS_USER_USER_WITHDRAWAL_VIP_PNG,
                width: 16.rw,
                height: 16.rw,
              ),
              8.hb,
              Text(
                '${UserLevelTool.currentRoleLevel()}',
                style: TextStyle(fontSize: 10.rsp, color: Color(0xFFFFDEAA)),
              )
            ],
          ),
          17.wb,
          Container(
            width: 1.rw,
            height: 34.rw,
            color: Colors.white,
          ),
          30.wb,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                      text: "余额: ",
                      style: AppTextStyle.generate(14 * 2.sp,
                          color: Color(0xFFFFDEAA)),
                      children: [
                        TextSpan(
                          // text: getStore().state.userBrief.asset.fund.toStringAsFixed(2),
                          text: '¥',
                          style: AppTextStyle.generate(12 * 2.sp,
                              color: Color(0xFFFFDEAA)),
                        ),
                    TextSpan(
                      // text: getStore().state.userBrief.asset.fund.toStringAsFixed(2),
                      text: (getStore().state.userBrief.balance ?? 0.0)
                          .toDouble()
                          .toStringAsFixed(2),
                      style: AppTextStyle.generate(16 * 2.sp,
                          color: Color(0xFFFFDEAA)),
                    )
                  ])),
              5.hb,
              Opacity(
                opacity: 0.85,
                child: Text(
                  '每月10日、25日审核提现申请',
                  style: TextStyle(fontSize: 10.rsp, color: Color(0xFFF5D7A7),),
                ),
              )
            ],
          ),
          Spacer(),
          UserLevelTool.currentRoleLevelEnum()==UserRoleLevel.subsidiary?SizedBox():
          GestureDetector(
            onTap: () {
              Get.to(() => UserBalancePage());
            },
            child: Container(
              width: 73.rw,
              height: 28.rw,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    //渐变位置
                    begin: Alignment.centerLeft, //右上
                    end: Alignment.centerRight, //左下
                    //[渐变起始点, 渐变结束点]
                    //渐变颜色[始点颜色, 结束颜色]
                    colors: [Color(0xFFFEDCAB), Color(0xFFFEBC73)]),
                borderRadius: BorderRadius.all(Radius.circular(16.rw)),
              ),
              alignment: Alignment.center,
              child: Text(
                '立即提现',
                style: TextStyle(fontSize: 12.rsp, color: Color(0xFF403D3A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
