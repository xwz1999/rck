import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';

class ShopManagerView extends StatelessWidget {
  const ShopManagerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '店铺管理'
              .text
              .color(Color(0xFF333333))
              .size(16.sp)
              .bold
              .make()
              .pSymmetric(v: 10.w, h: 5.w),
          Image.asset(R.ASSETS_SHOP_TEST_PNG),
        ],
      ),
    )
        .margin(EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10))
        .color(Colors.white)
        .withRounded(value: 10)
        .make();
  }
}
