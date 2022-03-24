import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jingyaoyun/base/base_store_state.dart';
import 'package:jingyaoyun/constants/api.dart';
import 'package:jingyaoyun/constants/header.dart';
import 'package:jingyaoyun/gen/assets.gen.dart';
import 'package:jingyaoyun/manager/user_manager.dart';
import 'package:jingyaoyun/utils/user_level_tool.dart';
import 'package:jingyaoyun/widgets/custom_image_button.dart';
import 'package:velocity_x/velocity_x.dart';

class WholesaleUserAppBar extends StatefulWidget {
  WholesaleUserAppBar({Key key}) : super(key: key);

  @override
  _WholesaleUserAppBarState createState() => _WholesaleUserAppBarState();
}

class _WholesaleUserAppBarState extends BaseStoreState<WholesaleUserAppBar> {
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
          UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary
              ? SizedBox()
              : '(${UserLevelTool.currentRoleLevel()})'
                  .text
                  .color(Color(0xFF333333))
                  .size(12.rsp)
                  .make(),
          15.wb,
        ],
      ),
    ].column();
  }

  _info() {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      height: 95.rw,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          20.wb,
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
                  height: 50.rw,
                  width: 50.rw,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.rw),
                child: '${UserManager.instance.user.info.nickname}'
                    .text
                    .color(Colors.white)
                    .size(16.rsp)
                    .make(),
              ),
              5.hb,
              Padding(padding: EdgeInsets.only(left: 5.rw),child:           getStore().state.userBrief.end == '0001-01-01T00:00:00Z'
                  ? Container(
                padding: EdgeInsets.symmetric(horizontal:6.rw ),
                decoration: BoxDecoration(
                    color: Color(0xFFFEC17C),
                    borderRadius: BorderRadius.circular(2.rw)),
                child: Text(

                  'VIP店',
                  style: TextStyle(
                      fontSize: 10.rsp, color: Color(0xFF512309)),
                ),
              )
                  : Container(
                padding: EdgeInsets.symmetric(horizontal:6.rw ),
                decoration: BoxDecoration(
                    color: Color(0xFFFEC17C),
                    borderRadius: BorderRadius.circular(2.rw)),
                child: Text(
                  'VIP店有效期至 '+DateUtil.formatDate(
                      DateTime.parse(getStore().state.userBrief.end),
                      format: 'yyyy-MM-dd'),
                  style: TextStyle(
                      fontSize: 10.rsp, color: Color(0xFF512309)),
                ),
              ),),

              5.hb,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  10.wb,
                  Container(
                    child: 'NO.${UserManager.instance.indentifier}'
                        .text
                        .color(Colors.white)
                        .size(10.rsp)
                        .make(),
                  ),
                  20.wb,
                  Container(
                    padding: EdgeInsets.only(bottom: 2.rw),
                    alignment: Alignment.center,
                    child: (!TextUtils.isEmpty(
                                UserManager.instance.user.info.createdAt)
                            ? '注册时间 ${DateTime.parse(UserManager.instance.user.info.createdAt).year}-${DateTime.parse(UserManager.instance.user.info.createdAt).month}-${DateTime.parse(UserManager.instance.user.info.createdAt).day}'
                            : "")
                        .text
                        .color(Colors.white)
                        .size(10.rsp)
                        .make(),
                  ),
                  15.wb,
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _info2() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xFF3A3943), borderRadius: BorderRadius.circular(8.rw)),
      height: 92.rw,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          20.wb,
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
                  height: 48.rw,
                  width: 48.rw,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.rw),
                    child: '${UserManager.instance.user.info.nickname}'
                        .text
                        .color(Colors.white)
                        .size(16.rsp)
                        .make(),
                  ),
                ],
              ),
              20.hb,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  10.wb,
                  'NO.${UserManager.instance.indentifier}'
                      .text
                      .color(Colors.white)
                      .size(10.rsp)
                      .make(),
                  20.wb,
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.rw),
                    child: (!TextUtils.isEmpty(
                                UserManager.instance.user.info.createdAt)
                            ? '注册时间 ${DateTime.parse(UserManager.instance.user.info.createdAt).year}-${DateTime.parse(UserManager.instance.user.info.createdAt).month}-${DateTime.parse(UserManager.instance.user.info.createdAt).day}'
                            : "")
                        .text
                        .color(Colors.white)
                        .size(10.rsp)
                        .make(),
                  ),
                  15.wb,
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget buildContext(BuildContext context, {store}) {
    return Stack(
      children: [
        (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
                UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
            ? SizedBox(
                height: 180.rw + MediaQuery.of(context).padding.top,
                child: Image.asset(
                  R.ASSETS_USER_USER_APP_BAR_BG_WEBP,
                  fit: BoxFit.cover,
                ),
              )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
                UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
            ? Positioned(
                left: 6.rw,
                right: 6.rw,
                bottom: 5.rw,
                child: Image.asset(
                  UserLevelTool.userCardBackground,
                  fit: BoxFit.cover,
                ),
              )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.subsidiary &&
                UserLevelTool.currentRoleLevelEnum() != UserRoleLevel.physical)
            ? Positioned(
                left: 30.rw,
                right: 30.rw,
                bottom: 30.rw,
                child: _buildInnerInfo(),
              )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.physical)
            ? Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: 250.rw + MediaQuery.of(context).padding.top,
                child: Image.asset(
                  Assets.userVipBg.path,
                  fit: BoxFit.fill,
                ),
              )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary)
            ? Container(
                //padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
                height: 140.rw + MediaQuery.of(context).padding.top,

                child: Column(
                  children: [
                    Image.asset(
                      Assets.userPartnerBg.path,
                      fit: BoxFit.fill,
                    ),
                    16.hb,
                  ],
                ),
              )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.physical)
            ? Positioned(
                left: 30.rw,
                right: 30.rw,
                bottom: 25.rw,
                child: _info(),
              )
            : SizedBox(),
        (UserLevelTool.currentRoleLevelEnum() == UserRoleLevel.subsidiary)
            ? Positioned(
                left: 20.rw,
                right: 20.rw,
                bottom: 0.rw,
                child: _info2(),
              )
            : SizedBox(),
      ],
    );
  }
}
