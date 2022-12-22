
import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/meiqia_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/widgets/custom_image_button.dart';

class OtherItemView extends StatelessWidget {
  // final Color? _itemColor = Colors.grey[500];
  // final double _iconSize = rSize(30);
  final double _fontSize = 12 * 2.sp;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('我的服务',style: TextStyle(fontSize: 16.rsp,color: Color(0xFF000000)),),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomImageButton(
                    // icon: Icon(
                    //   AppIcons.icon_address,
                    //   color: _itemColor,
                    //   size: _iconSize,
                    // ),
                    child: Image.asset(R.ASSETS_USER_FUNC_LOCATION_PNG),
                    title: "我的地址",
                    fontSize: _fontSize,
                    color: Color(0xFF333333),
                    contentSpacing: 8,
                    onPressed: () {
                      AppRouter.push(context, RouteName.RECEIVING_ADDRESS_PAGE);
                    },
                  ),
                ),
                Expanded(
                  child: CustomImageButton(
                    // icon: Icon(
                    //   AppIcons.icon_help,
                    //   color: _itemColor,
                    //   size: _iconSize,
                    // ),
                    child: Image.asset(R.ASSETS_USER_FUNC_FAVOR_PNG),
                    title: "我的收藏",
                    color: Color(0xFF333333),
                    fontSize: _fontSize,
                    contentSpacing: 8,
                    onPressed: () {
                      MQManager.goToChat(
                          userId: UserManager.instance!.user.info!.id.toString(),
                          userInfo: <String, String>{
                            "name": UserManager.instance!.user.info!.nickname ?? "",
                            "gender": UserManager.instance!.user.info!.gender == 1
                                ? "男"
                                : "女",
                            "mobile": UserManager.instance!.user.info!.mobile ?? ""
                          });
                    },
                  ),
                ),
                Expanded(
                  child: CustomImageButton(
                    child: Image.asset(R.ASSETS_USER_FUNC_BUSINESS_PNG),
                    title: "商务合作",
                    fontSize: _fontSize,
                    color: Color(0xFF333333),
                    contentSpacing: 8,
                    onPressed: () {
                      AppRouter.push(context, RouteName.BUSSINESS_COOPERATION_PAGE);
                    },
                  ),
                ),
                Expanded(
                  child: CustomImageButton(
                    child: Image.asset(R.ASSETS_USER_FUNC_SETTING_PNG),
                    title: "我的设置",
                    color: Color(0xFF333333),
                    fontSize: _fontSize,
                    contentSpacing: 8,
                    onPressed: () {
                      AppRouter.push(context, RouteName.SETTING_PAGE);
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
