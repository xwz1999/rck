import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/constants/api.dart';
import 'package:recook/constants/api_v2.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/http_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/pages/user/model/user_common_model.dart';
import 'package:recook/pages/user/widget/user_group_card_detail_page.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/alert.dart';
import 'package:recook/widgets/progress/re_toast.dart';

class GroupInviteCard extends StatelessWidget {
  final UserCommonModel model;
  final bool canTap;
  const GroupInviteCard({Key key, @required this.model, this.canTap = false})
      : super(key: key);
  _renderItem(String asset, String value) {
    String displayValue = value;
    if (displayValue?.isEmpty ?? true) {
      displayValue = ' —';
    }
    return Row(
      children: [
        Image.asset(asset, width: 10.w, height: 10.w),
        2.wb,
        displayValue.text.size(11.sp).color(Color(0xFF999999)).make().expand(),
      ],
    ).expand();
  }

  upgradeFunc() async {
    bool result = await Get.dialog(NormalContentDialog(
      title: '提示',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          '确定将'.text.size(14.sp).color(Color(0xFF333333)).center.make(),
          model.nickname.text
              .size(14.sp)
              .color(Color(0xFF0080FF))
              .center
              .make(),
          '开设成为您的分销店铺吗?'
              .text
              .size(14.sp)
              .color(Color(0xFF333333))
              .center
              .make(),
          10.hb,
          '确定后，您将获得${model.nickname}店铺销售额的分销店铺补贴，${model.nickname}将享受钻石店铺权益'
              .text
              .center
              .size(12.sp)
              .color(Color(0xFF333333))
              .make(),
        ],
      ),
      items: ['取消', '确定'],
      listener: (index) async {
        switch (index) {
          case 0:
            Get.back(result: false);
            break;
          case 1:
            final cancel = ReToast.loading(text: '推荐中');
            ResultData result = await HttpManager.post(
              APIV2.userAPI.recommendDiamond,
              {'userId': model.userId},
            );
            cancel();
            if (result.data['code'] == 'FAIL') {
              Get.back(result: false);
              showToast('${result.data['msg']}');
            } else
              Get.back(result: true);
            break;
        }
      },
    ));

    if (result == true) {
      Get.dialog(Center(
        child: GestureDetector(
          onTap: () => Get.back(),
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
                  child: '恭喜！ ${UserManager.instance.user.info.nickname}'
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
                  child: Column(
                    children: [
                      '您已成功将'
                          .text
                          .color(Color(0xFF333333))
                          .size(16.sp)
                          .make()
                          .centered(),
                      '${model.nickname}'
                          .text
                          .color(Color(0xFF008AFF))
                          .size(16.sp)
                          .make()
                          .centered(),
                      '开设成为您的分销店铺'
                          .text
                          .color(Color(0xFF333333))
                          .size(16.sp)
                          .make()
                          .centered(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
  }

  String get itemName {
    String item = model.nickname;
    if (model?.remarkName?.isNotEmpty ?? false) {
      item += '(${model.remarkName})';
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
              borderRadius: BorderRadius.circular(20.w),
              child: FadeInImage.assetNetwork(
                placeholder: R.ASSETS_PLACEHOLDER_NEW_1X1_A_PNG,
                image: Api.getImgUrl(model.headImgUrl),
                height: 40.w,
                width: 40.w,
              ),
            ),
            10.hb,
            Image.asset(
              UserLevelTool.getRoleLevelIcon(model.roleLevelEnum),
              width: 12.w,
              height: 12.w,
            ),
          ],
        ),
        10.wb,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.hb,
            itemName.text.black.size(14.sp).make(),
            8.hb,
            Row(
              children: [
                _renderItem(R.ASSETS_USER_ICON_PHONE_PNG, model.phone),
                _renderItem(R.ASSETS_USER_ICON_WECHAT_PNG, model.wechatNo),
              ],
            ),
            5.hb,
            Row(
              children: [
                _renderItem(R.ASSETS_USER_ICON_GROUP_PNG, model.countValue),
                _renderItem(
                  R.ASSETS_USER_ICON_MONEY_PNG,
                  model.amountValue,
                ),
              ],
            ),
            16.hb,
          ],
        ).expand(),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            model.isRecommand
                ? MaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minWidth: 0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
                    child: Image.asset(
                      R.ASSETS_USER_USER_RECOMMEND_SINGLE_PNG,
                      height: 17.w,
                      width: 17.w,
                    ),
                    onPressed: upgradeFunc,
                  )
                : 57.wb,
            44.hb,
          ],
        ),
      ],
    );
    return GestureDetector(
      onTap: () {
        if (canTap) Get.to(() => UserGroupCardDetailPage(id: model.userId));
      },
      child: widget,
    );
  }
}
