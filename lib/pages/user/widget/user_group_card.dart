import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/widget/user_group_card_detail_page.dart';
import 'package:recook/utils/custom_route.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
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
  final int id;
  final bool isRecommend;

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
    @required this.id,
    @required this.isRecommend,
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
    @required this.id,
    @required this.isRecommend,
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
      onPressed: () => CRoute.push(
          context,
          UserGroupCardDetailPage(
            headImg: widget.headImg,
            role: widget.shopRole,
            nickName: widget.name,
            phone: widget.phone,
            wechat: widget.wechatId,
            //TODO
            comment: '',
            //TODO 对接数据
            signDate: DateTime.now(),
            diamondDate: DateTime.now(),
          )),
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
                Image.asset(
                  R.ASSETS_INVITE_DETAIL_EDIT_PNG,
                  height: 12.w,
                  width: 12.w,
                ),
                Spacer(),
                widget.isRecommend ?? false
                    ? GestureDetector(
                        onTap: () async {
                          bool result = await showDialog(
                              context: context,
                              child: NormalContentDialog(
                                title: '推荐提示',
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    '确定推荐${widget.name}为钻石店铺么 ？'
                                        .text
                                        .size(15.sp)
                                        .color(Color(0xFF333333))
                                        .center
                                        .make(),
                                    '确认提拔后您将获得被推荐团队销售额提成比例的3%增加到4%'
                                        .text
                                        .center
                                        .size(12.sp)
                                        .color(Color(0xFF666666))
                                        .make(),
                                  ],
                                ),
                                items: ['放弃', '确定'],
                                listener: (index) async {
                                  switch (index) {
                                    case 0:
                                      Navigator.pop(context, false);
                                      break;
                                    case 1:
                                      GSDialog.of(context)
                                          .showLoadingDialog(context, '推荐中');
                                      ResultData result =
                                          await HttpManager.post(
                                        APIV2.userAPI.recommendDiamond,
                                        {'userId': widget.id},
                                      );
                                      GSDialog.of(context).dismiss(context);
                                      if (result.data['code'] == 'FAIL') {
                                        Navigator.pop(context, false);
                                        showToast('${result.data['msg']}');
                                      } else
                                        Navigator.pop(context, true);
                                      break;
                                  }
                                },
                              ));

                          if (result == true) {
                            showDialog(
                              context: context,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          R.ASSETS_USER_GROUP_RECOMMEND_BG_PNG,
                                          height: 306.w,
                                          width: 344.w,
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          top: 62.w,
                                          child:
                                              '恭喜！ ${UserManager.instance.user.info.nickname}'
                                                  .text
                                                  .white
                                                  .size(16.sp)
                                                  .make()
                                                  .centered(),
                                        ),
                                        Positioned(
                                          left: 60.w,
                                          right: 60.w,
                                          top: 111.w,
                                          child:
                                              '您从${widget.name}团队销售额获得提成比例将增至4%'
                                                  .text
                                                  .color(Color(0xFF333333))
                                                  .size(16.sp)
                                                  .make()
                                                  .centered(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Image.asset(
                          R.ASSETS_USER_USER_RECOMMEND_PNG,
                          height: 17.w,
                        ),
                      )
                    : SizedBox(),
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
