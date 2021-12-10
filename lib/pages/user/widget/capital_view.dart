/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/6  5:20 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';

import 'package:extended_text/extended_text.dart';
import 'package:get/get.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/upgradeCard/upgrade_card_page_v2.dart';
import 'package:recook/pages/user/banlance/user_balance_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CapitalView extends StatefulWidget {
  final Function() listener;
  final int cardCount;

  const CapitalView({Key key, this.listener, @required this.cardCount})
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
    //return _old(context);
  }

  _new() {
    return Container(
      height: 62.rw,
      margin: EdgeInsets.only(top: 12.rw, left: 15.rw, right: 15.rw),
      padding:
          EdgeInsets.only(left: 15.rw, right: 15.rw, top: 13.rw, bottom: 13.rw),
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
                '店铺',
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
          // CustomImageButton(
          //   title: "提现",
          //   fontSize: 12.rsp,
          //
          //
          //   padding:
          //       EdgeInsets.symmetric(vertical: 8.rw, horizontal:12.rw),
          //   border: Border.all(color: Colors.grey[500], width: 0.8 * 2.w),
          //   color: Colors.grey[500],
          //   onPressed: () {
          //
          //   },
          // )
        ],
      ),
    );
  }

  Container _old(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            height: 40,
            child: Text(
              "我的资产",
              style: AppTextStyle.generate(16, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          Container(
            height: 65,
            child: Row(
              children: <Widget>[
                // _otherItem(
                //     "优惠券(张)",
                //     getStore()
                //         .state
                //         .userBrief
                //         .myAssets
                //         .couponNum
                //         .toInt()
                //         .toString(), onTap: () {
                //   push(RouteName.MY_COUPON_PAGE);
                // }),
                _otherItem(
                    ExtendedText.rich(TextSpan(children: [
                      TextSpan(
                        text: "瑞币(个) ",
                        style: AppTextStyle.generate(12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400),
                      ),
                      WidgetSpan(
                          child: GestureDetector(
                        onTap: () {
                          Alert.show(
                              context,
                              NormalTextDialog(
                                title: "瑞币",
                                content: "瑞币可随时转到余额并提现",
                                items: ["确认"],
                                listener: (index) {
                                  Alert.dismiss(context);
                                },
                              ));
                        },
                        child: Icon(
                          Icons.help_outline,
                          color: Colors.grey[700],
                          size: 14,
                        ),
                      )),
                    ])),
                    getStore()
                        .state
                        .userBrief
                        .myAssets
                        .coinNum
                        .toDouble()
                        .toStringAsFixed(2), onTap: () {
                  AppRouter.push(context, RouteName.RUI_COIN_PAGE);
                }),
                _otherItem(
                  "余额（元）",
                  (getStore().state.userBrief.balance ?? 0.0)
                      .toDouble()
                      .toStringAsFixed(2),
                  onTap: () => CRoute.push(context, UserBalancePage()),
                ),
                _otherItem(
                  "权益卡(张)",
                  widget.cardCount.toString(),
                  onTap: () {
                    Get.to(() => UpgradeCardPageV2());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _otherItem(title, String value, {GestureTapCallback onTap}) {
    return Expanded(
      child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  value.toString(),
                  style: AppTextStyle.generate(18, fontWeight: FontWeight.w500),
                ),
                title is String
                    ? Text(
                        title,
                        style: AppTextStyle.generate(12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400),
                      )
                    : title,
              ],
            ),
          )),
    );
  }
}
