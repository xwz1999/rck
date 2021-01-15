import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:recook/constants/header.dart';

class UserGroupCard extends StatefulWidget {
  final String name;
  final String wechatId;
  final String phone;
  final UserRoleLevel shopRole;
  final int groupCount;
  final String headImg;

  //options
  final bool flat;
  UserGroupCard({
    Key key,
    @required this.name,
    @required this.wechatId,
    @required this.phone,
    @required this.shopRole,
    @required this.groupCount,
    @required this.headImg,
  })  : flat = false,
        super(key: key);

  UserGroupCard.flat({
    Key key,
    @required this.name,
    @required this.wechatId,
    @required this.phone,
    @required this.shopRole,
    @required this.groupCount,
    @required this.headImg,
  })  : flat = true,
        super(key: key);

  @override
  _UserGroupCardState createState() => _UserGroupCardState();
}

class _UserGroupCardState extends State<UserGroupCard> {
  Widget _buildTile(String path, String title) {
    return Row(
      children: [
        Image.asset(
          path,
          height: 12.w,
          width: 12.w,
        ),
        4.wb,
        title.text.color(Colors.black38).make().expand(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomImageButton(
      color: Colors.white,
      onPressed: () {},
      child: VxBox(
        child: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.w),
            child: FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              image: Api.getImgUrl(widget.headImg),
              height: 40.w,
              width: 40.w,
            ),
          ),
          10.wb,
          <Widget>[
            GestureDetector(
              child: [
                widget.name.text.black.make(),
                6.wb,
                // Image.asset(
                //   R.ASSETS_INVITE_DETAIL_EDIT_PNG,
                //   height: 12.w,
                //   width: 12.w,
                // ),
                Spacer(),
              ].row(),
              onTap: () {},
            ),
            4.hb,
            [
              _buildTile(R.ASSETS_USER_ICON_WECHAT_PNG, widget.wechatId)
                  .expand(),
              _buildTile(R.ASSETS_USER_ICON_PHONE_PNG, widget.phone).expand(),
            ].row(),
            4.hb,
            [
              _buildTile(
                UserLevelTool.getRoleLevelIcon(widget.shopRole),
                UserLevelTool.roleLevelWithEnum(widget.shopRole),
              ).expand(),
              _buildTile(
                R.ASSETS_USER_ICON_GROUP_PNG,
                widget.groupCount.toString(),
              ).expand(),
            ].row(),
          ].column().expand(),
        ].row(crossAlignment: CrossAxisAlignment.start),
      )
          .padding(EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w))
          .withDecoration(BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.flat ? 0 : 5.w),
          ))
          .make(),
    );
  }
}
