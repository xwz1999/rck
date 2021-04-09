import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/pages/user/model/member_info_model.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/recook/recook_scaffold.dart';
import 'package:recook/widgets/refresh_widget.dart';

class UserGroupCardDetailPage extends StatefulWidget {
  final int id;

  UserGroupCardDetailPage({Key key, @required this.id}) : super(key: key);

  @override
  _UserGroupCardDetailPageState createState() =>
      _UserGroupCardDetailPageState();
}

class _UserGroupCardDetailPageState extends State<UserGroupCardDetailPage> {
  TextEditingController _editingController;
  MemberInfoModel _memberInfoModel;
  GSRefreshController _refreshController =
      GSRefreshController(initialRefresh: true);
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
    _editingController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return RecookScaffold(
      title: '队员详情',
      red: true,
      body: RefreshWidget(
        controller: _refreshController,
        onRefresh: () async {
          ResultData resultData = await HttpManager.post(
              APIV2.userAPI.memberInfo, {'memberId': widget.id});
          _memberInfoModel = MemberInfoModel.fromJson(resultData.data['data']);
          _editingController.text = _memberInfoModel.remarkName;
          _refreshController.refreshCompleted();
          if (mounted) setState(() {});
        },
        body: _memberInfoModel == null
            ? SizedBox()
            : ListView(
                children: [
                  ...[
                    _buildTile(
                      title: '头像',
                      suffix: ClipRRect(
                        borderRadius: BorderRadius.circular(22.w),
                        child: FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                          image: Api.getImgUrl(_memberInfoModel.headImgUrl),
                          height: 44.w,
                          width: 44.w,
                        ),
                      ),
                    ),
                    _buildTile(
                      title: '角色',
                      suffix: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 4.w),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5CA88),
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: [
                          Image.asset(
                            UserLevelTool.getRoleLevelIcon(
                                _memberInfoModel.roleLevelEnum),
                            width: 12.w,
                            height: 12.w,
                            color: Color(0xFFC47F53),
                          ),
                          UserLevelTool.roleLevelWithEnum(
                                  _memberInfoModel.roleLevelEnum)
                              .text
                              .size(10.sp)
                              .color(Color(0xFFC47F53))
                              .make(),
                        ].row(),
                      ),
                    ),
                    _buildTile(
                      title: '昵称',
                      suffix: (_memberInfoModel.nickname ?? '').text.make(),
                    ),
                    _buildTile(
                      title: '备注',
                      // suffix: (widget.comment ?? '').text.make(),
                      suffix: TextField(
                        onEditingComplete: () async {
                          GSDialog.of(context)
                              .showLoadingDialog(context, '修改中');
                          await HttpManager.post(UserApi.invite_remark_name, {
                            "userId": widget.id,
                            "remarkName": _editingController.text
                          });
                          setState(() {});
                          GSDialog.of(context).dismiss(context);
                          _refreshController.requestRefresh();
                        },
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
                      suffix: (_memberInfoModel.phone ?? '').text.make(),
                      trailing: Image.asset(
                        R.ASSETS_USER_ICON_PHONE_PNG,
                        height: 18.w,
                        width: 18.w,
                      ),
                    ),
                    _buildTile(
                      title: '微信号',
                      suffix: (_memberInfoModel.wechatNo ?? '').text.make(),
                      trailing: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: _memberInfoModel.wechatNo ?? ''));
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
      ),
    );
  }
}
