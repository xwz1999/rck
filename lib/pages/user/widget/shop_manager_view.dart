import 'package:flutter/material.dart';
import 'package:recook/pages/shop/get_platform_award_page.dart';
import 'package:recook/pages/user/invite/diamond_recommand_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/share_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';

class ShopManagerView extends StatelessWidget {
  const ShopManagerView({Key key}) : super(key: key);

  _buildGridItem({
    @required String title,
    @required String subTitle,
    @required String path,
    VoidCallback onTap,
  }) {
    return CustomImageButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.w),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              alignment: Alignment.bottomRight,
            ),
          ),
          Positioned(
            left: 12.w,
            top: 12.w,
            child: <Widget>[
              title.text.size(14).color(Colors.white).make(),
              subTitle.text.size(14).color(Colors.white).make(),
            ].column(crossAlignment: CrossAxisAlignment.start),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          '店铺管理'.text.color(Color(0xFF333333)).size(16.sp).bold.make().p(10.w),
          GridView(
            padding:
                EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 10.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 170 / 90,
              crossAxisSpacing: 5.w,
              mainAxisSpacing: 5.w,
            ),
            children: [
              _buildGridItem(
                title: '团队扩招',
                subTitle: '0元创业·轻松赚',
                path: R.ASSETS_SHOP_GROUP_EXPAND_WEBP,
                onTap: () =>
                    ShareTool().inviteShare(context, customTitle: Container()),
              ),
              _buildGridItem(
                title: '我的团队',
                subTitle: '有福同享·真壕友',
                onTap: () => AppRouter.push(context, RouteName.USER_INVITE),
                path: R.ASSETS_SHOP_MY_GROUP_WEBP,
              ),
              _buildGridItem(
                title: '推荐钻石店铺',
                subTitle: '推荐好友·福利双赢',
                onTap: () => AppRouter.push(
                    context, RouteName.SHOP_RECOMMEND_UPGRADE_PAGE),
                path: R.ASSETS_SHOP_RECOMMAND_DIAMOND_WEBP,
              ),
              _buildGridItem(
                title: '我的推荐',
                subTitle: '呼朋唤友·享收益',
                onTap: () => CRoute.push(context, DiamondRecommandPage()),
                path: R.ASSETS_SHOP_MY_RECOMMAND_WEBP,
              ),
              _buildGridItem(
                title: '获取平台奖励',
                subTitle: '平台可靠·奖励多',
                onTap: () => CRoute.push(context, GetPlatformAwardPage()),
                path: R.ASSETS_SHOP_PLATFORM_AWARD_WEBP,
              ),
              _buildGridItem(
                title: '我的奖励',
                subTitle: '积少成多·奖励丰厚',
                onTap: () {},
                path: R.ASSETS_SHOP_MY_AWARD_WEBP,
              ),
            ],
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
