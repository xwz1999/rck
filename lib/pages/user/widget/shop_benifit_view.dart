import 'package:flutter/material.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/constants.dart';

class ShopBenifitView extends StatelessWidget {
  const ShopBenifitView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomImageButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: VxBox(
        child: <Widget>[
          <Widget>[
            '我的收益'
                .text
                .color(Color(0xFF333333))
                .size(16.sp)
                .bold
                .make()
                .pSymmetric(v: 10.w, h: 5.w),
            Spacer(),
            Icon(Icons.keyboard_arrow_right,
                size: 22, color: Color(0xff999999)),
            10.wb,
          ].row(),
          Divider(
            color: Color(0xFFE6E6E6),
            height: 1.w,
            thickness: 1.w,
          ),
          SizedBox(
            height: 66.w,
            child: Row(
              children: [
                <Widget>[
                  '1223.56X'.text.size(18.sp).color(Color(0xFF333333)).make(),
                  6.hb,
                  '本月预估'.text.size(12.sp).color(Color(0xFF333333)).make(),
                ].column().expand(),
                VerticalDivider(
                  color: Color(0xFFE6E6E6),
                  width: 1.w,
                  thickness: 1.w,
                  indent: 16.w,
                  endIndent: 16.w,
                ),
                <Widget>[
                  '1223.56X'.text.size(18.sp).color(Color(0xFF333333)).make(),
                  6.hb,
                  '今日预估'.text.size(12.sp).color(Color(0xFF333333)).make(),
                ].column().expand(),
              ],
            ),
          ),
          Divider(
            color: Color(0xFFE6E6E6),
            height: 1.w,
            thickness: 1.w,
          ),
          <Widget>[
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  '上月结算'.text.size(12.sp).color(Color(0xFF666666)).make(),
                  '¥1234.12X'.text.size(12.sp).color(Color(0xFFD7BE8E)).make(),
                ]).expand(),
            30.hb,
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  '上月预估'.text.size(12.sp).color(Color(0xFF666666)).make(),
                  '¥1234.12X'.text.size(12.sp).color(Color(0xFFD7BE8E)).make(),
                ]).expand(),
          ].row(),
        ].column(crossAlignment: CrossAxisAlignment.start),
      ).color(Colors.white).withRounded(value: 10).make(),
    ).pOnly(left: 10, right: 10, bottom: 10);
  }
}
