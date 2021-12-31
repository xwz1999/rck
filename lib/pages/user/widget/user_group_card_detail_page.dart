import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/pages/user/model/member_info_model.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/recook/recook_scaffold.dart';
import 'package:jingyaoyun/widgets/refresh_widget.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.rw,horizontal: 8.rw),
      color: Colors.white,
      child: Row(
        children: [
          64.hb,
          15.wb,
          title.text.size(14.rsp).color(Color(0xFF333333)).make(),
          Spacer(),
          DefaultTextStyle(
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14.rsp,
            ),
            child: suffix ?? SizedBox(),
          ),
          (suffix != null && trailing != null) ? 6.wb : SizedBox(),
          trailing ?? SizedBox(),
          15.wb,
        ],
      ),
    );
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
                        borderRadius: BorderRadius.circular(22.rw),
                        child: FadeInImage.assetNetwork(
                          placeholder: R.ASSETS_ICON_RECOOK_ICON_300_PNG,
                          image: Api.getImgUrl(_memberInfoModel.headImgUrl),
                          height: 44.rw,
                          width: 44.rw,
                        ),
                      ),
                    ),
                    _buildTile(
                      title: '角色',
                      suffix: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.rw, vertical: 4.rw),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5CA88),
                          borderRadius: BorderRadius.circular(20.rw),
                        ),
                        child: [
                          Image.asset(
                            UserLevelTool.getRoleLevelIcon(
                                _memberInfoModel.roleLevelEnum),
                            width: 12.rw,
                            height: 12.rw,
                            color: Color(0xFFC47F53),
                          ),
                          UserLevelTool.roleLevelWithEnum(
                                  _memberInfoModel.roleLevelEnum)
                              .text
                              .size(10.rsp)
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
                    height: 1.rw,
                    thickness: 1.rw,
                    color: Color(0xFFE6E6E6),
                    indent: 15.rw,
                    endIndent: 15.rw,
                  )),
                  30.hb,
                  ...[
                    _buildTile(
                      title: '手机号',
                      suffix: (_memberInfoModel.phone ?? '').text.make(),
                      trailing: Image.asset(
                        R.ASSETS_USER_ICON_PHONE_PNG,
                        height: 18.rw,
                        width: 18.rw,
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
                          height: 18.rw,
                          width: 18.rw,
                        ),
                      ),
                    ),
                  ].sepWidget(
                      separate: Divider(
                    height: 1.rw,
                    thickness: 1.rw,
                    color: Color(0xFFE6E6E6),
                    indent: 15.rw,
                    endIndent: 15.rw,
                  )),
                ],
              ),
      ),
    );
  }
}
