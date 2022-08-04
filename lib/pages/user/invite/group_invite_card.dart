import 'package:flutter/material.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/gen/assets.gen.dart';
import 'package:recook/pages/user/model/user_common_model.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:velocity_x/velocity_x.dart';

class GroupInviteCard extends StatelessWidget {
  final UserCommonModel model;
  final bool canTap;
  const GroupInviteCard({Key? key, required this.model, this.canTap = false})
      : super(key: key);
  _renderItem(String asset, String? value) {
    String? displayValue = value;
    if (displayValue?.isEmpty ?? true) {
      displayValue = ' —';
    }
    return Row(
      children: [
        Image.asset(asset, width: 10.rw, height: 10.rw),
        2.wb,
        displayValue!.text.size(11.rsp).color(Color(0xFF999999)).make().expand(),
      ],
    ).expand();
  }


  String? get itemName {
    String? item = model.nickname;
    if (model.remarkName?.isNotEmpty ?? false) {
     // item += '(${model.remarkName})';
      item = item??'' + '(${model.remarkName})';
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    final widget = Row(
      children: [
        16.wb,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.rw),
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: Api.getImgUrl(model.headImgUrl)!,
                height: 40.rw,
                width: 40.rw,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(Assets.placeholderNew1x1A.path,height: 40.w,
                    width: 40.w,);
                },
              ),
            ),
            8.hb,
            Image.asset(
              model.roleLevelEnum == UserRoleLevel.Shop?
              R.ASSETS_USER_ICON_DIAMOND_PNG:R.ASSETS_USER_ICON_MASTER_PNG,
              width: 12.rw,
              height: 12.rw,
            ),
          ],
        ),
        10.wb,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.hb,
            Row(
              children: [
                model.phone!.startsWith('2')
                    ? '【该账户已注销】'.text.black.size(14.rsp).make()
                    : itemName!.text.black.size(14.rsp).make(),
                Spacer(),
                '店主'
                    .text
                    .color(Color(0xFF333333))
                    .size(12.rsp)
                    .make(),
                20.wb,
              ],
            ),
            10.hb,
            Row(
              children: [
                _renderItem(R.ASSETS_USER_ICON_PHONE_PNG,
                    model.phone!.startsWith('2') ? ' —' : model.phone),
                _renderItem(R.ASSETS_USER_ICON_WECHAT_PNG,
                    model.phone!.startsWith('2') ? ' —' : model.wechatNo),
              ],
            ),
            10.hb,
            Row(
              children: [
                UserLevelTool.currentRoleLevelEnum() ==
                    UserRoleLevel.subsidiary?_renderItem(R.ASSETS_USER_ICON_GROUP_PNG, model.countValue):SizedBox(),
                _renderItem(
                  R.ASSETS_USER_ICON_MONEY_PNG,
                  model.amountValue,
                ),
              ],
            ),
            16.hb,
            Divider(
              color: Color(0xFFE6E6E6),
              height: rSize(1),
              thickness: rSize(1),
            )
          ],
        ).expand(),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     model.isRecommand
        //         ? MaterialButton(
        //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //             minWidth: 0,
        //             padding: EdgeInsets.symmetric(
        //                 horizontal: 20.rw, vertical: 12.rw),
        //             child: Image.asset(
        //               R.ASSETS_USER_USER_RECOMMEND_SINGLE_PNG,
        //               height: 17.rw,
        //               width: 17.rw,
        //             ),
        //             onPressed: upgradeFunc,
        //           )
        //         : 57.wb,
        //     44.hb,
        //   ],
        // ),
      ],
    );
    return GestureDetector(
      onTap: () {
        // if (canTap) Get.to(() => UserGroupCardDetailPage(id: model.userId));
      },
      child: widget,
    );
  }
}
