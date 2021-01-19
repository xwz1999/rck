import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/constants/header.dart';
import 'package:velocity_x/velocity_x.dart';

class UserGroupCardDetailPage extends StatefulWidget {
  final String headImg;
  final UserRoleLevel role;
  final String nickName;
  final String comment;
  final DateTime signDate;
  final DateTime diamondDate;
  final String phone;
  final String wechat;
  UserGroupCardDetailPage(
      {Key key,
      this.headImg,
      this.role,
      this.nickName,
      this.comment,
      this.signDate,
      this.diamondDate,
      this.phone,
      this.wechat})
      : super(key: key);

  @override
  _UserGroupCardDetailPageState createState() =>
      _UserGroupCardDetailPageState();
}

class _UserGroupCardDetailPageState extends State<UserGroupCardDetailPage> {
  Widget _buildTile({String title, Widget suffix, Widget trailing}) {
    return Row(
      children: [
        64.hb,
        15.wb,
        title.text.size(14.sp).color(Color(0xFF333333)).make(),
        Spacer(),
        DefaultTextStyle(
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14.sp,
          ),
          child: suffix ?? SizedBox(),
        ),
        (suffix != null && trailing != null) ? 6.wb : SizedBox(),
        trailing ?? SizedBox(),
        15.wb,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '队员详情',
      red: true,
      body: ListView(
        children: [
          _buildTile(
            title: '头像',
            suffix: ClipRRect(
              borderRadius: BorderRadius.circular(22.w),
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: Api.getImgUrl(widget.headImg),
                height: 44.w,
                width: 44.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
