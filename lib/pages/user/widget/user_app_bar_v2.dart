import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';

class UserAppBarV2 extends StatefulWidget {
  UserAppBarV2({Key key}) : super(key: key);

  @override
  _UserAppBarV2State createState() => _UserAppBarV2State();
}

class _UserAppBarV2State extends BaseStoreState<UserAppBarV2> {
  _buildInnerInfo() {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          10.wb,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomImageButton(
                onPressed: () => push(RouteName.USER_INFO_PAGE),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.rw),
                    border: Border.all(
                      width: 1.rw,
                      color: Color(0x8F979797),
                    ),
                  ),
                  position: DecorationPosition.foreground,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.rw),
                    child: FadeInImage.assetNetwork(
                      height: 60.rw,
                      width: 60.rw,
                      placeholder: R.ASSETS_ICON_RECOOK_ICON_300_PNG,
                      image: TextUtils.isEmpty(
                              UserManager.instance.user.info.headImgUrl)
                          ? ""
                          : Api.getImgUrl(
                              UserManager.instance.user.info.headImgUrl),
                    ),
                  ),
                ),
              ),
              10.hb,
              '${UserManager.instance.user.info.nickname}'
                  .text
                  .color(Color(0xFF333333))
                  .size(20.rsp)

                  .make(),
              10.hb,
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              12.hb,
              Image.asset(
                  UserLevelTool.cardBadge(UserLevelTool.currentRoleLevelEnum()),
                  width: 55.rw,
                  height: 55.rw,
                ),
              4.hb,
            ],
          ),
        ],
      ),
      Row(
        children: [
          10.wb,
          'NO.${UserManager.instance.indentifier}'
              .text
              .color(Color(0xFF333333))
              .size(10.rsp)
              .bold
              .make(),
          Spacer(),
          Builder(
            builder: (context) {
              DateTime createTime;
              if (!TextUtils.isEmpty(
                  UserManager.instance.user.info.createdAt)) {
                createTime =
                    DateTime.parse(UserManager.instance.user.info.createdAt);
              }
              return (createTime != null
                      ? '注册时间 ${createTime.year}-${createTime.month}-${createTime.day}'
                      : "")
                  .text
                  .color(Color(0xFF333333))
                  .size(10)
                  .make();
            },
          ),
          Spacer(),
          '(${UserLevelTool.currentRoleLevel()})'
              .text
              .color(Color(0xFF333333))
              .size(12.rsp)
              .make(),
          15.wb,
        ],
      ),
    ].column();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Stack(
      children: [
        SizedBox(
          height: 180.rw + ScreenUtil().statusBarHeight,
          child: Image.asset(
            R.ASSETS_USER_USER_APP_BAR_BG_WEBP,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 6.rw,
          right: 6.rw,
          bottom: 5.rw,
          child: Image.asset(
            UserLevelTool.userCardBackground,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 30.rw,
          right: 30.rw,
          bottom: 30.rw,
          child: _buildInnerInfo(),
        ),
      ],
    );
  }
}
