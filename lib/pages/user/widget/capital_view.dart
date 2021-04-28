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
    // return _new();
    return _old(context);
  }

  _new() {
    return Container(
      margin: EdgeInsets.only(bottom: rSize(10)),
      padding: EdgeInsets.all(rSize(10)),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RichText(
              text: TextSpan(
                  text: "可用余额(元): ",
                  style:
                      AppTextStyle.generate(14 * 2.sp, color: Colors.grey[600]),
                  children: [
                TextSpan(
                  // text: getStore().state.userBrief.asset.fund.toStringAsFixed(2),
                  text: '测试',
                  style: AppTextStyle.generate(18 * 2.sp,
                      color: AppColor.themeColor),
                )
              ])),
          Spacer(),
          CustomImageButton(
            title: "提现",
            fontSize: 13 * 2.sp,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            padding:
                EdgeInsets.symmetric(vertical: rSize(1), horizontal: rSize(10)),
            border: Border.all(color: Colors.grey[500], width: 0.8 * 2.w),
            color: Colors.grey[500],
            onPressed: () {
              if (widget.listener == null) return;
              widget.listener();
            },
          )
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
