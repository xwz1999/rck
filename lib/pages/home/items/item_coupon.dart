/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-07-05  17:05 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/models/base_model.dart';
import 'package:recook/pages/home/classify/mvp/coupon_list_model_impl.dart';
import 'package:recook/utils/time_transition_util.dart';
import 'package:recook/widgets/text_button.dart' as TButton;
import 'package:recook/models/coupon_list_model.dart';
import 'package:recook/widgets/toast.dart';

class CouponItem extends StatefulWidget {
  final Coupon coupon;

  const CouponItem({Key key, this.coupon}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CouponItemState();
  }
}

class _CouponItemState extends State<CouponItem> {
  Color _mainColor = Color(0xFFED2454);

  @override
  Widget build(BuildContext context) {
    bool discount = widget.coupon.type == 1;
    bool common = widget.coupon.scope == 0;
//    String discountString = widget.coupon.discount % 1 != 0
//        ? widget.coupon.discount.toString()
//        : widget.coupon.discount.round().toString();

    bool received = false;
//    bool received = widget.coupon.isReceived == 1;
    Color bgColor = received ? Colors.grey[200] : Color(0xFFFDE8E8);
    Color textColor = received ? Colors.grey : _mainColor;

    return Stack(children: [
      Container(
        height: rSize(85),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: bgColor),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenAdapterUtils.setHeight(5), horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          text: discount ? "" : "￥",
                          style: TextStyle(color: textColor, fontSize: 14),
                          children: [
                            new TextSpan(
                              text: widget.coupon.cash.toString(),
                              style: new TextStyle(
                                  color: textColor,
                                  fontSize: ScreenAdapterUtils.setSp(25),
                                  textBaseline: TextBaseline.ideographic,
                                  fontWeight: FontWeight.w500),
                            ),
                            new TextSpan(
                              text: !discount ? '' : " 折",
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: ScreenAdapterUtils.setSp(14)),
                            ),
                            new TextSpan(
                              text: " (${widget.coupon.explanation})",
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: ScreenAdapterUtils.setSp(13)),
                            ),
                          ]),
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      widget.coupon.threshold == 0
                          ? "全场通用无限制"
                          : "满${widget.coupon.threshold}可用",
                      style: TextStyle(
                          color: textColor,
                          fontSize: ScreenAdapterUtils.setSp(12)),
                    ),
                    Text(
                      "有效期 ${TimeTransitionUtil.timeToFormatString(
                        ".",
                        timeString: widget.coupon.startTime,
                      )}-${TimeTransitionUtil.timeToFormatString(
                        ".",
                        timeString: widget.coupon.endTime,
                      )}",
                      style: TextStyle(
                          color: textColor,
                          fontSize: ScreenAdapterUtils.setSp(12)),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 8,
                  width: 15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(14))),
                ),
                Expanded(
                  child: Image.asset(
                    "assets/dashed_line.png",
                    width: 0.5,
                    color: textColor,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 8,
                  width: 15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(14))),
                ),
              ],
            ),
            TButton.TextButton(
              padding: EdgeInsets.symmetric(horizontal: rSize(20)),
              radius: BorderRadius.horizontal(right: Radius.circular(11)),
              height: double.infinity,
              title: "立即领取",
              fontWeight: FontWeight.w500,
              font: ScreenAdapterUtils.setSp(16),
              textColor: textColor,
              backgroundColor: bgColor,
              onTap: () {
                CouponListImpl.receiveCoupon(
                        UserManager.instance.user.info.id, widget.coupon.id)
                    .then((BaseModel model) {
                  if (model.code != HttpStatus.SUCCESS) {
                    Toast.showInfo(model.msg, color: Colors.red);
                    return;
                  } else {
                    Toast.showInfo("领取成功", color: AppColor.themeColor);
                  }
                });
              },
            )
          ],
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        child: Offstage(
            offstage: !received,
            child: Icon(
              AppIcons.icon_coupon_received,
              size: 60,
            )),
      )
    ]);
  }
}
