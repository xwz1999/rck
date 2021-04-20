import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/pages/user/invite/my_group_page_v2.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';

class ShopManagerView extends StatelessWidget {
  const ShopManagerView({Key key}) : super(key: key);

  _buildGridItem({
    @required String title,
    @required String subTitle,
    @required String path,
    VoidCallback onTap,
    bool show = false,
  }) {
    if (!show) return null;
    return CustomImageButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.rw),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              alignment: Alignment.bottomRight,
            ),
          ),
          Positioned(
            left: 12.rw,
            top: 12.rw,
            child: <Widget>[
              title.text.size(14).color(Colors.white).make(),
              subTitle.text.size(14).color(Colors.white).make(),
            ].column(crossAlignment: CrossAxisAlignment.start),
          ),
        ],
      ),
    );
  }

  bool get showTop => true;
  bool get showMid =>
      UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_1 ||
      UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_2;
  bool get showBottom =>
      UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.Diamond_1;

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView(
            padding: EdgeInsets.symmetric(horizontal: 5.rw, vertical: 10.rw),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 170 / 90,
              crossAxisSpacing: 5.rw,
              mainAxisSpacing: 5.rw,
            ),
            children: [
              _buildGridItem(
                title: '团队扩招',
                subTitle: '0元创业·轻松赚',
                path: R.ASSETS_SHOP_GROUP_EXPAND_WEBP,
                onTap: () =>
                    ShareTool().inviteShare(context, customTitle: Container()),
                show: showTop,
              ),
              _buildGridItem(
                title: '我的店铺',
                subTitle: '有福同享·真壕友',
                onTap: () => Get.to(() => MyGroupPageV2()),
                // CRoute.push(context, MyGroupPage(type: UsersMode.MY_GROUP)),
                path: R.ASSETS_SHOP_MY_GROUP_WEBP,
                show: showTop,
              ),
              // _buildGridItem(
              //   title: '推荐钻石店铺',
              //   subTitle: '推荐好友·福利双赢',
              //   onTap: () => AppRouter.push(
              //       context, RouteName.SHOP_RECOMMEND_UPGRADE_PAGE),
              //   path: R.ASSETS_SHOP_RECOMMAND_DIAMOND_WEBP,
              //   show: showMid,
              // ),
              // _buildGridItem(
              //   title: '我的推荐',
              //   subTitle: '呼朋唤友·享收益',
              //   onTap: () => CRoute.push(
              //       context, MyGroupPage(type: UsersMode.MY_RECOMMEND)),
              //   path: R.ASSETS_SHOP_MY_RECOMMAND_WEBP,
              //   show: showMid,
              // ),
              // _buildGridItem(
              //   title: '获取平台奖励',
              //   subTitle: '平台可靠·奖励多',
              //   onTap: () => CRoute.push(context, GetPlatformAwardPage()),
              //   path: R.ASSETS_SHOP_PLATFORM_AWARD_WEBP,
              //   show: showBottom,
              // ),
              // _buildGridItem(
              //   title: '我的奖励',
              //   subTitle: '积少成多·奖励丰厚',
              //   onTap: () => CRoute.push(
              //       context, MyGroupPage(type: UsersMode.MY_REWARD)),
              //   path: R.ASSETS_SHOP_MY_AWARD_WEBP,
              //   show: showBottom,
              // ),
            ]..removeWhere((element) => element == null),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
        ],
      ),
    )
        .margin(EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10))
        .color(Colors.white)
        .withRounded(value: 10)
        .make();
  }
}
