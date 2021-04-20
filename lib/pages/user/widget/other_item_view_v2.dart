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
            child: Row(
      children: [
        70.hb,
        _buildItem(
          Icon(
            AppIcons.icon_address,
            color: _itemColor,
            size: _iconSize,
          ),
          '地址',
          () => AppRouter.push(context, RouteName.RECEIVING_ADDRESS_PAGE),
        ),
        _buildItem(
          Icon(
            AppIcons.icon_help,
            color: _itemColor,
            size: _iconSize,
          ),
          '帮助',
          () => MQManager.goToChat(
              userId: UserManager.instance.user.info.id.toString(),
              userInfo: <String, String>{
                "name": UserManager.instance.user.info.nickname ?? "",
                "gender":
                    UserManager.instance.user.info.gender == 1 ? "男" : "女",
                "mobile": UserManager.instance.user.info.mobile ?? ""
              }),
        ),
        _buildItem(
          Image.asset(
            R.ASSETS_SHOP_BUSINESS_CORP_PNG,
            width: 30.rw,
            height: 30.rw,
          ),
          '商务合作',
          () => AppRouter.push(context, RouteName.BUSSINESS_COOPERATION_PAGE),
        ),
        _buildItem(
          Icon(
            AppIcons.icon_setting,
            color: _itemColor,
            size: _iconSize,
          ),
          '设置',
          () => AppRouter.push(context, RouteName.SETTING_PAGE),
        ),
      ],
    ))
        .color(Color(0xFFFFFFFF))
        .margin(EdgeInsets.all(10).copyWith(top: 0))
        .withRounded(value: 10)
        .make();
  }
}
