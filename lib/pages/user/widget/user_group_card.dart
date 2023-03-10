import 'package:flutter/material.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/api_v2.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/http_manager.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/pages/user/widget/user_group_card_detail_page.dart';
import 'package:jingyaoyun/utils/custom_route.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/alert.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:velocity_x/velocity_x.dart';

class UserGroupCard extends StatefulWidget {
  final String name;
  final String wechatId;
  final String phone;
  final UserRoleLevel shopRole;
  final int groupCount;
  final String headImg;
  final int id;
  final bool isRecommend;
  final String remarkName;

  //options
  final bool flat;

  final VoidCallback onTap;
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
    @required this.remarkName,
    this.onTap,
  })  : flat = false,
        super(key: key);

  UserGroupCard.flat(
      {Key key,
      @required this.name,
      @required this.wechatId,
      @required this.phone,
      @required this.shopRole,
      @required this.groupCount,
      @required this.headImg,
      @required this.id,
      @required this.isRecommend,
      @required this.remarkName,
      this.onTap})
      : flat = true,
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
          height: 12.rw,
          width: 12.rw,
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
      onPressed: widget.onTap ??
          () => CRoute.push(context, UserGroupCardDetailPage(id: widget.id)),
      child: VxBox(
        child: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.rw),
            child: FadeInImage.assetNetwork(
              placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
              image: Api.getImgUrl(widget.headImg),
              height: 40.rw,
              width: 40.rw,
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
                  height: 12.rw,
                  width: 12.rw,
                ),
                Spacer(),
                widget.isRecommend ?? false
                    ? GestureDetector(
                        onTap: () async {
                          bool result = await showDialog(
                              context: context,
                              builder: (context) => NormalContentDialog(
                                    title: '????????????',
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        '????????????${widget.name}?????????????????? ???'
                                            .text
                                            .size(15.rsp)
                                            .color(Color(0xFF333333))
                                            .center
                                            .make(),
                                        '??????????????????????????????????????????????????????????????????3%?????????4%'
                                            .text
                                            .center
                                            .size(12.rsp)
                                            .color(Color(0xFF666666))
                                            .make(),
                                      ],
                                    ),
                                    items: ['??????', '??????'],
                                    listener: (index) async {
                                      switch (index) {
                                        case 0:
                                          Navigator.pop(context, false);
                                          break;
                                        case 1:
                                          GSDialog.of(context)
                                              .showLoadingDialog(
                                                  context, '?????????');
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
                              builder: (context) => Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          R.ASSETS_USER_GROUP_RECOMMEND_BG_PNG,
                                          height: 306.rw,
                                          width: 344.rw,
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          top: 62.rw,
                                          child:
                                              '????????? ${UserManager.instance.user.info.nickname}'
                                                  .text
                                                  .white
                                                  .size(16.rsp)
                                                  .make()
                                                  .centered(),
                                        ),
                                        Positioned(
                                          left: 60.rw,
                                          right: 60.rw,
                                          top: 111.rw,
                                          child:
                                              '??????${widget.name}??????????????????????????????????????????4%'
                                                  .text
                                                  .color(Color(0xFF333333))
                                                  .size(16.rsp)
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
                          height: 17.rw,
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
          .padding(EdgeInsets.symmetric(horizontal: 15.rw, vertical: 10.rw))
          .withDecoration(BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.flat ? 0 : 5.rw),
          ))
          .make(),
    );
  }
}
