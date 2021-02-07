import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recook/constants/api.dart';
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
  TextEditingController _editingController;
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
    ).material(color: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.comment);
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '队员详情',
      red: true,
      body: ListView(
        children: [
          ...[
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
            _buildTile(
              title: '角色',
              suffix: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF5CA88),
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: [
                  Image.asset(
                    UserLevelTool.getRoleLevelIcon(widget.role),
                    width: 12.w,
                    height: 12.w,
                    color: Color(0xFFC47F53),
                  ),
                  UserLevelTool.roleLevelWithEnum(widget.role)
                      .text
                      .size(10.sp)
                      .color(Color(0xFFC47F53))
                      .make(),
                ].row(),
              ),
            ),
            _buildTile(
              title: '昵称',
              suffix: (widget.nickName ?? '').text.make(),
            ),
            _buildTile(
              title: '备注',
              // suffix: (widget.comment ?? '').text.make(),
              suffix: TextField(
                onEditingComplete: () {},
                controller: _editingController,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ).expand(),
            ),
          ].sepWidget(
              separate: Divider(
            height: 1.w,
            thickness: 1.w,
            color: Color(0xFFE6E6E6),
            indent: 15.w,
            endIndent: 15.w,
          )),
          10.hb,
          ...[
            _buildTile(
              title: '手机号',
              suffix: (widget.phone ?? '').text.make(),
            ),
            _buildTile(
              title: '微信号',
              suffix: (widget.wechat ?? '').text.make(),
              trailing: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.wechat ?? ''));
                  GSDialog.of(context).showSuccess(context, '复制成功');
                },
                child: Image.asset(
                  R.ASSETS_USER_COPY_PNG,
                  height: 18.w,
                  width: 18.w,
                ),
              ),
            ),
          ].sepWidget(
              separate: Divider(
            height: 1.w,
            thickness: 1.w,
            color: Color(0xFFE6E6E6),
            indent: 15.w,
            endIndent: 15.w,
          )),
        ],
      ),
    );
  }
}
