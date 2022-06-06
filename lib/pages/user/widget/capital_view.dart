
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/pages/user/banlance/user_balance_page.dart';

class CapitalView extends StatefulWidget {
  final Function()? listener;

  const CapitalView({Key? key, this.listener,})
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
    return GestureDetector(
      onTap: () {
        Get.to(() => UserBalancePage());
      },
      child: Container(
        height: 66.rw,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(
                        text: "可提现金额:  ",
                        style: AppTextStyle.generate(14 * 2.sp,
                            color: Color(0xFFFFDEAA),fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            // text: getStore().state.userBrief.asset.fund.toStringAsFixed(2),
                            text: '¥',
                            style: AppTextStyle.generate(12 * 2.sp,
                                color: Color(0xFFFFDEAA),fontWeight: FontWeight.bold),
                          ),
                      TextSpan(
                        // text: getStore().state.userBrief.asset.fund.toStringAsFixed(2),
                        text: TextUtils.getCount1(( getStore().state.userBrief!.balance ?? 0.0)),
                        style: AppTextStyle.generate(16 * 2.sp,
                            color: Color(0xFFFFDEAA),fontWeight: FontWeight.bold),
                      )
                    ])),
                15.hb,
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

            Container(
              width: 32.rw,
              height: 32.rw,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Assets.icUserWithdrawal.path
                  )
                )

              ),

            ),
          ],
        ),
      ),
    );
  }

}
