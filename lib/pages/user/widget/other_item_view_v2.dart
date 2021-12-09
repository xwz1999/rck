import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/header.dart';
import 'package:recook/manager/meiqia_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/widgets/custom_image_button.dart';

class OtherItemViewV2 extends StatelessWidget {
  OtherItemViewV2({Key key}) : super(key: key);

  final Color _itemColor = Colors.grey[500];
  final double _iconSize = rSize(30);

  Widget _buildItem(Widget icon, String title, VoidCallback onTap) {
    return CustomImageButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: <Widget>[
        icon,
        title.text.color(Color(0xFF666666)).size(12.rsp).make(),
      ].column(),
    ).expand();
  }

  @override
  Widget build(BuildContext context) {
    return VxBox(
      
      child: Column(
        children: [
          14.hb,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              20.wb,
              Text(
                '我的服务',
                style:
                AppTextStyle.generate(16, fontWeight: FontWeight.w700),
              )

            ],
          ),
          Row(
            children: [
              _buildItem(
                Image.asset(R.ASSETS_USER_FUNC_LOCATION_PNG, width: 30.rw,
                  height: 30.rw,),
                '我的地址',
                () => AppRouter.push(context, RouteName.RECEIVING_ADDRESS_PAGE),
              ),
              _buildItem(
                Image.asset(R.ASSETS_USER_FUNC_FAVOR_PNG, width: 30.rw,
                  height: 30.rw,),
                '我的收藏',
                () => AppRouter.push(context, RouteName.MY_FAVORITE_PAGE),
              ),
              _buildItem(
                Image.asset(
                  R.ASSETS_USER_FUNC_BUSINESS_PNG,
                  width: 30.rw,
                  height: 30.rw,
                ),
                '商务合作',
                () => AppRouter.push(context, RouteName.BUSSINESS_COOPERATION_PAGE),
              ),
              _buildItem(
                Image.asset(R.ASSETS_USER_FUNC_SETTING_PNG, width: 30.rw,
                  height: 30.rw,),
                '设置',
                () => AppRouter.push(context, RouteName.SETTING_PAGE),
              ),
            ],
          ).pSymmetric(v:18.w ),
        ],
      ),
    )
        .color(Color(0xFFFFFFFF))
        .margin(EdgeInsets.all(10).copyWith(top: 0))
        .withRounded(value: 10)
        .make();
  }
}
