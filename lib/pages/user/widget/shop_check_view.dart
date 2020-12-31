import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/widget/shop_check_painter.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/constants.dart';

class ShopCheckView extends StatefulWidget {
  ShopCheckView({Key key}) : super(key: key);

  @override
  _ShopCheckViewState createState() => _ShopCheckViewState();
}

class _ShopCheckViewState extends State<ShopCheckView> {
  UserLevel get role => UserLevelTool.currentUserLevelEnum();

  //sliverColors
  final Color sliverTheme = Color(0xFF4F646C);
  final Color sliverBegin = Color(0xFFB2C1CF);
  final Color sliverEnd = Color(0xFF364C53);

  //goldColors
  final Color goldTheme = Color(0xFFE2B56B);
  final Color goldBegin = Color(0xFFECD5A7);
  final Color goldEnd = Color(0xFFE0AE5C);

  @override
  Widget build(BuildContext context) {
    return VxBox(
        child: Column(
      children: [
        <Widget>[
          15.wb,
          40.hb,
          Container(
            height: 18.w,
            width: 2.5.w,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          6.wb,
          '白银店铺考核'.text.bold.size(16.sp).black.make(),
          Spacer(),
          '查看规则'.text.color(Colors.black45).size(12.sp).make(),
          Icon(Icons.arrow_forward_ios, size: 16.w, color: Colors.black26),
          16.wb,
        ].row(),
        CustomImageButton(
          onPressed: () {},
          child: [
            '本考核期截止至2020-05-31，将于2020-06-22进行考核'
                .text
                .color(Colors.black45)
                .size(12.sp)
                .make(),
            2.wb,
            Image.asset(
              R.ASSETS_SHOP_HELPER_PNG,
              height: 12.w,
              width: 12.w,
            ),
          ].row(),
        ),
        10.hb,
        Container(
          height: 68.w,
          width: 68.w,
          child: CustomPaint(
            painter: ShopCheckPainter(
              themeColor: sliverTheme.withOpacity(0.5),
              beginColor: sliverBegin,
              endColor: sliverEnd,
              percentage: 65.0,
            ),
          ),
        ),
        5.hb,
        '还需团队销售额\n10053元'.text.size(12.sp).black.center.make(),
        15.hb,
      ],
    )).color(Colors.white).margin(EdgeInsets.only(bottom: 10)).make();
  }
}
