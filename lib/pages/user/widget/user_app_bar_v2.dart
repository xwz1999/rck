import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:recook/base/base_store_state.dart';
import 'package:recook/constants/api.dart';
import 'package:recook/constants/header.dart';
import 'package:recook/manager/meiqia_manager.dart';
import 'package:recook/manager/user_manager.dart';
import 'package:recook/utils/user_level_tool.dart';
import 'package:recook/widgets/custom_image_button.dart';

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomImageButton(
                onPressed: () => push(RouteName.USER_INFO_PAGE),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.w),
                    border: Border.all(
                      width: 1.w,
                      color: Color(0x8F979797),
                    ),
                  ),
                  position: DecorationPosition.foreground,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.w),
                    child: FadeInImage.assetNetwork(
                      height: 60.w,
                      width: 60.w,
                      placeholder: AppImageName.placeholder_1x1,
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
                  .size(20.sp)
                  .bold
                  .make(),
              10.hb,
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  CustomImageButton(
                    icon: ImageIcon(
                      AssetImage(
                        "assets/navigation_like.png",
                      ),
                      size: 18,
                    ),
                    title: "收藏",
                    fontSize: 10,
                    color: getCurrentAppItemColor(),
                    onPressed: () {
                      push(RouteName.MY_FAVORITE_PAGE);
                    },
                  ),
                  10.wb,
                  CustomImageButton(
                    // icon: Icon(AppIcons.icon_message),
                    icon: ImageIcon(
                      AssetImage("assets/navigation_msg.png"),
                      size: 18,
                    ),
                    title: "客服",
                    fontSize: 10,
                    color: getCurrentAppItemColor(),
                    onPressed: () {
                      MQManager.goToChat(
                          userId: UserManager.instance.user.info.id.toString(),
                          userInfo: <String, String>{
                            "name":
                                UserManager.instance.user.info.nickname ?? "",
                            "gender": UserManager.instance.user.info.gender == 1
                                ? "男"
                                : "女",
                            "mobile":
                                UserManager.instance.user.info.mobile ?? ""
                          });
                    },
                  ),
                ],
              ),
              12.hb,
              GestureDetector(
                onTap: () {
                  AppRouter.push(
                    globalContext,
                    RouteName.SHOP_PAGE_USER_RIGHTS_PAGE,
                  );
                },
                child: Image.asset(
                  UserLevelTool.cardBadge(UserLevelTool.currentRoleLevelEnum()),
                  width: 55.w,
                  height: 55.w,
                ),
              ),
              4.hb,
            ],
          ),
        ],
      ),
      Row(
        children: [
          'NO.${UserManager.instance.indentifier}'
              .text
              .color(Color(0xFF333333))
              .size(10.sp)
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
              .size(12.sp)
              .make(),
        ],
      ),
    ].column();
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Stack(
      children: [
        SizedBox(
          height: 180.w + ScreenUtil.statusBarHeight,
          child: Image.asset(
            R.ASSETS_USER_USER_APP_BAR_BG_WEBP,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 6.w,
          right: 6.w,
          bottom: 5.w,
          child: Image.asset(
            UserLevelTool.userCardBackground,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 30.w,
          right: 30.w,
          bottom: 24.w,
          child: _buildInnerInfo(),
        ),
      ],
    );
  }
}
