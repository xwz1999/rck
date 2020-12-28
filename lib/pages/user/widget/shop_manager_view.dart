import 'package:flutter/material.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/constants.dart';
import 'package:recook/constants/header.dart';

class ShopManagerView extends StatelessWidget {
  const ShopManagerView({Key key}) : super(key: key);

  _buildGridItem(
      {String title, String subTitle, String path, VoidCallback onTap}) {
    return CustomImageButton(
      onPressed: onTap,
      child: Stack(
        children: [
          path == null
              ? Placeholder().material(color: Colors.grey)
              : Image.asset(
                  path,
                  fit: BoxFit.cover,
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
          '店铺管理'
              .text
              .color(Color(0xFF333333))
              .size(16.sp)
              .bold
              .make()
              .pSymmetric(v: 10.w, h: 5.w),
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
                onTap: () {},
              ),
              _buildGridItem(
                title: '我的团队',
                subTitle: '有福同享·真壕友',
                onTap: () {},
              ),
              _buildGridItem(
                title: '推荐钻石店铺',
                subTitle: '推荐好友·福利双赢',
                onTap: () {},
              ),
              _buildGridItem(
                title: '我的推荐',
                subTitle: '呼朋唤友·享收益',
                onTap: () {},
              ),
              _buildGridItem(
                title: '获取平台奖励',
                subTitle: '平台可靠·奖励多',
                onTap: () {},
              ),
              _buildGridItem(
                title: '我的奖励',
                subTitle: '积少成多·奖励丰厚',
                onTap: () {},
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
