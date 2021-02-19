/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019/6/6  6:02 PM 
 * remark    : 
 * ====================================================
 */

import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:recook/manager/meiqia_manager.dart';
import 'package:recook/manager/user_manager.dart';

class OtherItemView extends StatelessWidget {
  final Color _itemColor = Colors.grey[500];
  final double _iconSize = rSize(30);
  final double _fontSize = ScreenAdapterUtils.setSp(12);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white),
        child: Row(
          children: <Widget>[
            Expanded(
              child: CustomImageButton(
                icon: Icon(
                  AppIcons.icon_address,
                  color: _itemColor,
                  size: _iconSize,
                ),
                title: "地址",
                fontSize: _fontSize,
                color: Colors.grey[700],
                contentSpacing: 8,
                onPressed: () {
                  AppRouter.push(context, RouteName.RECEIVING_ADDRESS_PAGE);
                },
              ),
            ),
            Expanded(
              child: CustomImageButton(
                icon: Icon(
                  AppIcons.icon_help,
                  color: _itemColor,
                  size: _iconSize,
                ),
                title: "帮助",
                color: Colors.grey[700],
                fontSize: _fontSize,
                contentSpacing: 8,
                onPressed: () {
                  MQManager.goToChat(
                      userId: UserManager.instance.user.info.id.toString(),
                      userInfo: <String, String>{
                        "name": UserManager.instance.user.info.nickname ?? "",
                        "gender": UserManager.instance.user.info.gender == 1
                            ? "男"
                            : "女",
                        "mobile": UserManager.instance.user.info.mobile ?? ""
                      });
                },
              ),
            ),
            Expanded(
              child: CustomImageButton(
                icon: Image.asset(R.ASSETS_SHOP_BUSINESS_CORP_PNG),
                title: "商务合作",
                fontSize: _fontSize,
                color: Colors.grey[700],
                contentSpacing: 8,
                onPressed: () {
                  AppRouter.push(context, RouteName.BUSSINESS_COOPERATION_PAGE);
                },
              ),
            ),
            Expanded(
              child: CustomImageButton(
                icon: Icon(
                  AppIcons.icon_setting,
                  color: _itemColor,
                  size: _iconSize,
                ),
                title: "设置",
                color: Colors.grey[700],
                fontSize: _fontSize,
                contentSpacing: 8,
                onPressed: () {
                  AppRouter.push(context, RouteName.SETTING_PAGE);
                },
              ),
            ),
          ],
        ));
  }
}
