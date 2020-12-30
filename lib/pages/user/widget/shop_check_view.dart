import 'package:flutter/material.dart';
import 'package:recook/pages/user/widget/shop_check_painter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/constants.dart';

class ShopCheckView extends StatefulWidget {
  ShopCheckView({Key key}) : super(key: key);

  @override
  _ShopCheckViewState createState() => _ShopCheckViewState();
}

class _ShopCheckViewState extends State<ShopCheckView> {
  @override
  Widget build(BuildContext context) {
    return VxBox(
        child: Column(
      children: [
        Container(
          height: 68.w,
          width: 68.w,
          child: CustomPaint(
            painter: ShopCheckPainter(
              themeColor: Color(0xFFE2B56B).withOpacity(0.5),
              beginColor: Color(0xFFECD5A7),
              endColor: Color(0xFFE0AE5C),
              percentage: 95.0,
            ),
          ),
        ),
      ],
    )).color(Colors.white).margin(EdgeInsets.only(bottom: 10)).make();
  }
}
